{ config, lib, pkgs, ... }: let
  selfCfg = config.services.papermc;
in lib.mkIf selfCfg.enable {

  users.groups.papermc.members = map (el: el.name) selfCfg.admins;

}
