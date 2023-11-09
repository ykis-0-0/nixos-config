{ config, lib, pkgs, ... }: {

  networking.hostName = "oci-agent";

  users.users.root.password = "oci-rescue";

  services.sched-reboot = {
    enabled = true;
    happenOn = "*-*-1..31/2 04:30:00";
    gracePeriod = "3min";
  };
}
