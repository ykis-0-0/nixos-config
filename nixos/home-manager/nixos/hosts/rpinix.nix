{ pkgs, vscode-srv, ... }:
{
  home.packages = with pkgs; [
    asciinema
    # deno # Not used atm
    rnix-lsp nil # For syntax checking in VSCode Remote SSH?
    # taskwarrior
    # broot eww
    # dogdns
  ];

  services = {
    vscode-server.enable = true;
  };
}
