{ config, lib, pkgs, ... }: {
  services.papermc = {
    enable = true;
    systemd-verbose = false;
    # TODO startOnBoot = false; <- maybe something like this?

    port = 25565;
    memory = {
      min = 1024;
      max = 2560;
    };

    packages = {
      # jre = pkgs.temurin-jre-bin; # Just use DEFAULT!!!
      papermc = {
        version = "1.18.2";
        build = null;
      };
    };

    storages = {
      bin = /home/nixos/papermc/bin;
      etc = /home/nixos/papermc/etc;
      worlds = /home/nixos/papermc/worlds;
      log = /home/nixos/papermc/logs;
      plugins = /home/nixos/papermc/plugins;
      cache = /home/nixos/papermc/bin-cache;
    };
  };
}
