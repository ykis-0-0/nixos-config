{
  description = "System Configuration(s)";

  inputs = {
    # region (Semi-)Endorsed Modules
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
      # flake = false;
    };
    # endregion
    # region Thrid-party Modules
    vscode-server-patch = {
      url = "github:msteen/nixos-vscode-server/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    /* # We aren't using MATLAB anytime soon i guess (probably forever lmao)
    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    */
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    manix = {
      url = "github:kulabun/manix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    # endregion
    # region Homebrew
    argononed = {
      url = "gitlab:DarkElvenAngel/argononed/master";
      flake = false;
    };
    npiperelay = {
      url = "github:ykis-0-0/npiperelay.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # secret-wrapper: to be supplied on target hosts
    secret-wrapper.follows = "";
    # endregion
  };

  outputs = { self, secret-wrapper ? null, ... }@inputs': let
    #region sched-reboot injection
    # HACK revert to normal flake input definition whether possible,
    # specifically when https://github.com/NixOS/nix/issues/6352 has merged
    inputs = inputs' // {
      sched-reboot.nixosModules.default = ./modules/sched-reboot/default.nix;
    };
    #endregion
  in {
    nixosConfigurations = let
      nixosConfigurations' = import ./nixos/systems.nix inputs;
      createSystem = inputs.nixpkgs.lib.nixosSystem;
      mapper = host: config: createSystem {
        inherit (config) modules;
        specialArgs = config.moduleArgs // {
          inherit (inputs) nixpkgs; # >:(
        };
      };
    in builtins.mapAttrs mapper nixosConfigurations';

    # OS Images are removed as none of them works in their current form
    # packages = {};

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
      homeConfigurations' = import ./nixos/homes.nix (let
          getSystem = name: conf: conf.config.nixpkgs.hostPlatform.system;
        in inputs // {
          systems' = builtins.mapAttrs getSystem self.nixosConfigurations;
        }
      );
    in mkHomeConfigurations homeConfigurations';

    deploy = {
      nodes = import ./nixos/deployments.nix inputs;
      remoteBuild = true;
    };
  };
}
