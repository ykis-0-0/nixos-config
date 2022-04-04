{ nix-matlab, ... }:
{
  nixpkgs.overlays = [ nix-matlab.overlay ];
}
