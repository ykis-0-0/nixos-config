{ pkgs, vscode-srv, ... }:
{
  home.packages = with pkgs; [
    asciinema deno
    # taskwarrior
    # broot eww
    # dogdns
  ];

  services = {
    vscode-server.enable = true;
  };
}