{ config, lib, pkgs, ... }:
{
  networking.hostName = "vbox-proxy";

  services.xserver.displayManager.autoLogin.user = "nixos";
}
