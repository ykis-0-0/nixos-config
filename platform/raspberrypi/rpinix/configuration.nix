{ config, pkgs, lib, self, secret-wrapper, ... }:
let
  secrets = import "${secret-wrapper}/secrets.nix";
in {
  system.stateVersion = "21.11";

  time.timeZone = "Asia/Hong_Kong";

  services = {
    ddclient = {
      enable = true;
      interval = "12 hours";
      protocol = "noip";
      # server = "dynupdate.no-ip.com" # default
      use = "web, web=checkip.dyndns.com";
      inherit (secrets.ddclient_noip) username passwordFile domains;
    };
  };

  networking = {
    hostName = "rpinix";
    wireless = {
      enable = true; # Enables wireless support via wpa_supplicant.
      # interfaces = []; # A shared instance is enough for Pi
      extraConfig = ''
        country=HK
      ''; # We need this to properly connect and have 5GHz, good thing!
      networks = secrets.wifi;
      userControlled.enable = true;
    };
  };

  pwdHashMgr = {
    enable = true;
    inherit (secrets) passwords;
  };

  users = {
    mutableUsers = false;
    users = {
      nixos = {
        isNormalUser = true;
        /* auto-set:
          group = "users";
          home = "/home/<username>";
          createHome = true;
          useDefaultShell = true;
          isSystemUser = false;
        */
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9jOXlJrzKBjuETPyST35H9Kff9pkRwsoAMoLyMMaNY yousuck@LAPTOP-BRKLKQRT"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9kjdgBDTS4NraDL/j6HHQpZHoUf7iQi/1AL96NZ6caEj8eE0ZJ1CpBWgFxOfnosihynkH6gx/lRThxaPLrEWwslrk0ys3D7Pxo7+/xu34y5gdqB4q9TGjvUVO/5H+tWvrIE/34I5DzDUSZNwFtZPCwhc6BurhsqOIr9eJ5+pGu4H8gSC5nZrPM416Od/uyxaSnvxaIRBfpZCsuza5H7l2IC7rLs0F+NziOFZS2tE7+AhNQ/VgOhAIbLE68IWRLRLnyZT6fZS0T2inPWTwmx6zh0buF8XQD02TUFs/1/omqtI1I0V0Q+reeYlg9ywe2+BWGa3plx291sLixUdnn15lVOcb7lqRHCd+vBwfK+PcMzwLu4QlwE/B0UyPJu17gfa41fiB6P3yWfcoGVSTo9nvCj2HDa7bq56+8m1ewWWiITIW2LlGsyvQVk3qGq8HehABi5VY3/JycFQgjvbxa6sy6gsS6Tn+icHKi6EMopYeLlO0h7sPUxOc4s8hcqOzBGs= yousuck@LAPTOP-BRKLKQRT"
        ];
      };
    };
  };

}
