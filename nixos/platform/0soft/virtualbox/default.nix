{ config, lib, pkgs, ... }: {
  imports = [
    ./configuration.nix
    ./hardware.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
