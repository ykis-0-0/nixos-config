{ pkgs, vscode-srv, ... }:
{
  imports = [ ./base.nix "${vscode-srv}/modules/vscode-server/home.nix" ];

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
