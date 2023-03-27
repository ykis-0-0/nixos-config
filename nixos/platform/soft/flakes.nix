{ nixpkgs, pkgs, ... }: {
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    nixPath = [
      "nixpkgs=${nixpkgs}"
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
