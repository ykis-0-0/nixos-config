{
  users.users.ykis = {
    isNormalUser = true;
    /* auto-set:
      group = "users";
      home = "/home/<username>";
      createHome = true;
      useDefaultShell = true;
      isSystemUser = false;
    */

    openssh.authorizedKeys.keys = let
      pubkeys = import ../ssh-pubkeys.nix;
    in with pubkeys; [
      main-ed25519
      main-rsa
    ];
  };
}
