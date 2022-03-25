{
  description = "System Configuration(s)";

  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
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
  };

  outputs = { self, ... }@inputs : {
    nixosConfigurations = {
      rpinix = inputs.nixos.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit (inputs) nixos nixpkgs-unstable home-manager nixos-hardware argononed;
        };
        modules = [
          ./add_flakes.nix
          ./configuration.nix
          ./rpi-hardware.nix
          ./hm-stub.nix
          /*./argononed.nix*/
        ];
      };
    };
  };

}
