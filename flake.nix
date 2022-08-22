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

  outputs = { self, secret-wrapper ? null, ... }@inputs: let
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

    packages = let
    in {
      x86_64-linux.wslnix = nixosConfigurations.wslnix.config.system.build.tarball;
    };

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
      homeConfigurations' = import ./homes.nix inputs;
    in mkHomeConfigurations homeConfigurations';
  in {
    inherit nixosConfigurations packages homeConfigurations;
  };
}
