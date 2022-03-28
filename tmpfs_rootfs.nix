{ lib, impermanence, ... }:
let
  persistMount = "/persist";
  _mkPersist = onInitrd: mountPoint: source: {
    name = mountPoint;
    value = {
      device = source;
      options = [ "bind" ];
      neededForBoot = onInitrd;
    };
  };
  mkPersist = mountPoint: _mkPersist true mountPoint (persistMount + mountPoint);
  earlyMaps = [ "/boot" "/nix" ];
in {
  imports = [ impermanence.nixosModule ];

  environment.persistence.${persistMount} = {
    directories = [
      {
        directory = "/etc/nixos";
        user = "root";
        group = "wheel";
        mode = "0774";
      }
      "/var/lib"
      "/var/log"
      "/root"
      "/home"
    ];
     files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
     ];
  };

  fileSystems = {
    "/" = lib.mkForce {
      device = "none";
      fsType = "tmpfs";
      options = [ "size=1G" "mode=0755" ]; # 0700 will make SSH pubkey refuse to work
    };

    ${persistMount} = {
      device = "/dev/sda2";
      fsType = "ext4";
      options = [ "noatime" ];
      neededForBoot = true;
    };

  } // builtins.listToAttrs (map mkPersist earlyMaps);
}
