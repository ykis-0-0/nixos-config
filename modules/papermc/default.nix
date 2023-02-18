{ config, lib, pkgs, ... }: {

  # IDEA Decouple this Module into a separate Nix flake
  # IDEA Consider debrand PaperMC since this Module should be capable
  # to handle other variants beyond only PaperMC

  imports = [
    ./facets/options.nix
    ./facets/service.nix
    ./facets/access.nix
    ./sidecars/borgbase.nix
    ./sidecars/discord.nix
  ];

}
