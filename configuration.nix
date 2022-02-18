{ config, pkgs, lib, ... }:
{
  imports = [ ./channels.nix ./passwdmgr.nix ./rpi-hardware.nix ];

  nix-channels = {
    enable = true;
    nixpkgs = {
      channelName = "nixos";
      url = "https://nixos.org/channels/nixos-21.11-aarch64/nixexprs.tar.xz";
    };

    extraChannels = {
      home-manager = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
    };
  };

  time.timeZone = "Asia/Hong_Kong";

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

  pwdHashMgr = {
    enable = true;
    inherit (import ./secrets.nix) passwords;
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
