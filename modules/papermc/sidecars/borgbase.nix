{ config, lib, pkgs, ... }: let
  selfCfg = config.services.papermc;
in lib.mkIf selfCfg.enable {

  # TODO BorgBase backup service definition
  systemd.services.borgbase-mcbackup = {};

}
