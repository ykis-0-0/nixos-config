{ config, lib, pkgs, ... }: let
  theMapping = {
    rpinix = {
      target = "rpinix.local";
      region = "labo";
      server = true;
      client = true;
    };
    rpi = {
      target = "rpi.local";
      region = "labo";
      server = false;
      client = true;
    };
    bigbox = {
      target = "bigbox.local";
      region = "labo";
      server = true;
      client = true;
    };
    oci-master = {
      target = "oci-master.defaultsubnet.defaultvcn.oraclevcn.com";
      region = "icu";
      server = true;
      client = true;
    };
    oci-helper = {
      target = "oci-helper.defaultsubnet.defaultvcn.oraclevcn.com";
      region = "icu";
      server = true;
      client = true;
    };
    oci-slave = {
      target = "oci-slave.defaultsubnet.defaultvcn.oraclevcn.com";
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
      in map (_: _.value.target) (filter (getAttrFromPath ["value" "server"]) nodes);
    };

    client = {
      enabled = cfg.client;

      server_join.retry_join = let
        inherit (builtins) map getAttr filter;
        inherit (lib) getAttrFromPath;
      in map (_: _.value.target) (filter (el: el.value.server && el.value.region == cfg.region) nodes);
    };

    ui.label.text = "Nomad Aggregate - Node ${thisHost}";
  };

  virtualisation.podman.enable = true;
}
