{ config, lib, pkgs, modulesPath, ... }: {
  imports = [
    ./configuration.nix
    ./hardware.nix
    "${modulesPath}/profiles/qemu-guest.nix"
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
