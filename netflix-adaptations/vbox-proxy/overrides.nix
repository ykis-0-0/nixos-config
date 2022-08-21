{ config, pkgs, lib, ... }:
{
  networking.hostName = "vbox-proxy";

  services.xserver.displayManager.autoLogin.user = "nixos";
}
