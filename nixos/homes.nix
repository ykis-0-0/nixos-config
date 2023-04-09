inputs: [
  {
    username = "nixos";
    host = "wslnix";
    modules = [
      ./home-manager/base.nix
      ./home-manager/nixos/base.nix
      ./home-manager/nixos/hosts/wslnix.nix
      inputs.vscode-server-patch.nixosModules.home
    ];
    extraSpecialArgs = {
      npiperelay = inputs.npiperelay.packages.${inputs.systems'.wslnix}.default;
      manix = inputs.manix.packages.${inputs.systems'.wslnix}.manix;
    };
  }
]
