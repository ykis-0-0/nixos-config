{
  description = "Reboot service subflake";

  inputs = {
    # Empty, nixpkgs to be supplied by user
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosModules.default = import ./default.nix;
  };
}
