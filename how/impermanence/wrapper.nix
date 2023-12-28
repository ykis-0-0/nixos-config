{ config, lib, pkgs, utils, impermanence, ... }@inputs: let
  # HACK `utils` required by impermanence module
  unject = import "${impermanence}/nixos.nix" inputs;
  wrap = let
    get = let
      inherit (builtins) concatStringsSep;
      inherit (lib.attrsets) attrByPath;
      unjectConfig = unject.config;
    in
      path: let
        default = throw "Path ${concatStringsSep "." path} not found in input";
      in
        attrByPath path default unjectConfig;
  in path: lib.mkIf
    config.maybePersistence.elevatedPlane.enable
    (get path);
in {
  options.environment = {
    inherit (unject.options.environment) persistence;
  };

  config = {
    systemd.services = wrap [ "systemd" "services" ];
    fileSystems = wrap [ "fileSystems" ];
    system.activationScripts = wrap [ "system" "activationScripts" ];
    assertions = wrap [ "assertions" ];
  };
}
