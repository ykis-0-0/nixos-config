{ config, pkgs, lib, ... }:
{
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this options
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  time.timeZone = "Asia/Hong_Kong";

  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = lib.mkDefault "hyperv";
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
