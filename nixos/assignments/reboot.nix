{ config, lib, pkgs, ... }: {
  services.sched-reboot = {
    enabled = true;
    happenOn = "*-*-1..31/2 04:00:00";
    gracePeriod = "3min";
  };
}
