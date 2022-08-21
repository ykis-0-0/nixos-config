{ config, lib, pkgs, ... }: {

  networking.wireless = {
    enable = true; # Enables wireless support via wpa_supplicant.
    # interfaces = []; # A shared instance is enough for Pi
    extraConfig = ''
      country=HK
    ''; # We need this to properly connect and have 5GHz, good thing!
    userControlled.enable = true;
  };
}
