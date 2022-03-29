{
  boot = {
    kernelModules = [];
    initrd = {
      availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "sd_mod" "sr_mod" ];
      kernelModules = [];
    };
    extraModulePackages = [];


    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        version = 2;
        device = "/dev/sda";
      };
      # systemd-boot.enable = true;
    };
  };

  virtualisation.virtualbox.guest.enable = true;

  swapDevices = [];

  hardware = {
    enableRedistributableFirmware = true;
    # cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
    pulseaudio.enable = true;
  };
}
