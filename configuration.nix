{ config, pkgs, lib, ... }:
let
  secrets = import ./secrets.nix;
in
{
  imports = [ ./passwdmgr.nix ./roles/avahi.nix ./roles/sshd.nix];

  system.stateVersion = "21.11";

  time.timeZone = "Asia/Hong_Kong";

  services = {
    ddclient = {
      enable = true;
      interval = "12 hours";
      protocol = "noip";
      # server = "dynupdate.no-ip.com" # default
      use = "web, web=checkip.dyndns.com";
      inherit (secrets.ddclient_noip) username passwordFile domains;
    };
  };

  networking = {
    hostName = "rpinix";
    wireless = {
      enable = true; # Enables wireless support via wpa_supplicant.
      # interfaces = []; # A shared instance is enough for Pi
      extraConfig = ''
        country=HK
      ''; # We need this to properly connect and have 5GHz, good thing!
      networks = secrets.wifi;
      userControlled.enable = true;
    };
  };

  pwdHashMgr = {
    enable = true;
    inherit (secrets) passwords;
  };

  users = {
    mutableUsers = false;
    users = {
        nixos = {
          isNormalUser = true;
          /* auto-set:
            group = "users";
            home = "/home/<username>";
            createHome = true;
            useDefaultShell = true;
            isSystemUser = false;
          */
          extraGroups = [ "wheel" ];
        };
      };
  };

}
