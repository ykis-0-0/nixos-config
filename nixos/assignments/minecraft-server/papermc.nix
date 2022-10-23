{ config, lib, pkgs, ... }: {
  services.papermc = {
    enable = true;
    # systemd-verbose = true;
    startOnBoot = true;

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
