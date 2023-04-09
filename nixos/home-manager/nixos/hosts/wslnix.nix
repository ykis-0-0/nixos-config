{ config, lib, pkgs, manix, ... }:
let
  hmlib = config.lib;
in {

  import = [
    ./wslnix/keeagent.nix # KeeAgent NPipeRelay runner
  ];

  nix.registry.deploy-rs = {
    from = {
      type = "indirect";
      id = "deploy-rs";
    };

    to = {
      type = "github";
      owner = "serokell";
      repo = "deploy-rs";
    };
  };

  home = {
    packages = with pkgs; [
      wget
      git
      rnix-lsp nil
      manix
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

  programs.bash.enable = true; # HACK Temporary fix, should be replaced by something like fish soon?
}
