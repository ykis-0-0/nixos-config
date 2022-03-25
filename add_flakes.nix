{ nixos, home-manager, nixpkgs-unstable, pkgs, ... }: {
  nix = {
    package = nixpkgs-unstable.legacyPackages.${pkgs.system}.pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    nixPath = [
      "nixpkgs=${nixos}"
      "nixos-config=/etc/nixos/configuration.nix"
      "home-manager=${home-manager}"
    ];
  };
}
