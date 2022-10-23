{ config, lib, pkgs, ... }: let
  selfCfg = config.services.papermc;
in lib.mkIf selfCfg.enable {

  users = {
    users.papermc = {
      isSystemUser = true;
      hashedPassword = null;
      group = config.users.groups.papermc.name;
    };
    groups.papermc.members = map (el: el.name) selfCfg.admins;
  };

  networking.firewall = {
    allowedTCPPorts = [ selfCfg.port ];
    allowedUDPPorts = [ selfCfg.port ];
  };

}
