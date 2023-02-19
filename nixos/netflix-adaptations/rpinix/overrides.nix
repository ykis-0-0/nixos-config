{ config, lib, pkgs, secret-wrapper, ... }: let
  secrets = import "${secret-wrapper}/secrets.nix";
in {
  networking = {
    hostName = "rpinix";
    wireless.networks = secrets.wifi;
  };

  services.sched-reboot = {
    enabled = true;
    happenOn = "*-*-1..31/2 03:00:00";
    gracePeriod = "3min";
  };
}
