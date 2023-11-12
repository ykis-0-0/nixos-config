{ config, lib, pkgs, ... }: {

  systemd.services.wsl-systemd-fix = {
    description = "NixOS-WSL Native SystemD workaround";

    unitConfig = {
      DefaultDependencies = "no";
      Before = [
        "sysinit.target"
        "systemd-tmpfiles-setup-dev.service"
        "systemd-tmpfiles-setup.service"
        "systemd-sysctl.service"
      ];
      ConditionPathExists = "/dev/shm";
      ConditionPathIsSymbolicLink = "/dev/shm";
      ConditionPathIsMountPoint = "/run/shm";
    };

    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "${pkgs.coreutils}/bin/rm /dev/shm"
        "/run/wrappers/bin/mount --bind -o X-mount.mkdir /run/shm /dev/shm"
      ];
    };
    wantedBy = [ "sysinit.target" ];
  };

}
