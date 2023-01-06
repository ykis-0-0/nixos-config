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

  users.users.root.hashedPassword = null;

  programs.ssh.startAgent = true;

}
