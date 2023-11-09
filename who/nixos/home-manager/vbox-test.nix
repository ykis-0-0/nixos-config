{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Empty as of now
  ];

  xsession = {
    enable = true;
    numlock.enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = false;
    };
  };

  xresources.extraConfig = ''
    XTerm*background: black
    XTerm*foreground: lightgray
  '';
}
