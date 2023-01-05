{ config, lib, pkgs, ... }: {

  networking.hostName = "wslnix";

  wsl = {
    enable = true;
    nativeSystemd = true;
    defaultUser = "nixos";

    wslConf = {
      automount.root = "/mnt";
      network.hostname = "wslnix";
      interop.appendWindowsPath = false;
    };

    interop = {
      register = true;
      includePath = false;
    };

    docker-desktop.enable = true;
  };

  # WSL (regardless of 1 or 2) doesn't support X11, so it may help saving space
  environment.noXlibs = true;

  users.users.root.hashedPassword = null;

  programs.ssh.startAgent = true;

}
