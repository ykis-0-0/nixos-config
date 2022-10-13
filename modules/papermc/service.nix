{ config, lib, pkgs, ... }:{
  config = let
    selfCfg = config.services.papermc;
    papermc-scripts = pkgs.stdenvNoCC.mkDerivation {
      name = "systemd-papermc-utils";
      src = ./scripts;

      # dontUnpack = true;
      dontPatch = true;
      dontConfigure = true;
      dontBuild = true;
      # dontInstall = true;
      installPhase = ''
        mkdir "$out"
        install -m 0755 -t "$out" ./*
      '';
      # dontFixup = true;
    };
  in lib.mkIf selfCfg.enable {
    systemd = {
      timers.sched-reboot.conflicts = [ "papermc.service" ];

      services.papermc = {
        enable = true;
        description = "PaperMC Minecraft dedicated server Instance";

        path = with pkgs; [
          wget jq # required by updater.sh
          abduco selfCfg.packages.jre # required by bootstrapper.sh
        ];

        environment = {
          MINECRAFT_VERSION = selfCfg.packages.papermc.version;
          PAPER_BUILD = toString selfCfg.packages.papermc.build; # builtins.toString will map null to ""
          BIN_DIR = let
            inherit (config.systemd.services.papermc.serviceConfig) RuntimeDirectory;
          in "/run/${RuntimeDirectory}/bin/"; # toString selfCfg.storages.bin;

          TZ = config.time.timeZone;
        };

        serviceConfig = let
          RuntimeDirectory = "ykis/papermc";

          folders = builtins.mapAttrs (_: builtins.toString) selfCfg.storages;
          memory = builtins.mapAttrs (_: builtins.toString) selfCfg.memory;

          argsFile = pkgs.writeText "papermc-jvm-args" ''
            -Xms${memory.min}M
            -Xmx${memory.max}M

            # Extra JVM Options
            ${selfCfg.cliArgs.jvm}
            # End JVM Extra Options

            -jar /run/${RuntimeDirectory}/bin/paper.jar
            --nogui
            --world-container /run/${RuntimeDirectory}/worlds/
            --plugins /run/${RuntimeDirectory}/plugins/
            --port ${toString selfCfg.port}

            # Extra PaperMC Options
            ${selfCfg.cliArgs.papermc}
            # End PaperMC Extra Options
          '';
        in {
          Type = "forking";
          Restart = "no";

          inherit RuntimeDirectory;
          RuntimeDirectoryPreserve = "restart";
          BindPaths = [
            "${folders.bin}/:/run/${RuntimeDirectory}/bin/"
            "${folders.plugins}/:/run/${RuntimeDirectory}/plugins/"
            "${folders.worlds}/:/run/${RuntimeDirectory}/worlds/"
            "${folders.etc}/:/run/${RuntimeDirectory}/etc/"
            "${folders.log}/:/run/${RuntimeDirectory}/etc/logs/"
            "${folders.cache}/:/run/${RuntimeDirectory}/etc/cache/"
          ];
          WorkingDirectory = "/run/${RuntimeDirectory}/etc";

          ExecStartPre = "${papermc-scripts}/updater.sh";
          ExecStart = "${papermc-scripts}/bootstrapper.sh launch /run/${RuntimeDirectory}/abduco.sock ${selfCfg.packages.jre}/bin/java @${argsFile}";
        };
      };
    };
  };
}
