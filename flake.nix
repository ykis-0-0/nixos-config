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
          inherit (inputs) nixos home-manager nixos-hardware argononed impermanence;
        };
        modules = [
          ./expectations/flakes.nix
          ./configuration.nix
          ./expectations/hardware/raspberrypi.nix
          ./expectations/home-manager.nix
          ./expectations/impermanence.nix
          # ./argononed.nix
        ];
      };
    };
  };

}
