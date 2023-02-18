{ config, lib, pkgs, options, ... }: {
  options.services.papermc = let
    inherit (lib) types mkOption mkEnableOption mkPackageOption;
  in {
    enable = mkEnableOption "the PaperMC Minecraft dedicated server";

    # IDEA pipe outputs to systemd journal
    # Blame and revert me to recover progress
    # systemd-verbose = mkEnableOption "logging PaperMC console output to Systemd Journal (for debugging purposes only)";

    startOnBoot = mkEnableOption "Make PaperMC start when the machine boots";

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
      bin = "binaries";
      etc = "configuration files";
      worlds = "world saves";
      log = "logs";
      plugins = "plugins";
      cache = "binary cache";
    };

    cliArgs = {
      jvm = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra arguments to specify for the JVM when launching the server.\
          `-Xmx` and `-Xms` should be set via `services.papermc.memory`.\
          Multiple definitions will be merged in an unknown order.
        '';
      };

      papermc = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra arguments to specify for PaperMC itself when launching the server.\
          Multiple definitions will be merged in an unknown order.
        '';
      };
    };

    admins = mkOption {
      # Allows direct reference to nixos users
      # type = types.listOf (types.passwdEntry types.str);
      type = types.listOf options.users.users.type.nestedTypes.elemType;
      default = [];
      example = "with config.users.users; [ alice beter carlie ]";
      description = "List of users to grant access to server files";
    };
  };
}
