{ config, lib, pkgs, secret-wrapper, ... }: let
  secrets = import "${secret-wrapper}/secrets.nix";
in {
  networking = {
    hostName = "rpinix";
    wireless.networks = secrets.wifi;
  };
}
