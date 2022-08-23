{ config, lib, ... }: {

  fileSystems = {
    "/" = {
      device = "/dev/sda2";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/boot" = {
      device = "/dev/sda1";
      fsType = "vfat";
      options = [ "noatime" ];
    };
  };
}
