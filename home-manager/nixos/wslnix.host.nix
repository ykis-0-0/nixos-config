{ pkgs, ... }:
{
  import = [ ./base.nix ];

  home.packages = with pkgs; [
    rnix-lsp
    wget
  ];
}
