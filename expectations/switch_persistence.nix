{ lib, pkgs, config, options, ... }:
{
  options.maybePersistence = let
    inherit (lib) mkOption mkEnableOption types;
  in {
    persistPlane = {
      junction = mkOption {
        description = "Mount point fot the persistent storage";
        type = types.path;
      };
      fstabOptions = mkOption {
        description = "Mount options to be used in `/etc/fstab`";
        # type = options.fileSystems.type.nestedTypes.elemType;
      };
    };

    elevatedPlane = {
      enable = mkEnableOption "Whether to use the impermanent tmpfs root";
      mountOptions = mkOption {
        description = "Mount options to be used in `/etc/fstab`";
        default = [ "defaults" ];
        example = [ "data=journal" ];
        type = let
          addCheckDesc = desc: elemType: check: types.addCheck elemType check
            // { description = "${elemType.description} (with check: ${desc})"; };
          isNonEmpty = s: (builtins.match "[ \t\n]*" s) == null;
          nonEmptyStr = addCheckDesc "non-empty" types.str isNonEmpty;
        in
          types.listOf nonEmptyStr;
      };
    };

    earlyBinds = mkOption {
      description = "Directories to be bind-mounted early in /etc/fstab";
      type = types.listOf types.path;
    };

    extraMounts = mkOption {
      description = "Additional fixed mount point to other devcices";
      inherit (options.fileSystems) type;
    };

    junctions = mkOption {
      description = "Options to be delegated to `environment.persistence`";
      # type = options.environment.persistence.type.nestedTypes.elemType; # Is this really ok?
    };
  };

  config = let
    inherit (lib) mkIf optionalAttrs;
    self = config.maybePersistence;
    epEnabled = self.elevatedPlane.enable;
    persistPlaneMountPoint = if epEnabled then self.persistPlane.junction else "/";
  in {
    environment = optionalAttrs epEnabled {
      persistence.${self.persistPlane.junction} = self.junctions;
    };

    fileSystems = lib.mkMerge (
      [
        {
          # Persist mount or rootfs
          ${persistPlaneMountPoint} = self.persistPlane.fstabOptions // {
            neededForBoot = true;
          };
        }
        (mkIf epEnabled {
          "/" = {
            device = "none";
            fsType = "tmpfs";
            options = self.elevatedPlane.mountOptions;
          };
        })
      ]
      ++ lib.mapAttrsToList (name: value: { ${name} = value; }) self.extraMounts
      ++ builtins.map (path: mkIf epEnabled {
        ${path} = {
          device = self.persistPlane.junction + path;
          options = [ "bind" ];
          neededForBoot = true;
        };
      }) self.earlyBinds
    );
  };
}
