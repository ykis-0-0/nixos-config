{ config, lib, pkgs, ... }:
{
  networking.hostName = "hyperv-test";

  services.xserver.displayManager.autoLogin.user = "nixos";
}
