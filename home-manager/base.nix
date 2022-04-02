{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home = {
    enableNixpkgsReleaseCheck = true;

    packages = with pkgs; [
      nvd nix-diff nix-tree nix-index
    ];
  };

  programs.home-manager.enable = true;
}
