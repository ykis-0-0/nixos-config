{ config, lib, pkgs, ... }: {
  boot = {
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };

    initrd = {
      availableKernelModules =
        [ "ata_piix" "uhci_hcd" "xen_blkfront" ] ++ # From nixos-infect
        [ "xfs" "button" "virtio_gpu" "qemu_fw_cfg" "nvme_tcp" "dm_multipath" ]; # Manually added
      kernelModules = [ "nvme" ]; # From nixos-infect
    };
  };
}
