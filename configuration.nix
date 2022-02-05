{ config, pkgs, lib, ... }:
{
  imports = [ ./rpi-hardware.nix ];

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        userServices = true;
        addresses = true;
        domain = true;
      };
    };

    openssh = {
      enable = true;
      extraConfig = ''
        ClientAliveInterval 10
      '';
    };

    ddclient = with (import ./secrets.nix); {
      enable = true;
      interval = "12 hours";
      protocol = "noip";
      # server = "dynupdate.no-ip.com" # default
      use = "web, web=checkip.dyndns.com";
      inherit (ddclient_noip) username passwordFile domains;
    };
  };

  networking = {
    hostName = "rpinix";
    wireless = {
      enable = true;
      # interfaces = []; # A shared instance is enough for Pi
      extraConfig = ''
        country=HK
      ''; # We need this to properly connect and have 5GHz, good thing!
      networks = with (import ./secrets.nix);
        wifi;
      userControlled.enable = true;
    };
  };

  users = {
    mutableUsers = false;
    users =
      let
        pwds = (import ./secrets.nix).passwords;
        pwdmap = uname: if pwds ? uname then { password = pwds."${uname}"; } else {};
      in builtins.mapAttrs (uname: conf: conf // pwdmap uname) {
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
          password = "nixos";
        };
      };
  };

}
