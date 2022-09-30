{ config, lib, pkgs, ... }: {
  services.papermc = {
    enable = false;
    port = 25565;
    memory = {
      min = 1024;
      max = 2560;
    };

    packages = {
      jre = pkgs.jre_minimal;
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
