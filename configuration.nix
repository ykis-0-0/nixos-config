{ config, pkgs, lib, ... }:
{
  imports = [ ./rpi-hardware.nix ];

  services = {
    avahi.enable = true;

    openssh = {
      enable = true;
      extraConfig = ''
        ClientAliveInterval 10
      '';
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
