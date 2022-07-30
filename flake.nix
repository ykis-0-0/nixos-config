{
  description = "System Configuration(s)";

  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixos";
      # flake = false;
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixos";
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
    nixosConfigurations = {
      rpinix = inputs.nixos.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = builtins.removeAttrs inputs [ "nixos-wsl" "nix-matlab" ];
        modules = [
          ./platform/raspberrypi/rpinix/configuration.nix
          ./platform/raspberrypi/rpinix/hardware.nix
          ./platform/raspberrypi/rpinix/storage.nix
          ./expectations/switch_persistence.nix
          ./expectations/passwdmgr/default.nix
          ./expectations/flakes.nix
          ./expectations/argononed.nix
        ];
      };

      vbox-proxy = inputs.nixos.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = builtins.removeAttrs inputs [ "self" "nixos-wsl" "vscode-server-patch" "argononed" ];
        modules = [
          ./platform/vbox/base/configuration.nix
          ./platform/vbox/base/hardware.nix
          ./platform/vbox/base/storage.nix
          ./expectations/switch_persistence.nix
          ./expectations/flakes.nix
          # ./expectations/pipewire.nix
          ./expectations/gui/awesome.nix
          ./platform/vbox/proxy/overrides.nix
        ];
      };

      vbox-test = inputs.nixos.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = builtins.removeAttrs inputs [ "self" "nixos-wsl" "vscode-server-patch" "argononed" ];
        modules = [
          ./platform/vbox/base/configuration.nix
          ./platform/vbox/base/hardware.nix
          ./platform/vbox/base/storage.nix
          ./expectations/switch_persistence.nix
          ./expectations/flakes.nix
          ./platform/vbox/test/overrides.nix
        ];
      };

      hyperv-test = inputs.nixos.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = builtins.removeAttrs inputs [ "self" "vscode-server-patch" "argononed" ];
        modules = [
          ./platform/hyperv/base/configuration.nix
          ./platform/hyperv/base/hardware.nix
          ./platform/hyperv/base/storage.nix
          ./expectations/switch_persistence.nix
          ./expectations/flakes.nix
          ./platform/hyperv/test/overrides.nix
        ];
      };

      wslnix = inputs.nixos.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = builtins.removeAttrs inputs [ "self" "nixos-hardware" "impermanence" "nix-matlab" "argononed" ];
        modules = [
          ./platform/wsl/base/configuration.nix
          inputs.nixos-wsl.nixosModules.wsl
          ./expectations/flakes.nix
        ];
      };
    };

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
