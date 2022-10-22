{ config, lib, pkgs, nixos-wsl, ... }: {
  imports = [
    ./configuration.nix
    nixos-wsl.nixosModules.wsl
  ];
}
