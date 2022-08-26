{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home = {
    stateVersion = "22.11";
    enableNixpkgsReleaseCheck = true;

    packages = with pkgs; [
      nvd nix-diff nix-tree nix-index
    ];
  };

  programs.home-manager.enable = true;
}
