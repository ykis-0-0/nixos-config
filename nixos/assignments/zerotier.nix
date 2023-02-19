{ config, lib, pkgs, secret-wrapper, ... }: {
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "9bee8941b54fd108"
    ];
  };
}
