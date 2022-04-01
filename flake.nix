{
  description = "System Configuration(s)";

  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    argononed = {
      url = "gitlab:ykis-0-0/argononed/feat/nixos";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixos";
      # flake = false;
    };
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, ... }@inputs : {
    nixosConfigurations = {
      rpinix = inputs.nixos.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit (inputs) nixos home-manager impermanence nixos-hardware argononed;
        };
        modules = [
          ./expectations/flakes.nix
          ./raspberrypi/configuration.nix
          ./raspberrypi/hardware.nix
          ./expectations/home-manager.nix
          ./raspberrypi/storage.nix
          # ./argononed.nix
        ];
      };

      vbox = inputs.nixos.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit (inputs) nixos home-manager impermanence;
        };
        modules = [
          ./expectations/flakes.nix
          ./virtualbox/configuration.nix
          ./virtualbox/hardware.nix
          ./virtualbox/storage.nix
          ./expectations/home-manager.nix
          ./expectations/gui/fluxbox.nix
        ];
      };
    };

    devShells = let
      # Copied from https://github.com/nix-community/home-manager/blob/master/flake.nix#L6
      #
      # List of systems supported by home-manager binary (NixOS only in our case)
      supportedSystems = inputs.nixos.lib.platforms.linux;

      # Function to generate a set based on supported systems
      forAllSystems = f:
        inputs.nixos.lib.genAttrs supportedSystems (system: f system);

      callArg = system: {
        pkgs = inputs.nixos.legacyPackages.${system};
      };
    in forAllSystems (system: {
      hm-install = (import "${inputs.home-manager}" (callArg system)).install;
    });


    homeConfigurations = /* let
      # Modified from https://github.com/nix-community/home-manager/blob/master/flake.nix#L44
      homeManagerConfiguration' = {
        system, username, homeDirectory,
        modules, extraSpecialArgs ? {},
        pkgs ? builtins.getAttr system inputs.nixos.legacyPackages,
        check ? true, stateVersion ? "20.09"
      }@args:
      assert inputs.nixos.lib.versionAtLeast sateVersion "20.09";
      import "${inputs.home-manager}/modules" {
        inherit pkgs check extraSpecialArgs;
        configuration = { ... }: {
          imports = modules;
          home = { inherit homeDirectory stateVersion username; };
          nixpkgs = { inherit (pkgs) config overlays; };
        };
      };
    in */ {
      "nixos@vbox" = inputs.home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        username = "nixos";
        homeDirectory = "/home/nixos";
        stateVersion = "22.05";

        configuration = import ./home-manager/nixos/vbox.host.nix
      };
    };

  };
}
