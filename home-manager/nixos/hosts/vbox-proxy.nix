{ pkgs, nix-matlab, ... }:
{
  nixpkgs.overlays = [ nix-matlab.overlay ];

  home.packages = with pkgs; [
    qpwgraph
    zoom-us firefox
    xfce.thunar gnome.gedit
    vscode
    matlab matlab-mlint
    gcc9 # For MATLAB
  ];

  xresources.extraConfig = ''
    XTerm*background: black
    XTerm*foreground: lightgray
  '';
}
