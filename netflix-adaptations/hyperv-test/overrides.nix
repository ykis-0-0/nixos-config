{ config, pkgs, lib, ... }:
{
  networking.hostName = "hyperv-test";

  services.xserver.displayManager.autoLogin.user = "nixos";
}
