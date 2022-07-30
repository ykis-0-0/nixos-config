{ pkgs, vscode-srv, ... }:
{
  home.packages = with pkgs; [
    asciinema deno
    rnix-lsp # For syntax checking in VSCode Remote SSH?
    # taskwarrior
    # broot eww
    # dogdns
  ];

  services = {
    vscode-server.enable = true;
  };
}
