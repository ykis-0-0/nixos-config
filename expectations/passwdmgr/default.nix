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
    useNixPlugin = false;
    mkPasswd_ = caller:
      let
        mkPwdCmd = "${pkgs.mkpasswd}/bin/mkpasswd -m sha512crypt";
        awkScript =  password: "BEGIN { \"${mkPwdCmd} ${password}\" | getline out; printf(\"\\\"%s\\\"\", out); }";
      in
        passwd: caller [ "${pkgs.gawk}/bin/awk" (awkScript passwd) ];

    doPlugin = {
      nixExtraOptions = ''
        plugin-files = ${pkgs.nix-plugins}/lib/nix/plugins
        extra-builtins-file = ${./extra_builtins.nix}
      '';

      caller = builtins.extraBuiltins.exec;
    };
    doExec = {
      nixExtraOptions = "allow-unsafe-native-code-during-evaluation = true";

      caller = builtins.exec;
    };

    method = if useNixPlugin then doPlugin else doExec;
  in lib.mkIf cfg.enable {
    nix.extraOptions = method.nixExtraOptions;
    users.users = builtins.mapAttrs (uname: cPwd: { hashedPassword = mkPasswd_ method.caller cPwd; }) cfg.passwords;
  };
}
