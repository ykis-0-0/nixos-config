{ config, lib, ... }: {

  fileSystems = {
    "/" = {
      device =  "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = [ "defaults" ];
    };

    "/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
      options = [ "noatime" ];
    };
  };
}
