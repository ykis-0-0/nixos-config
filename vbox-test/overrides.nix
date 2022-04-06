{ config, pkgs, lib, ... }:
{
  networking.hostName = lib.mkForce "vbox-test";
}
