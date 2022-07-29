{ impermanence, ... }:
let
  doImpermanence = false;
in {
  imports = if doImpermanence then [ impermanence.nixosModule ] else [];

  maybePersistence = {
    persistPlane = {
      junction = "/persist";
      fstabOptions = {
        device = "/dev/sda2";
        fsType = "ext4";
        options = [ "noatime" ];
      };
    };

    elevatedPlane = {
      enable = doImpermanence;
      mountOptions = [ "noatime" "size=1G" "mode=0755" ]; # 0700 will make SSH pubkey refuse to work
    };

    earlyBinds = [ "/nix" ];

    extraMounts = {
      "/boot" = {
        device = "/dev/sda1";
        fsType = "vfat";
        options = [ "noatime" ];
      };
    };

    junctions = {
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
  };
}
