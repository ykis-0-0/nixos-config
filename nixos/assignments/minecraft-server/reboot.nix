{ config, lib, pkgs, ... }: {
  services.sched-reboot = {
    enabled = true;
    happenOn = "*-*-* 04:00:00";
    gracePeriod = "3min";
  };
}
