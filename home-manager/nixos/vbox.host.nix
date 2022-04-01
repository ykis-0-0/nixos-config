{ pkgs, ... }:
{
  imports = [ ./base.nix ];

  home.packages = with pkgs; [
    zoom-us firefox
    vscode
    xfce.thunar gnome.gedit
    gcc9 # For MATLAB
  ];
}
