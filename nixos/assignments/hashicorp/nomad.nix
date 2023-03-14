{ config, lib, pkgs, ... }: {
  services.nomad = {
    enable = true;
    extraPackages = with pkgs; [
      # cni-plugins
    ];
    extraSettingsPlugins = with pkgs; [
      nomad-driver-podman
    ];

    enableDocker = false;
    extraSettingsPaths = [ ./nomad.d /*"/etc/nomad/config.d/"*/ ];

    settings = {
      # data_dir predefined by NixOS

      server = {
        enabled = lib.mkDefault false;
      };

      client = {
        enabled = lib.mkDefault false;

        cni_path = "${pkgs.cni-plugins}/bin";
      };

      ui.enabled = true;
    };
  };

  systemd.services.nomad.serviceConfig.Restart = lib.mkForce "no";

  networking.firewall = {
    allowedTCPPorts = [ 4646 4647 4648 ];
    allowedUDPPorts = [ 4648 ];
  };
}
