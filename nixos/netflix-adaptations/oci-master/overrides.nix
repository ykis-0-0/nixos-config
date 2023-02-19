{ config, lib, pkgs, ... }: {

  networking.hostName = "oci-master";

  users.users.root.password = "oci-rescue";

  services.sched-reboot = {
    enabled = true;
    happenOn = "*-*-1..31/2 03:30:00";
    gracePeriod = "3min";
  };
}
