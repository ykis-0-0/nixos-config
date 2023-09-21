{ config, lib, pkgs, impermanence, ... }: {

  maybePersistence = {
    persistPlane = {
      junction = "/persist";
      fstabOptions = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
        options = [ "noatime" ];
      };
    };

    elevatedPlane = {
      enable = lib.mkDefault true;
      mountOptions = [ "noatime" "size=3G" "mode=0755" ]; # 0700 will make SSH pubkey refuse to work
    };

    earlyBinds = [ "/boot" "/nix" ];

    extraMounts = {
      "/boot/FIRMWARE" = {
        device = "/dev/disk/by-label/FIRMWARE";
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
        "/tmp"
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

  boot.tmp.cleanOnBoot = lib.mkDefault true;
}
