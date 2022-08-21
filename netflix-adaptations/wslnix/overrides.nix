{ config, lib, pkgs, ... }: {

  users.users.nixos.password = "nixos"; # Yes cleartext password here who can get inside wsl anyway?

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ]; # For testing aarch64 flakes?
}
