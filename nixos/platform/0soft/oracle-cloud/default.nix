{ config, lib, pkgs, nixos, ... }: {
  imports = [
    ./configuration.nix
    ./hardware.nix
    "${nixos}/nixos/modules/profiles/qemu-guest.nix"
  ];
}
