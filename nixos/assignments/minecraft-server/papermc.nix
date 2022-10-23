{ config, lib, pkgs, ... }: {
  services.papermc = {
    enable = true;
    # systemd-verbose = true;
    startOnBoot = true;

    port = 25565;
    memory = {
      "rpinix" = {
        min = 1024;
        max = 2560;
      };
      "oci-master" = {
        min = 1024;
        max = 10240;
      };
    }.${config.networking.hostName};

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
      bin = "${base}/bin";
      etc = "${base}/etc";
      worlds = "${base}/worlds";
      log = "${base}/logs";
      plugins = "${base}/plugins";
      cache = "${base}/bin-cache";
    })({
      "rpinix" = /home/nixos/papermc;
      "oci-master" = /srv/papermc;
    }.${config.networking.hostName});

    admins = with config.users.users; {
      "rpinix" = [ nixos ];
      "oci-master" = [ opc ];
    }.${config.networking.hostName};
  };
}
