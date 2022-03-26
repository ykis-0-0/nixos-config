{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  home.packages = with pkgs; [ asciinema nix-index ];

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
    };
  };
}
