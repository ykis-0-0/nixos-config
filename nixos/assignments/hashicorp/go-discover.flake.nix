{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    go-discover = {
      url = "github:hashicorp/go-discover";
      flake = false;
    };
  };

  outputs = { nixpkgs, go-discover, flake-utils }@inputs: let
    inherit (flake-utils.lib) eachSystem defaultSystems;
  in eachSystem defaultSystems (system: {
    packages = let
      inherit (nixpkgs) lib;
      inherit (nixpkgs.legacyPackages.${system}) buildGoModule;
    in {
      default = buildGoModule {
        pname = "go-discover";
        version = builtins.substring 0 8 go-discover.lastModifiedDate;

        src = go-discover;
        # don't know why but nix is unhappy about vendorHash = null
        vendorHash = "sha256-yhw6KFlgZvRpvvY1qUNNVmKgzCaIKHzJH3thQP1tbE0=";

        # mDNS need this to get tests passed
        doCheck = false;
      };
    };
  });
}
