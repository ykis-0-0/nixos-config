{ argononed, ...}:
{
  imports = [ "${argononed}/OS/nixos" ];

  services.argonone = {
    enable = true;
    logLevel = 4;
    settings = {
      fanTemp0 = 36; fanSpeed0 = 10;
      fanTemp1 = 41; fanSpeed1 = 50;
      fanTemp2 = 46; fanSpeed2 = 80;
      hysteresis = 4;
    };
  };
}
