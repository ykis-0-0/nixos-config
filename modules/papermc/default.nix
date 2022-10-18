{ config, lib, pkgs, ... }: {

  imports = [
    ./options.nix
    ./service.nix
    ./borgbase.nix
    ./discord.nix
    ./access.nix
  ];

}
