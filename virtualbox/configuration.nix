{ config, pkgs, lib, ... }:
{
  system.stateVersion = "21.11";

  time.timeZone = "Asia/Hong_Kong";

  nixpkgs.config.allowUnfree = true;

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
        password = "nixos";
      };
    };
  };
}
