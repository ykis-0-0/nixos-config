{ config, lib, pkgs, ... }: {

  services = {
    udev.packages = [ pkgs.yubikey-personalization ];

    pcscd.enable = true;
  };

  # TODO find ways to incorporate YubiKey into infrastructure
}
