{ config, pkgs, lib, ... }:
{
  system.stateVersion = "21.11";

  time.timeZone = "Asia/Hong_Kong";

  nixpkgs.config.allowUnfree = true;

  networking = {
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;

    interfaces.enp0s3.useDHCP = true;
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
        password = "nixos";
      };
    };
  };
}
