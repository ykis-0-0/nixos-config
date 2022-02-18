{ lib, pkgs, config, options, ... }:
{ # Shout out to https://www.reddit.com/r/NixOS/comments/j8jyfc/add_channel_declaratively/

  options.nix-channels = let
    inherit (lib) mkOption;
    inherit (lib.types) uniq attrsOf string;
  in {
    enable = lib.mkEnableOption "Manage Nix channels declaratively";

    dir = mkOption {
      description = "The subdirectory within `/etc` for linking to channels";
      default = "nix-channels";
      type = uniq string;
    };

    nixpkgs = {
      channelName = mkOption {
        description = "The name of main channel used for <nixpkgs>";
        example = "nixos";
        type = uniq string;
      };

      url = mkOption {
        description = "The url of main channel used for <nixpkgs>";
        example = "https://nixos.org/channels/nixos-21.11-aarch64";
        type = uniq string;
      };
    };

    extraChannels = mkOption {
      description = "Other channels to subscribe to";
      example = ''{
        home-manager = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
      }'';

      type = uniq (attrsOf string);
    };
  };

  config = let
    cfg = config.nix-channels;

    nixpkgs-exprs = fetchTarball {
      inherit (cfg.nixpkgs) url;
      name = cfg.nixpkgs.channelName;
    };
    allChannels = let
      inherit (cfg.nixpkgs) channelName url;
    in
      cfg.extraChannels // {"${channelName}" = url;};
    nixexprs = builtins.mapAttrs (name: url: fetchTarball { inherit name url; }) allChannels;
  in
    lib.mkIf cfg.enable {

      # Declarative system channel
      # This will download the channel every time you run nixos-rebuild
      nixpkgs.pkgs = import "${nixpkgs-exprs}" {
        inherit (config.nixpkgs) config overlays localSystem crossSystem;
      };

      # > Since we don't want to download the channel every time
      # > we use it (e.g. nix-shell), we cache it locally
      # Improvised to accomodate multiple channels
      environment.etc = let
        inherit (builtins) concatStringsSep;
        inherit (lib.attrsets) mapAttrsToList;
        mkLink = link: toEntity: "ln -sfn ${toEntity} $out/channels/${link}";
        script = pkgs.runCommand "channels" {} ''
          mkdir -p $out/channels

          ${concatStringsSep "\n" (mapAttrsToList mkLink nixexprs)}

          ln -sfn channels/${cfg.nixpkgs.channelName} $out/nixpkgs
        '';
      in
        {
          "${cfg.dir}".source = "${script}";
        };

      nix.nixPath = [
        "nixpkgs=/etc/${cfg.dir}/nixpkgs"
        "nixos-config=/etc/nixos/configuration.nix"
        "/etc/${cfg.dir}/channels"
      ];

      # For a declarative overlay you can do pretty much the same
      # *snip* We don't need overlays rn /shrug
  };
}
