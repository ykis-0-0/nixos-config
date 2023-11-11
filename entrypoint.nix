{ self, secret-wrapper ? null, ... }@inputs': let
  #region sched-reboot injection
  # HACK revert to normal flake input definition whether possible,
  # specifically when https://github.com/NixOS/nix/issues/6352 has merged
  inputs = inputs' // {
    sched-reboot.nixosModules.default = import ./how/sched-reboot/default.nix;
  };
  #endregion
in {
  nixosConfigurations = let
    nixosConfigurations' = import ./systems.nix inputs;
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
    homeConfigurations' = import ./homes.nix (let
        getSystem = name: conf: conf.config.nixpkgs.hostPlatform.system;
      in inputs // {
        systems' = builtins.mapAttrs getSystem self.nixosConfigurations;
      }
    );
  in mkHomeConfigurations homeConfigurations';

  deploy = {
    nodes = import ./deployments.nix inputs;
    remoteBuild = true;
  };
}
