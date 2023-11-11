# pastebin for dormant profile definitions
inputs: [
  {
    username = "nixos";
    host = "rpinix";
    modules = [
      ./who/hm-base.nix
      ./who/nixos/home-manager/default.nix
      ./who/nixos/home-manager/rpinix.nix
      inputs.vscode-server-patch.nixosModules.home
    ];
    extraSpecialArgs = {};
  }
  {
    username = "nixos";
    host = "vbox-proxy";
    modules = [
      ./who/hm-base.nix
      ./who/nixos/home-manager/default.nix
      ./who/nixos/home-manager/vbox-proxy.nix
    ];
    extraSpecialArgs = {
      inherit (inputs) nix-matlab;
    };
  }
  {
    username = "nixos";
    host = "vbox-test";
    modules = [
      ./who/hm-base.nix
      ./who/nixos/home-manager/default.nix
      ./who/nixos/home-manager/vbox-test.nix
    ];
    extraSpecialArgs = {};
  }

]
