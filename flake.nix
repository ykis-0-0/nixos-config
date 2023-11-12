{
  description = "System Configurations";

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
    vscode-server-patch = {
      url = "github:nix-community/nixos-vscode-server/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # endregion
    # region Thrid-party Modules
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

  outputs = inputs: import ./entrypoint.nix inputs;
}
