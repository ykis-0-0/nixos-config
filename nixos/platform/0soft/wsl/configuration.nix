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

    # BUG https://github.com/nix-community/NixOS-WSL/issues/235
    # docker-desktop.enable = true;
  };

  users.users.root.hashedPassword = null;

}
