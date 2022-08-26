# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports = [];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  # Set your time zone.
  # time.timeZone = "Asia/Hong_Kong";

  networking = {
    # Define your hostname.
    hostName = "nixos";

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp0s3.useDHCP = true;

    # Pick only one of the below networking options.
    /*
    # Enables wireless support via wpa_supplicant.
    wireless = {
      enable = true
      # interfaces = []; # A shared instance is enough for Pi
      extraConfig = ''
        country=HK
      ''; # We need this to properly connect and have 5GHz, good thing!
      networks = {
        [INSERT SSID HERE] = {
          psk = # [INSERT PSK HERE];
          authProtocols = [ "WPA-PSK" ]; # Or other suitable
        };
      };
      userControlled.enable = true; # allows usage of wpa_cli
    };
    *//*
    # Easiest to use and most distros use this by default.
    networkmanager.enable = true;
    */

    /*
    # Configure network proxy if necessary
    proxy = {
      default = "http://user:password@proxy:port/";
      noProxy = "127.0.0.1,localhost,internal.domain";
    };
    */

    /*
    firewall = {
      # Open ports in the firewall.
      allowedTCPPorts = [ ... ];
      allowedUDPPorts = [ ... ];

      # Or disable the firewall altogether.
      enable = false;
    };
    */
  };

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";

  /*
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    # use xkbOptions in tty.
    useXkbConfig = true;
  };
  */

  services = {
    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    /*
    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      # Configure keymap in X11
      layout = "us";
      xkbOptions = {
        "eurosign:e";
        "caps:escape" # map caps to escape.
      };

      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
    };
    */

    # Enable CUPS to print documents.
    # printing.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  #   firefox
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs = {
  #   mtr.enable = true;
  #   gnupg.agent = {
  #    enable = true;
  #    enableSSHSupport = true;
  #   };
  # };

}

