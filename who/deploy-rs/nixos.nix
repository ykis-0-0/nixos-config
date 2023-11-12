{ config, lib, pkgs, ... }: {
  /*
    The service user for deployment of NixOS Infrastructral Configurations
  */
  users.users.deploy-rs = {
    isSystemUser = true;

    # isNormalUser = true;
    /* auto-set:
      group = "users";
      home = "/home/<username>";
      createHome = true;
      useDefaultShell = true;
      isSystemUser = false;
    */

    description = "NixOS deployer";
    group = "nogroup";

    # extraGroups = [];
    shell = pkgs.bash;

    hashedPassword = null;

    openssh.authorizedKeys.keys = let
      pubkeys = import ../ssh-pubkeys.nix;
    in with pubkeys; [
      deployer
    ];
  };

  nix.settings.trusted-users = [ "root" "deploy-rs" ];

  security.sudo.extraRules = [
    {
      users = [ "deploy-rs" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

}
