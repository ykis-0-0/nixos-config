{ config, lib, pkgs, manix, ... }:
let
  hmlib = config.lib;
in {

  imports = [
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

    shellAliases = {
      nixssh = ''NIX_SSHOPTS="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" nix '';
    };
  };

  services = {
    vscode-server.enable = true;
  };

  programs.bash = {
    enable = true; # HACK Temporary fix, should be replaced by something like fish soon?
    historyControl = [ "ignorespace" "erasedups" ];
  };

  # Introduce delta
  programs.git = {
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;

        line-numbers = true;
      };
    };

    extraConfig = {
      merge.conflictstyle = "diff3";
      diff = {
        colorMoved = "dimmed-zebra";
        colorMovedWS = "allow-indentation-change";
      };
    };
  };
}
