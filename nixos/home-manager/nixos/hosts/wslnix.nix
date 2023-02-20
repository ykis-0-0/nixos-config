{ config, lib, pkgs, npiperelay, ... }:
let
  hmlib = config.lib;
in {
  home = {
    packages = with pkgs; [
      git
      wget
      rnix-lsp
      nil
    ];

    file = {
      wsl-desktop = {
        source = hmlib.file.mkOutOfStoreSymlink "/mnt/c/Users/YouSuck/Desktop/";
        recursive = false;
      };
    };

    sessionVariables = {
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";
    };
  };

  services = {
    vscode-server.enable = true;
  };

  # KeeAgent NPipeRelay runner
  systemd.user.services.keeagent-relay = {
    Unit = {
      Description = "KeeAgent SSH_AUTH_SOCK relay using npiperelay.exe";
      After = [ "default.target" ];
      # WantedBy = [ "default.target" ];
    };

    Install.WantedBy = [ "default.target" ];

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.socat}/bin/socat UNIX-LISTEN:%t/ssh-agent,fork,umask=007 EXEC:\"${npiperelay}/bin/npiperelay.exe -ep -ei -s -v //./pipe/openssh-ssh-agent\",nofork";
      Restart = "always";
    };
  };

  programs.bash.enable = true; # HACK Temporary fix, should be replaced by something like fish soon?
}
