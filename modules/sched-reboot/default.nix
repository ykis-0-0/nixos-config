{ config, lib, pkgs, ... }: {
  options.services.sched-reboot = let
    inherit (lib) mkOption mkEnableOption types;
  in {
    enabled = mkEnableOption "periodically scheduled reboot";

    happenOn = mkOption {
      type = types.string;
      description = "When would the reboot happen";
    };

    gracePeriod = mkOption {
      type = types.string;
      description = "Length of grace period before services stop and reboot";
    };
  };
  config = let
    self = config.services.sched-reboot;
  in lib.mkIf self.enabled {
    systemd = {
      services.sched-reboot = {
        enable = true;
        description = "Scheduled Reboot";

        serviceConfig.ExecStart = "/run/current-system/sw/bin/reboot";
      };

      timers = {
        curfew-warden = {
          enable = true;
          description = "Daily Maintainence Reboot";

          timerConfig = {
            OnCalendar = self.happenOn; #"*-*-* 04:00:00";
            Unit = "sched-reboot.timer";
          };
        };

        sched-reboot = {
          enable = false;
          description = "Daily Maintainence Reboot Notice Period";

          timerConfig = {
            OnActiveSec = "3min"; #;
          };
        };
      };
    };
  };
}
