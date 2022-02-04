{
  imports =
    let
      nixos-hardware = {
        url = "https://github.com/NixOS/nixos-hardware.git";
        ref = "master";
      };
    in
      # [] ++ map builtin.toString ((map fetchTarball []) ++ (map fetchGit [ nixos-hardware ]));
      [ "${fetchGit nixos-hardware}/raspberry-pi/4" ];

  boot = {
    # kernelPackages = pkgs.linuxPackages_rpi4; # done in <nixos-hardware>
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" "uas" "vc4" ];
    loader.raspberryPi = {
      enable = true;
      version = 4;
    };
  };

  hardware = {
    pulseaudio.enable = true;

    raspberry-pi."4" = {
      audio.enable = true;
      fkms-3d.enable = true;
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

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
