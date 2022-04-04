{ pkgs, nix-matlab, ... }:
{
  imports = [ ./base.nix ];

  nixpkgs.overlays = [ nix-matlab.overlay ];

  home.packages = with pkgs; [
    zoom-us firefox
    vscode
    xfce.thunar gnome.gedit
    matlab matlab-mlint
    gcc9 # For MATLAB
  ];

  xresources.extraConfig = ''
    XTerm*background: black
    XTerm*foreground: lightgray
  '';
}
