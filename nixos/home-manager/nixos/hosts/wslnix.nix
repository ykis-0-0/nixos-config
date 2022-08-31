{ config, lib, pkgs, ... }:
let
  hmlib = config.lib;
in {
  home = {
    packages = with pkgs; [
      git
      wget
      rnix-lsp
    ];

    file = {
      wsl-desktop = {
        source = hmlib.file.mkOutOfStoreSymlink "/mnt/c/Users/YouSuck/Desktop/";
        recursive = false;
      };
    };
  };

  services = {
    vscode-server.enable = true;
  };
}
