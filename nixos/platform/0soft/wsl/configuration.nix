{ config, lib, pkgs, ... }: {

  networking.hostName = "wslnix";

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "nixos";
    wslConf = {
      network.hostname = "wslnix";
    };

    interop.register = true;

    docker-desktop.enable = true;
  };

  # WSL (regardless of 1 or 2) doesn't support X11, so it may help saving space
  environment.noXlibs = true;

  users.users.root.hashedPassword = null;

  programs.ssh.startAgent = true;

}
