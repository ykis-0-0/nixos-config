{ config, lib, pkgs, secret-wrapper, ... }:
let
  secrets = import "${secret-wrapper}/secrets.nix";
in {
  services.ddclient = {
    enable = true;
    interval = "12 hours";
    protocol = "noip";
    # server = "dynupdate.no-ip.com" # default
    # use = "web, web=checkip.dyndns.com";
    inherit (secrets.ddclient_noip) username passwordFile domains;
  };
}
