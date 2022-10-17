{ config, lib, pkgs, ... }:{
  config = let
    selfCfg = config.services.papermc;
    papermc-scripts = let
      dependencies = builtins.toJSON (builtins.mapAttrs (_: builtins.toString) {
        inherit (pkgs)
          # updater.sh
          wget jq
          # bootstrapper.sh
          abduco
          # ban_hammer.sh
          extrace
        ;
      });
    in pkgs.stdenvNoCC.mkDerivation {
      name = "systemd-papermc-utils";
      src = ./scripts;

      nativeBuildInputs = with pkgs; [ mustache-go ];
      passAsFile = [ "dependencies" ];
      inherit dependencies;

      # dontUnpack = true;
      dontPatch = true;
      dontConfigure = true;
      #dontBuild = true;
      # HACK /dev/stdin isn't in POSIX,
      #      but since this is already NixOS we could tolerate it
      buildPhase = ''
        mkdir "$out"
        for object in ./*.mustache.*; do
          echo "$object"
          mustache "$dependenciesPath" "$object" | install -m 0755 /dev/stdin "$out/''${object%.mustache.sh}.sh"
        done
      '';
      dontInstall = true;
      # dontFixup = true;
    };
  in lib.mkIf selfCfg.enable {
    systemd = {
      timers.sched-reboot.conflicts = [ "papermc.service" ];

      services.papermc = {
        enable = true;
        description = "PaperMC Minecraft dedicated server Instance";

        path = with pkgs; [
          selfCfg.packages.jre # required by bootstrapper.sh
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
          # Startup modes
          Type = "forking";
          Restart = "no";

          # Deactivation strategy
          TimeoutStopSec = "3 min";
          AmbientCapabilities = "CAP_NET_ADMIN";

          # Access control
          DynamicUser = "yes";
          User = "papermc";
          Group = "papermc";

          # Paths
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
          UMask = "007";

          # Lifecycle workers
          ExecStartPre = "${papermc-scripts}/updater.sh";
          ExecStart = "${papermc-scripts}/bootstrapper.sh launch /run/${RuntimeDirectory}/abduco.sock ${selfCfg.packages.jre}/bin/java @${argsFile}";
          ExecStop = "${papermc-scripts}/ban_hammer.sh";
        };
      };
    };
  };
}
