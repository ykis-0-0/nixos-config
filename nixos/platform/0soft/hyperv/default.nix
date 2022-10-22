{ config, lib, pkgs, ... }: {
  imports = [
    ./configuration.nix
    ./hardware.nix
  ];
}
