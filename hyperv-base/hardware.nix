{
  boot = {
    kernelModules = [];
    extraModulePackages = [];

    initrd = {
      availableKernelModules = [ "sd_mod" "sr_mod" ];
      kernelModules = [];
    };

    loader = {
      efi.canTouchEfiVariables = true;
      # grub = {
      #   enable = true;
      #   version = 2;
      #   device = "/dev/sda";
      # };
      systemd-boot.enable = true;
    };
  };

  virtualisation.hypervGuest.enable = true;

  swapDevices = [];

  hardware = {
    enableRedistributableFirmware = true;
    # cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
    pulseaudio.enable = true;
  };
}
