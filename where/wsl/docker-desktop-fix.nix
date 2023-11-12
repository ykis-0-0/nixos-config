{ config, lib, pkgs, ... }: let
  top = config.wsl;
  dockerRoot = "${top.wslConf.automount.root}/wsl/docker-desktop";
  proxyPath = "${dockerRoot}/docker-desktop-user-distro";
in {
  systemd.services.docker-desktop-proxy = {
    path = [ pkgs.mount ];
    script = lib.mkForce ''
      ${proxyPath} proxy /run/docker1.sock --docker-desktop-root ${dockerRoot}
    '';
    unitConfig.ConditionPathExists = proxyPath;
  };

  systemd.paths.docker-desktop-proxy = {
    enable = top.docker-desktop.enable;
    description = "Watcher for Docker Desktop proxy integration";
    # IDEA can we shift the burden to docker-desktop-proxy.service itself?
    wantedBy = [ "multi-user.target" ];

    pathConfig = {
      PathExists = proxyPath;
    };
  };
}
