{ config, lib, pkgs, nixpkgs, ... }: {
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    nixPath = [
      # Allowed since https://github.com/NixOS/nix/issues/7026
      "nixpkgs=flake:nixpkgs"
      "nixos-config=/etc/nixos/configuration.nix"
    ];

    registry = {
      nixpkgs-thisos = {
        from = {
          id = "nixpkgs";
          type = "indirect";
        };
        flake = nixpkgs;
      };
    };
  };
}
