{ config, lib, pkgs, ... }: {

  # TODO Consider debrand PaperMC since this Module should be capable
  # to handle other variants beyond only PaperMC

  imports = [
    ./options.nix
    ./service.nix
    ./borgbase.nix
    ./discord.nix
    ./access.nix
  ];

}
