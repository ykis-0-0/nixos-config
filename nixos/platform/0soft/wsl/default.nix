{ config, lib, pkgs, nixos-wsl, ... }: {
  imports = [
    ./configuration.nix
    nixos-wsl.nixosModules.wsl
    ./systemd-fix.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
