{ config, lib, pkgs, nixos, ... }: {
  imports = [
    ./configuration.nix
    ./hardware.nix
    "${nixos}/nixos/modules/profiles/qemu-guest.nix"
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
