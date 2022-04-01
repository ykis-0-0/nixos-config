{ pkgs, ... }:
{
  imports = [ ../base.nix ];

  home.packages = with pkgs; [
    jq yq-go
  ];

  programs.git = {
    enable = true;
    userName = "ykis-0-0";
    userEmail = "64165725+ykis-0-0@users.noreply.github.com";

    aliases = {
      graph = "log --graph '--pretty=tformat:%C(auto)%h%C(dim white)% ci%C(auto)% G?%d%n  [%cN]:% s'";
    };

    extraConfig = {
      credential.helper = "store";
    };
  };
}
