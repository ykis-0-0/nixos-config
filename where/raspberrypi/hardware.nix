{ nixos-hardware, ... }:
{
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

    /*
    # BUG THESE ALL BROKEN
    raspberry-pi."4" = {
      audio.enable = true;
      fkms-3d.enable = true;
    };
    */

    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";
}
