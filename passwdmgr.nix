{ lib, pkgs, config, options, ... }:
{
  options.pwdHashMgr = {
    enable = lib.mkEnableOption "Password Hash Generator";
    passwords = lib.mkOption {
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

  config = let
    cfg = config.pwdHashMgr;
  in lib.mkIf cfg.enable {
    users.users = let
      drvArgGen = pwdRaw: {
        nativeBuildInputs = [ pkgs.mkpasswd ];
        PASSWORD = pwdRaw;
      };
      mkHash = pwdRaw: (pkgs.runCommand "mkpasswd") (drvArgGen pwdRaw) ''
        mkpasswd -m sha-512 $PASSWORD | tr -d "\n" > $out
      '';
      getHash = pwdRaw: builtins.readFile (mkHash pwdRaw);
    in
      builtins.mapAttrs (uname: cPwd: { hashedPassword = getHash cPwd; }) cfg.passwords;
  };
}
