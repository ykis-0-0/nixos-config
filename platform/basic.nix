{ config, lib, ... }: {
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this options
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  time.timeZone = "Asia/Hong_Kong";

  nixpkgs.config.allowUnfree = true;

  users.mutableUsers = false;

  documentation = {
    enable = true;
    man.enable = true;
    doc.enable = true;
    info.enable = true;
    nixos.enable = true;
  };

  environment.shellAliases = {
    sudo = "sudo "; # Space required to trigger alias substitution of following tokens
  };
}
