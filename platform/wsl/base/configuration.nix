{ config, pkgs, lib, ... }: {
  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "nixos";
    wslConf = {
      network.hostname = "wslnix";
    };
  };

  # WSL (regardless of 1 or 2) doesn't support X11, so it may help saving space
  environment.noXlibs = true;
}
