{ pkgs, ... }:
{
  imports = let
    vscode-srv = fetchGit {
      url = "https://github.com/santicalcagno/nixos-vscode-server.git"; # "https://github.com/msteen/nixos-vscode-server.git";
      ref = "master";
    };
  in [ ./base.nix "${vscode-srv}/modules/vscode-server/home.nix" ];

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
