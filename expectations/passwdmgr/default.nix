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
    nix.extraOptions = ''
      plugin-files = ${pkgs.nix-plugins}/lib/nix/plugins
      extra-builtins-file = ${./extra_builtins.nix}
    '';

    users.users = let
      inherit (pkgs-unstable) mkpasswd;
      mkPasswd = password:
        builtins.replaceStrings [ "\n" ] [ "" ] (
          builtins.extraBuiltins.exec [ "${pkgs.mkpasswd}/bin/mkpasswd" "-m" "sha-512" password ]
        );
    in
      builtins.mapAttrs (uname: cPwd: { hashedPassword = mkPasswd cPwd; }) cfg.passwords;
  };
}
