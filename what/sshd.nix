{
  services.openssh = {
    enable = true;
    settings.X11Forwarding = true;
    extraConfig = ''
      ClientAliveInterval 10
    '';
  };
}
