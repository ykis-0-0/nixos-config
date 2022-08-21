{
  description = "System Configuration(s)";

  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixos";
    };
    impermanence.url = "github:nix-community/impermanence";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixos";
      # flake = false;
    };
    vscode-server-patch = {
      url = "github:msteen/nixos-vscode-server/master";
      flake = false;
    };
    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab/master";
      inputs.nixpkgs.follows = "nixos";
    };
    argononed = {
      url = "gitlab:DarkElvenAngel/argononed/master";
      flake = false;
    };
    # secret-wrapper: to be supplied on target hosts
    secret-wrapper.follows = "";
  };

  outputs = { self, secret-wrapper ? null, ... }@inputs: {
    nixosConfigurations = let
      nixosConfigurations' = import ./nixos.nix inputs;
      createSystem = inputs.nixos.lib.nixosSystem;
      mapper = host: config: createSystem {
        inherit (config) system modules;
        specialArgs = let
          inherit (builtins) removeAttrs filter attrNames elem;
          inherit (config) includeInputs;
        in
          removeAttrs inputs (filter (input: ! elem input includeInputs) (attrNames inputs));
      };
    in builtins.mapAttrs mapper nixosConfigurations';

    devShells = let
      # Copied from https://github.com/nix-community/home-manager/blob/master/flake.nix#L6
      #
      # List of systems supported by home-manager binary (NixOS only in our case)
      supportedSystems = builtins.attrNames inputs.nixos.legacyPackages; # inputs.nixos.lib.platforms.linux;

      # Function to generate a set based on supported systems
      forAllSystems = f:
        inputs.nixos.lib.genAttrs supportedSystems (system: f system);

      callArg = system: {
        pkgs = inputs.nixos.legacyPackages.${system};
      };
    in forAllSystems (system: {
      hm-install = (import "${inputs.home-manager}" (callArg system)).install;
    });


    homeConfigurations = let
      mkHomeConfig_ = inputs.home-manager.lib.homeManagerConfiguration;
      mkHomeConfig' = {
        username, host,
        profileName ? "${username}@${host}", homeDirectory ? "/home/${username}",
        # Upstream args
        modules, extraSpecialArgs
      }@args: {
        name = profileName;
        value = mkHomeConfig_ {
          pkgs = self.nixosConfigurations.${host}.pkgs;
          modules = [{
            home = {
              inherit username homeDirectory;
            };
          }] ++ modules;
          inherit extraSpecialArgs;
        };
      };
      mkHomeConfigurations = builders: builtins.listToAttrs (map mkHomeConfig' builders);
    in mkHomeConfigurations [
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
        ];
        extraSpecialArgs = {};
      }
    ];

  };
}
