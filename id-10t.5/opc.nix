{ config, lib, ... }: {
  users.users.ocinix = {
    isNormalUser = true;
    /* auto-set:
      group = "users";
      home = "/home/<username>";
      createHome = true;
      useDefaultShell = true;
      isSystemUser = false;
    */

    extraGroups = [ "wheel" ];

    hashedPassword = null; # Disallow any usages of password

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIASYzSksuD6mvpOJGABmuNzEc4fBZNFyKPDirZLuTWQq oci_ssh"
    ];
  };
}
