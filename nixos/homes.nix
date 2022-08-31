inputs: [
  {
    username = "nixos";
    host = "rpinix";
    modules = [
      ./home-manager/base.nix
      ./home-manager/nixos/base.nix
      ./home-manager/nixos/hosts/rpinix.nix
      "${inputs.vscode-server-patch}/modules/vscode-server/home.nix"
    ];
    extraSpecialArgs = {
      vscode-srv = inputs.vscode-server-patch;
    };
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
  {
    username = "nixos";
    host = "wslnix";
    modules = [
      ./home-manager/base.nix
      ./home-manager/nixos/base.nix
      ./home-manager/nixos/hosts/wslnix.nix
      "${inputs.vscode-server-patch}/modules/vscode-server/home.nix"
    ];
    extraSpecialArgs = {};
  }
]
