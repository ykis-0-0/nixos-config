{ config, lib, pkgs, ... }: {
  services.papermc = {
    enable = true;
    # systemd-verbose = true;
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

    storages = (base': let
      base = toString base';
    in {
      bin = "${base}/papermc/bin";
      etc = "${base}/papermc/etc";
      worlds = "${base}/papermc/worlds";
      log = "${base}/papermc/logs";
      plugins = "${base}/papermc/plugins";
      cache = "${base}/papermc/bin-cache";
    })({
      "rpinix" = /home/nixos;
      "oci-master" = /src/papermc;
    }.${config.networking.hostName});

    admins = builtins.getAttr config.networking.hostName (
      with config.users.users;{
        "rpinix" = [ nixos ];
        "oci-master" = [ opc ];
      }
    );
  };
}
