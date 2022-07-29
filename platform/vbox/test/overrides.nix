{ config, pkgs, lib, ... }:
{
  networking.hostName = lib.mkForce "vbox-test";

  services.xserver = {
    enable = true;
    displayManager = {
      autoLogin.enable = lib.mkForce false;
      session = [{
        manage = "desktop";
        name = "user_session";
        desktopNames = [ "User-defined X11 Session" ];
        start = ''exec $HOME/.xsession'';
      }];
    };
  };
}
