{ config, lib, pkgs, ... }: {
  options.services.sched-reboot = let
    inherit (lib) mkOption mkEnableOption types;
  in {
    enabled = mkEnableOption "periodically scheduled reboot";

    happenOn = mkOption {
      type = types.str;
      description = "When would the reboot happen";
      example = "*-*-* 04:00:00";
    };

    gracePeriod = mkOption {
      type = types.str;
      description = "Length of grace period before services stop and reboot";
      example = "3min";
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
          description = "Periodical Maintainence Reboot";
          wantedBy = [ "multi-user.target" ];

          timerConfig = {
            OnCalendar = self.happenOn; #"*-*-* 04:00:00";
            Unit = "sched-reboot.timer";
          };
        };

        sched-reboot = {
          enable = true;
          description = "Daily Maintainence Reboot Notice Period";

          timerConfig = {
            OnActiveSec = "3min"; #;
          };
        };
      };
    };
  };
}
