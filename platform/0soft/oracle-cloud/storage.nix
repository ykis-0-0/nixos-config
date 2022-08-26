{ config, lib, ... }: {

  fileSystems = {
    "/" = {
      device = "/dev/ocivolume/root";
      fsType = "xfs";
    };

    "/boot" = {
      device = "/dev/sda2";
      fsType = "xfs";
    };

    "/boot/efi" = {
      device = "/dev/sda1";
      fsType = "vfat";
    };

    "/var/oled" = {
      device = "/dev/ocivolume/oled";
      fsType = "xfs";
    };
  };
}
