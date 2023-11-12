{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home = {
    stateVersion = "23.05";
    enableNixpkgsReleaseCheck = true;

    packages = with pkgs; [
      nvd nix-diff nix-tree nix-index
    ];
  };

  programs.home-manager.enable = true;
}
