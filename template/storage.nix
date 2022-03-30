{ lib, impermanence, ... }:
let
  doImpermanence = false; # Set to true to enable impermanence
  persistRoot = {
    mountpoint = "/persist";
    device = "/dev/sda2";
  };
  earlyBinds = [ "/boot" "/nix" ];
  maybePersistenceSetup = if doImpermanence then {
    imports = [ impermanence.nixosModule ];

    environment.persistence.${persistRoot.mountpoint} = {
      directories = [
        {
          directory = "/etc/nixos";
          user = "root";
          group = "wheel";
          mode = "0774";
        }
        "/var/lib"
        "/var/log"
        "/root"
        "/home"
      ];
      files = [
        "/etc/machine-id"
      ];
    };
  } else {};
  #region Miscellaneous Functions

  _mkPersist = onInitrd: mountPoint: source: {
    name = mountPoint;
    value = {
      device = source;
      options = [ "bind" ];
      neededForBoot = onInitrd;
    };
  };
  mkPersist = mountPoint: _mkPersist true mountPoint (persistRoot.mountpoint + mountPoint);

  #endregion End Miscellaneous Functions
  in maybePersistenceSetup // {
  fileSystems = {
    ${if doImpermanence then persistRoot.mountpoint else "/"} = {
      device = persistRoot.device;
      fsType = "ext4";
      options = [ "noatime" ];
      neededForBoot = true;
    };

    "/boot/FIRMWARE" = {
      device = "/dev/sda1";
      fsType = "vfat";
      options = [ "noatime" ];
    };
  } // (
    if !doImpermanence then {}
    else {
      "/" = {
        device = "none";
        fsType = "tmpfs";
        options = [ "size=1G" "mode=0755" ]; # 0700 will make SSH pubkey refuse to work
      };
    } // builtins.listToAttrs (map mkPersist earlyBinds)
  );
}
