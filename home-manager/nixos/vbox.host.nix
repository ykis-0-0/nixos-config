{ pkgs, ... }:
{
  imports = [ ./base.nix ];

  home.packages = with pkgs; [
    zoom-us firefox
    vscode
    xfce.thunar gnome.gedit
    gcc9 # For MATLAB
  ];

  xresources.extraConfig = ''
    XTerm*background: black
    XTerm*foreground: lightgray
  '';
}
