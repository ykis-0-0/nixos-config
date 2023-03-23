{ config, lib, pkgs, ... }: {
  services.vault = {
    enable = true;

    storageBackend = "raft";
    # storagePath = /var/lib/vault; # default
  };
}
