{
  services.openssh = {
    enable = true;
    forwardX11 = true;
    extraConfig = ''
      ClientAliveInterval 10
    '';
  };
}
