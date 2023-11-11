inputs: [
  {
    username = "nixos";
    host = "wslnix";
    modules = [
      ./who/hm-base.nix
      ./who/nixos/home-manager/default.nix
      ./who/nixos/home-manager/wslnix.nix
      inputs.vscode-server-patch.nixosModules.home

      ./how/keeagent.nix # KeeAgent NPipeRelay runner
    ];

    extraSpecialArgs = {
      npiperelay = inputs.npiperelay.packages.${inputs.systems'.wslnix}.default;
      manix = inputs.manix.packages.${inputs.systems'.wslnix}.manix;
    };
  }
]
