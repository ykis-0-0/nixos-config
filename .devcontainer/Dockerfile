FROM ghcr.io/xtruder/nix-devcontainer:v1

RUN mkdir /tmp/container-direnv

RUN nix-env -iA nixpkgs.{rnix-lsp,nil}
