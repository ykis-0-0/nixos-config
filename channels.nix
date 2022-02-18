{ lib, pkgs, config, options, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.nix-decl-channels;
in
{
  options.nix-decl-channels = {
    enable = mkEnableOption "Manage Nix channels declaratively";

    systemChannels = mkOption {
      example = ''{
        nixos = "https://nixos.org/channels/nixos-21.11-aarch64";
        home-manager = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
      }'';

      type = let
        inherit (lib.types) uniq attrsOf string;
      in
        uniq (attrsOf string);
    };
  };

  config = mkIf cfg.enable {
    system.activationScripts.nix-channels = let
      inherit (builtins) concatStringsSep;
      inherit (lib) stringAfter;
      inherit (lib.attrsets) mapAttrsToList;
      inherit (pkgs) writeText;
      chFileContent = concatStringsSep "\n" (mapAttrsToList (name: url: concatStringsSep " " [url name]) cfg.systemChannels);
      chFilePath = writeText "nix-channels" chFileContent;
    in
      stringAfter [ "nix" ] ''
        echo "Using ${chFilePath} as /root/.nix-channels"
        ln -sfn ${chFilePath} /root/.nix-channels
      '';
  };
}
