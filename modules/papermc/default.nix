{ config, lib, pkgs, ... }: {

  imports = [
    ./options.nix
    ./service.nix
    ./borgbase.nix
    ./discord.nix
  ];

  config = {
    users.groups.papermc.name = "Minecraft PaperMC server administrators";
  };
}
