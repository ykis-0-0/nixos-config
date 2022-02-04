{ config, pkgs, lib, ... }:
{
  imports = [ ./rpi-hardware.nix ];

  services = {
    avahi.enable = true;
    openssh.enable = true;
  };

  networking = {
    hostName = "rpinix";
    wireless = {
      enable = true;
      interfaces = [ "wlan0" ];
      networks = with (import ./secrets.nix);
        wifi;
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
