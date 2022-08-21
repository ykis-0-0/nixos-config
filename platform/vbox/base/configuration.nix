{ config, pkgs, lib, ... }:
{
  networking = {
    hostName = lib.mkDefault "vbox";
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp0s3.useDHCP = true;
  };

  services.xserver.displayManager.autoLogin = {
    enable = lib.mkDefault true;
    user = lib.mkDefault "nixos";
  };

  users = {
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
        extraGroups = [ "wheel" "vboxsf" ];
        password = "nixos";
      };
    };
  };
}
