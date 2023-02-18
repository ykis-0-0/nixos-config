{ impermanence, ... }: {

  maybePersistence = {
    persistPlane = {
      junction = "/persist";
      fstabOptions = {
        device = "/dev/disk/by-name/NIXOS_SD";
        fsType = "ext4";
        options = [ "noatime" ];
      };
    };

    elevatedPlane = {
      enable = true;
      mountOptions = [ "noatime" "size=3G" "mode=0755" ]; # 0700 will make SSH pubkey refuse to work
    };

    earlyBinds = [ "/boot" "/nix" ];

    extraMounts = {
      "/boot/FIRMWARE" = {
        device = "/dev/disk/by-name/FIRMWARE";
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
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };
  };
}
