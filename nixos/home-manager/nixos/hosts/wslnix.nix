{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git
    wget
    rnix-lsp
  ];
}
