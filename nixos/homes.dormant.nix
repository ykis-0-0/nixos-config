# pastebin for dormant profile definitions
inputs: [
  {
    username = "nixos";
    host = "rpinix";
    modules = [
      ./home-manager/base.nix
      ./home-manager/nixos/base.nix
      ./home-manager/nixos/hosts/rpinix.nix
      inputs.vscode-server-patch.nixosModules.home
    ];
    extraSpecialArgs = {};
  }
  {
    username = "nixos";
    host = "vbox-proxy";
    modules = [
      ./home-manager/base.nix
      ./home-manager/nixos/base.nix
      ./home-manager/nixos/hosts/vbox-proxy.nix
    ];
    extraSpecialArgs = {
      inherit (inputs) nix-matlab;
    };
  }
  {
    username = "nixos";
    host = "vbox-test";
    modules = [
      ./home-manager/base.nix
      ./home-manager/nixos/base.nix
      ./home-manager/nixos/hosts/vbox-test.nix
    ];
    extraSpecialArgs = {};
  }

]
