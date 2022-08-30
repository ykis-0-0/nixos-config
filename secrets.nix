let
  REDACTED = usage: "Wanna steal my ${usage}? Next time bitch :-)";
in {
  wifi = {
    "${REDACTED "WiFi SSID"}" = {
      psk = REDACTED "WiFi password";
      authProtocols = [ "WPA-PSK" ];
      priority = 1;
    };

    "${REDACTED "WiFi SSID"}" = {
      psk = REDACTED "WiFi password";
      authProtocols = [ "WPA-PSK" ];
    };
  };

  ddclient_noip = {
    username = REDACTED "No-IP account";
    passwordFile = builtins.toFile "ddclient-passwd" (REDACTED "No-IP password");
    domains = [
      # "ykis.ddns.net" # Allocated for minecraft server
      "ykis-host.ddns.net"
    ];
  };
}
