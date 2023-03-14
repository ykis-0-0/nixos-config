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
      ExecStart = let
        nprArgs = builtins.concatStringsSep " " [
          "-ei" # Terminate on EOF from stdin
          "-ep" # Terminate on EOF from pipe
          "-p" # Poll until pipe available
          "-s" # Send 0-byte message on EOF from stdin
          "-v" # Verbose output on stderr
        ];
        nprCmdline = "${npiperelay}/bin/npiperelay.exe ${nprArgs} //./pipe/openssh-ssh-agent";

        wslSide = "UNIX-LISTEN:%t/ssh-agent,fork,umask=007";
        windowsSide = "EXEC:\"${nprCmdline}\",nofork"; # avoid escaping
      in
        "${pkgs.socat}/bin/socat ${wslSide} ${windowsSide}";
      Restart = "always";
    };
  };

  programs.bash.enable = true; # HACK Temporary fix, should be replaced by something like fish soon?
}
