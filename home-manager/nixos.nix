{ config, pkgs, ... }:
{
  imports = let
    vscode-srv = fetchGit {
      url = "https://github.com/santicalcagno/nixos-vscode-server.git"; # "https://github.com/msteen/nixos-vscode-server.git";
      ref = "master";
    };
  in [ "${vscode-srv}/modules/vscode-server/home.nix" ];

  home = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = "nixos";
    homeDirectory = "/home/nixos";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "22.05";

    enableNixpkgsReleaseCheck = true;

    packages = with pkgs; [
      nix-index nvd nix-tree
      jq yq-go
      asciinema deno
      # taskwarrior
      # broot eww
      # dogdns
    ];

    # Useless unless we manage shell here lol
    shellAliases = {
      hm-install = "";
    };
  };

  services = {
    vscode-server.enable = true;
  };

  programs = {
    # Let Home Manager install and manager itself.
    home-manager = {
      enable = true;
    };

    git = {
      enable = true;
      userName = "ykis-0-0";
      userEmail = "64165725+ykis-0-0@users.noreply.github.com";

      aliases = {
        graph = "log --graph '--pretty=tformat:%C(auto)%h%C(dim white)% ci%C(auto)% G?%d%n  [%cN]:% s'";
      };

      extraConfig = {
        credential.helper = "store";
      };
    };
  };
}
