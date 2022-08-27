{ config, lib, pkgs, ... }: {
  /*
    This shall be the default user for local isolated machines
    which does not open itself to the internet,
    e.g. Hyper-V / VirtualBox Machines; WSL distros, etc.
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

    description = "";
    group = "nogroup";

    # I don't want to do these, but I have run out of ideas...
    extraGroups = [ "wheel" ];
    shell = pkgs.bash;

    hashedPassword = null;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINb9yp34P4vMnvrWOKp10hOtunhuhiLtFEjQqXt2dofG NixOS Deployment Key"
    ];
  };

  nix.settings.trusted-users = [ "deploy-rs" ];
}
