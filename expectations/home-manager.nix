{ home-manager, ... }:
{
  environment.shellAliases = {
    hm-install = "nix-shell '${home-manager}' -A install";
  };
}
