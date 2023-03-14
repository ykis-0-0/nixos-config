{ config, lib, pkgs, ... }: let
  theMapping = {
    rpinix = {
      region = "labo";
      server = true;
      client = true;
    };
    rpi = {
      region = "labo";
      server = false;
      client = true;
    };
    bigbox = {
      region = "labo";
      server = true;
      client = true;
    };
    oci-master = {
      region = "icu";
      server = true;
      client = true;
    };
    oci-helper = {
      region = "icu";
      server = true;
      client = true;
    };
    oci-slave = {
      region = "icu";
      server = false;
      client = true;
    };
  };
  thisHost = config.networking.hostName;
  isEnabled = config.services.nomad.enable;
  isHere = builtins.elem thisHost (builtins.attrNames theMapping);
  predicate = lib.warnIfNot (isHere -> isEnabled) "Nomad customization exists without an enabled service." (isHere && isEnabled);
in {
  services.nomad.settings = let
    cfg = theMapping.${config.networking.hostName};
    nodes = lib.mapAttrsToList lib.nameValuePair theMapping;
  in lib.mkIf predicate {
    name = thisHost;
    inherit (cfg) region;

    server = {
      enabled = cfg.server;

      server_join.retry_join = let
        inherit (builtins) map getAttr filter;
        inherit (lib) getAttrFromPath;
      in map (getAttr "name") (filter (getAttrFromPath ["value" "server"]) nodes);
    };

    client = {
      enabled = cfg.client;

      server_join.retry_join = let
        inherit (builtins) map getAttr filter;
        inherit (lib) getAttrFromPath;
      in map (getAttr "name") (filter (el: el.value.server && el.value.region == cfg.region) nodes);
    };

    ui.label.text = "Nomad Aggregate - Node ${thisHost}";
  };
}
