{ config, lib, ... }: {

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/cloudimg-rootfs";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-label/UEFI";
      fsType = "vfat";
    };
  };

  boot.loader.grub.copyKernels = lib.mkForce false;
}
