{ config, lib, pkgs, nixos-hardware, ... }: {
  imports = [
    ./configuration.nix
    nixos-hardware.nixosModules.raspberry-pi-4
    ./hardware.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
