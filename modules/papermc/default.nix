{ config, lib, pkgs, ... }:{
  options.services.papermc = let
    inherit (lib) types mkOption mkEnableOption mkPackageOption;
  in {
    enable = mkEnableOption "the PaperMC Minecraft dedicated server";
    systemd-verbose = mkEnableOption "logging PaperMC console output to Systemd Journal (for debugging purposes only)";

    port = mkOption {
      type = types.port;
      default = 25565;
      description = "TCP & UDP port for PaperMC to bind against";
    };

    memory = let
      mkMemOpt = valType: defVal: mkOption {
        type = types.ints.positive;
        default = defVal;
        description = "${valType} size of the JVM Heap, in MiB";
      };
    in {
      min = mkMemOpt "Minimum" 1024;
      max = mkMemOpt "Maximum" 4096;
    };

    packages = {
      jre = mkPackageOption pkgs "JRE" { default = [ "temurin-jre-bin" ]; };

      papermc = {
        version = mkOption {
          type = types.str;
          description = "Minecraft version to run PaperMC on";
        };
        build = mkOption {
          type = types.nullOr types.ints.unsigned;
          default = null;
          description = "PaperMC build to pin against, or `null` to use latest";
        };
      };
    };

    storages = let
      mkStorageOpt = key: type: mkOption {
        type = types.path;
        description = "Location of ${type} for PaperMC";
      };
    in builtins.mapAttrs mkStorageOpt {
      # srv-root = "Server root directory"; # FIXME think again of whether really include it
      bin = "binaries";
      etc = "configuration files";
      worlds = "world saves";
      log = "logs";
      plugins = "plugins";
      cache = "binary cache";
    };

    # TODO extraArgs for both JVM and PaperMC?
  };

  config = let
    selfCfg = config.services.papermc;
    importShellScript = drvName: path: let
      scriptContent = builtins.readFile path;
      patcher = final: prev: {
        buildCommand = ''
          ${prev.buildCommand}

          patchShebangs $out
        '';
      };
    in (pkgs.writeScript drvName scriptContent).overrideAttrs patcher;
  in lib.mkIf selfCfg.enable {
    systemd = {
      services = {
        papermc = {
          enable = true;
          description = "PaperMC Minecraft dedicated server Instance";

          path = with pkgs; [
            wget jq # required by ./update_check.sh
          ];
          environment = {
            MINECRAFT_VERSION = selfCfg.packages.papermc.version;
            PAPER_BUILD = toString selfCfg.packages.papermc.build; # builtins.toString will map null to ""
            BIN_DIR = toString selfCfg.storages.bin;

            TZ = config.time.timeZone;
          };

          serviceConfig = let
            folders = builtins.mapAttrs (_: builtins.toString) selfCfg.storages;
            memory = builtins.mapAttrs (_: builtins.toString) selfCfg.memory;
          in let
            RuntimeDirectory = "ykis/papermc";
          in{
            Type = if selfCfg.systemd-verbose then "simple" else "forking";
            Restart = "no";

            inherit RuntimeDirectory;
            BindPaths = [
              # "${folders.srv-root}/:/run/${RuntimeDirectory}/" # FIXME Do we really need to bind the server root? Aren't we inside a docker, are we?
              "${folders.bin}/:/run/${RuntimeDirectory}/bin/"
              "${folders.plugins}/:/run/${RuntimeDirectory}/plugins/"
              "${folders.worlds}/:/run/${RuntimeDirectory}/worlds/"
              "${folders.etc}/:/run/${RuntimeDirectory}/etc/"
              "${folders.log}/:/run/${RuntimeDirectory}/etc/logs/"
              "${folders.cache}/:/run/${RuntimeDirectory}/etc/cache/"
            ];
            WorkingDirectory = "/run/${RuntimeDirectory}/etc";

            ExecStartPre = importShellScript "papermc-startpre-update-check" ./scripts/updater.sh;
            ExecStart = let
              argsFile = pkgs.writeText "papermc-jvm-args" ''
                -Xms${memory.min}M
                -Xmx${memory.max}M

                -jar /run/${RuntimeDirectory}/bin/paper.jar
                --nogui
                --world-container /run/${RuntimeDirectory}/worlds
                --plugins /run/${RuntimeDirectory}/plugins/
                --port ${toString selfCfg.port}
              '';
            in
              "${pkgs.abduco}/bin/abduco -r ${if selfCfg.systemd-verbose then "-c" else "-n"} /run/${RuntimeDirectory}/abduco.sock ${selfCfg.packages.jre}/bin/java @${argsFile}";
          };
        };

        # TODO Discord Webhook notifier service definition
        discord-prophet = {};

        # TODO BorgBase backup service definition
        borgbase-mcbackup = {};
      };

      timers.sched-reboot.conflicts = [ "papermc.service" ];
    };
  };

  /*
    HACK Thing to be designed in regard to the  minecraft server infrastructure
    - Main Server Instance
      1. How should the connection between the binary and systemd be established? dtach / abduco?
      2. Should the updater be put at ExecPreStart?
    - BorgBase backup runner
      1. How often should the runner be triggered?
      2. And from which side (systemd / instance)?
        a. If we use systemd, how should we instruct the instance to not touch the save / make a local snapshot?
    - Discord Webhook postman
      1. How should we trigger the webhook? (systemd / instance)?
  */
}
