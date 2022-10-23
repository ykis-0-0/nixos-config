{ config, lib, pkgs, ... }: let
  selfCfg = config.services.papermc;

  # The RuntimeDirectory directive is used in various places in this component,
  # therefore it is extracted here to maintain some flexibility in case we fucked up
  # on this particular place
  RuntimeDirectory = "ykis/papermc";

  # MountTargetName is the conglomerate of various mount points required to build a
  # transient filesystem tree for PaperMC to run on without exposing too much
  MountTargetName = "papermc-mounts";

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
    # dontBuild = true;
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

  argsFile = let
    memory = builtins.mapAttrs (_: builtins.toString) selfCfg.memory;
  in pkgs.writeText "papermc-jvm-args" ''
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

  bindPoints = let
    folders = builtins.mapAttrs (_: builtins.toString) selfCfg.storages;
  in [
    [ "bin" folders.bin ]
    [ "plugins" folders.plugins ]
    [ "worlds" folders.worlds ]
    [ "etc" folders.etc ]
    [ "etc/logs" folders.log ]
    [ "etc/cache" folders.cache ]
  ];

in lib.mkIf selfCfg.enable {
  systemd = {
    services.papermc = {
      enable = true;
      description = "PaperMC Minecraft dedicated server Instance";

      wants = lib.optional selfCfg.startOnBoot "network-online.target";
      requires = [ "${MountTargetName}.target" ];
      after = [ "${MountTargetName}.target" ] ++ lib.optional selfCfg.startOnBoot "network-online.target";
      conflicts = [ "sched-reboot.timer" ];

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

      serviceConfig = {
        # Startup modes
        Type = "forking";
        Restart = "no";

        # Deactivation strategy
        TimeoutStopSec = "3 min";
        AmbientCapabilities = "CAP_NET_ADMIN";

        # Access control
        User = "papermc";
        Group = "papermc";

        # Paths
        inherit RuntimeDirectory;
        RuntimeDirectoryPreserve = "restart";
        WorkingDirectory = "/run/${RuntimeDirectory}/etc";
        UMask = "002";

        # Lifecycle workers
        ExecStartPre = "${papermc-scripts}/updater.sh";
        ExecStart = "${papermc-scripts}/bootstrapper.sh launch /run/${RuntimeDirectory}/abduco.sock ${selfCfg.packages.jre}/bin/java @${argsFile}";
        ExecStartPost = "${papermc-scripts}/backdoor_backdoor.sh";
        ExecStop = "${papermc-scripts}/ban_hammer.sh";
      };
    };

    targets.${MountTargetName} = let
      escapeSystemdPath = s:
        lib.replaceChars ["/" "-" " "] ["-" "\\x2d" "\\x20"]
        (lib.removePrefix "/" s);
      mountUnitNames = map (point: escapeSystemdPath "/run/${RuntimeDirectory}/${builtins.head point}" + ".mount" ) bindPoints;
    in {
      enable = true;
      description = "PaperMC Runtime File System Tree";
      requires = mountUnitNames;
      after = mountUnitNames;
    };

    mounts = let
      id = _: _; # I'm lazy

      genMountUnit = type: srcDir: {
        enable = true;
        description = "Required Bind Mountpoints [${type}] for PaperMC SystemD service";
        before = [ "${MountTargetName}.target" ];

        where = "/run/${RuntimeDirectory}/${type}";
        what = toString srcDir;
        type = "none";
        options = "bind";

        unitConfig = {
          StopPropagatedFrom = "papermc.service";
        };
      };

    in map (builtins.foldl' id genMountUnit) bindPoints;
  };
}
