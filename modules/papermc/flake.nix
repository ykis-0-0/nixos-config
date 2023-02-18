{
  description = "Minecraft Server Subflake";

  inputs = {
    dtach = {
      url = "github:xPMo/dtach";
      flake = false;
    };
  };
  # IDEA Decouple this Module into a separate Nix flake
  # IDEA Consider debrand PaperMC since this Module should be capable
  # to handle other variants beyond only PaperMC

  outputs = { self, nixpkgs, dtach, ... }@inputs: {
    nixosModules.default = { config, lib, pkgs, ... }: {
      imports = [
        ./facets/options.nix
        (import ./facets/service.nix dtach) # Hacky but seems needed for now
        ./facets/access.nix
        ./sidecars/borgbase.nix
        ./sidecars/discord.nix
      ];
    };
  };

}
