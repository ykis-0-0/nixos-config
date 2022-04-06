{ pkgs, ... }:
{
  imports = [ ./base.nix ];

  home.packages = with pkgs; [
    # Empty as of now
  ];

  xresources.extraConfig = ''
    XTerm*background: black
    XTerm*foreground: lightgray
  '';
}
