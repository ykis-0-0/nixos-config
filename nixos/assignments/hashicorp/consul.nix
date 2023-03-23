{ config, lib, pkgs, ... }: {
  services.consul = {
    enable = true;
    webUi = null;

    extraConfig = {
      # data_dir defined by NixOS

      log_level = "DEBUG";

    };
  };

  # NixOS Wiki told us to do this
  systemd.services.consul.serviceConfig.Type = "notify";
}
