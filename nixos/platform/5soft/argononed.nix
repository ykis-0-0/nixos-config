{ config, lib, pkgs, argononed, ...}:
{
  imports = [
    "${argononed}/OS/nixos/default.nix"
  ];

  services.argonone = {
    enable = true;
    logLevel = 4;
    settings = {
      fanTemp0 = 41; fanSpeed0 = 20;
      fanTemp1 = 46; fanSpeed1 = 50;
      fanTemp2 = 51; fanSpeed2 = 80;
      hysteresis = 4;
    };
  };
}
