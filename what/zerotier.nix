{ config, lib, pkgs, secret-wrapper, ... }: {
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      # TODO create a new network later
    ];
  };
}
