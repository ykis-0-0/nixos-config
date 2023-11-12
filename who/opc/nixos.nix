{ config, lib, ... }: {
  /*
    The non-root user for Oracle Cloud
  */
  users.users.opc = {
    isNormalUser = true;
    /* auto-set:
      group = "users";
      home = "/home/<username>";
      createHome = true;
      useDefaultShell = true;
      isSystemUser = false;
    */

    extraGroups = [ "wheel" ];

    # hashedPassword = null; # Disallow any usages of password
    password = "ociadmin";

    openssh.authorizedKeys.keys = let
      pubkeys = import ../ssh-pubkeys.nix;
    in with pubkeys; [
      oci
    ];
  };

  services.openssh.extraConfig = ''
    Match User opc
      PasswordAuthentication no
    Match All
  '';
}
