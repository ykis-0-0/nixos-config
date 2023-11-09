{ config, lib, ... }: {
  /*
    This shall be the default user for local isolated machines
    which does not open itself to the internet,
    e.g. Hyper-V / VirtualBox Machines; WSL distros, etc.
  */
  users.users.nixos = {
    isNormalUser = true;
    /* auto-set:
      group = "users";
      home = "/home/<username>";
      createHome = true;
      useDefaultShell = true;
      isSystemUser = false;
    */

    extraGroups = [ "wheel" ]
      ++ lib.lists.optionals config.virtualisation.virtualbox.guest.enable [ "vboxsf" ];

    password = "nixos";

    openssh.authorizedKeys.keys = let
      pubkeys = import ../ssh-pubkeys.nix;
    in with pubkeys; [
      main-ed25519
      main-rsa
    ];
  };

  services.openssh.extraConfig = ''
    Match User nixos
      PasswordAuthentication no
    Match All
  '';
}
