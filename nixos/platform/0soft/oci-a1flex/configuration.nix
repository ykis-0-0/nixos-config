{ config, lib, pkgs, ... }: {

  boot.cleanTmpDir = true;

  zramSwap.enable = true;
}
