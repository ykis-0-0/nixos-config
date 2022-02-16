{ lib, pkgs, config, options, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.pwdHashMgr;
in
{
  options.pwdHashMgr = {
    enable = mkEnableOption "Password Hash Generator";
    passwords = mkOption {
      example = ''{
        nixos = "nixos"
        bob = "i<3alice"
      }'';

      type = let
        inherit (lib.types) uniq attrsOf string;
      in
        uniq (attrsOf string);
    };
  };

  config = mkIf cfg.enable {
    users.users = let
      inherit (builtins) readFile;
      inherit (pkgs) runCommand;
      drvArgGen = pwdRaw: {
        nativeBuildInputs = [ pkgs.mkpasswd ];
        PASSWORD = pwdRaw;
      };
      mkHash = pwdRaw: (runCommand "mkpasswd") (drvArgGen pwdRaw) ''
        mkpasswd -m sha-512 $PASSWORD | tr -d "\n" > $out
      '';
      getHash = pwdRaw: readFile (mkHash pwdRaw);
    in
      builtins.mapAttrs (uname: cPwd: { hashedPassword = getHash cPwd; }) cfg.passwords;
  };
}
