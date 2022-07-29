{ config, pkgs, lib, ... }: {
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this options
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  networking.hostName = "wslnix";

  nixpkgs.config.allowUnfree = true;

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "nixos";
  };

  # WSL (regardless of 1 or 2) doesn't support X11, so it may help saving space
  environment.noXlibs = true;
}
