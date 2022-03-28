{ nixos-hardware, ... }:
{
  imports = [ nixos-hardware.nixosModules.raspberry-pi-4 ];

  boot = {
    # kernelPackages = pkgs.linuxPackages_rpi4; # done in <nixos-hardware>
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" "uas" "vc4" ];

    /* loader.raspberryPi = {
      enable = true;
      version = 4;
    }; */
  };

  hardware = {
    pulseaudio.enable = true;

    raspberry-pi."4" = {
      audio.enable = true;
      fkms-3d.enable = true;
    };

    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  fileSystems = {
    "/" = {
      device = "/dev/sda2";
      fsType = "ext4";
      options = [ "noatime" ];
    };

    "/boot/FIRMWARE" = {
      device = "/dev/sda1";
      fsType = "vfat";
      options = [ "noatime" ];
    };
  };
}
