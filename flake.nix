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
      # inputs = {
      #   nixpkgs.follows = "nixos";
      # };
      flake = false;
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
          ./raspberrypi/impermanence.nix
          # ./argononed.nix
        ];
      };
    };
  };

}
