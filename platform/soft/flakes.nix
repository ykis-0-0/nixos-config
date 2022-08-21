{ nixos, home-manager, pkgs, ... }: {
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    nixPath = [
      "nixpkgs=${nixos}"
      "nixos-config=/etc/nixos/configuration.nix"
      "home-manager=${home-manager}"
    ];

    registry = {
      nixpkgs-thisos = {
        from = {
          id = "nixpkgs";
          type = "indirect";
        };
        flake = nixos;
      };
    };
  };
}
