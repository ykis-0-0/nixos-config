{ config, pkgs, lib, self, secret-wrapper, ... }:
let
  secrets = import "${secret-wrapper}/secrets.nix";
in {
  networking = {
    hostName = "rpinix";
    wireless.networks = secrets.wifi;
  };

  pwdHashMgr = {
    enable = true;
    inherit (secrets) passwords;
  };
}
