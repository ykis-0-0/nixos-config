inputs: {
  /*moduleArgs' = {
    inherit (inputs)
    self
    nixpkgs nixos-hardware nixos-wsl
    impermanence home-manager
    vscode-server-patch nix-matlab deploy-rs argononed npiperelay
    secret-wrapper
  };*/

  rpinix = {
    moduleArgs = {
      inherit (inputs)
      nixos-hardware
      impermanence
      vscode-server-patch argononed
      secret-wrapper
      ;
    };
    modules = [
      # Common Base Configs
      ./where/basic.nix

      # Hardware Platform
      ./where/raspberrypi/default.nix
      ./where/raspberrypi/storage.nix

      # Firmware & Peripheral Choices
      ./how/impermanence/default.nix
      ./what/argononed.nix
      ./what/yubikey.nix

      # OS Configurations
      # ./how/passwdmgr/default.nix
      ./what/flakes.nix
      ./what/avahi.nix

      # Instance-specific system Overrides
      ./when/rpinix.nix

      # Allowed Users
      ./who/nixos/nixos.nix
      ./who/deploy-rs/nixos.nix

      # Modules & Role Assignments
      ./what/sshd.nix
      inputs.sched-reboot.nixosModules.default
      ./what/zerotier.nix
    ];
  };

  rpi = {
    moduleArgs = {
      inherit (inputs)
      nixos-hardware
      impermanence
      vscode-server-patch argononed
      secret-wrapper
      ;
    };
    modules = [
      # Common Base Configs
      ./where/basic.nix

      # Hardware Platform
      ./where/raspberrypi/default.nix
      ./where/raspberrypi/storage.nix

      # Firmware & Peripheral Choices
      ./how/impermanence/default.nix
      ./what/argononed.nix
      ./what/yubikey.nix

      # OS Configurations
      # ./how/passwdmgr/default.nix
      ./what/flakes.nix
      ./what/avahi.nix

      # Instance-specific system Overrides
      ./when/rpi.nix

      # Allowed Users
      ./who/nixos/nixos.nix
      ./who/deploy-rs/nixos.nix

      # Modules & Role Assignments
      ./what/sshd.nix
      inputs.sched-reboot.nixosModules.default
      ./what/zerotier.nix
    ];
  };

  wslnix = {
    moduleArgs = {
      inherit (inputs)
      nixos-wsl
      vscode-server-patch
      secret-wrapper
      ;
    };
    modules = [
      # Common Base Configs
      ./where/basic.nix

      # Hardware Platform
      ./where/wsl/default.nix

      # Firmware & Peripheral Choices

      # OS Configurations
      ./what/flakes.nix

      # Instance-specific system Overrides
      ./when/wslnix.nix

      # Allowed Users

      # Modules & Role Assignments
    ];
  };

  oci-master = {
    moduleArgs = {
      inherit (inputs)
      impermanence
      ;
    };
    modules = [
      # Common Base Configs
      ./where/basic.nix

      # Hardware Platform
      ./where/oci-a1flex/default.nix
      ./where/oci-a1flex/storage-ol86.nix
      # ./where/oci-a1flex/storage-ubuntu2204.nix

      # Firmware & Peripheral Choices

      # OS Configurations
      ./what/flakes.nix

      # Instance-specific system Overrides
      ./when/oci-master.nix

      # Allowed Users
      ./who/opc/nixos.nix
      ./who/deploy-rs/nixos.nix

      # Modules & Role Assignments
      ./what/sshd.nix
      inputs.sched-reboot.nixosModules.default
      ./what/zerotier.nix
    ];
  };

  oci-agent = {
    moduleArgs = {
      inherit (inputs)
      impermanence
      ;
    };
    modules = [
      # Common Base Configs
      ./where/basic.nix

      # Hardware Platform
      ./where/oci-a1flex/default.nix
      ./where/oci-a1flex/storage-ol86.nix
      # ./where/oci-a1flex/storage-ubuntu2204.nix

      # Firmware & Peripheral Choices

      # OS Configurations
      ./what/flakes.nix

      # Instance-specific system Overrides
      ./when/oci-agent.nix

      # Allowed Users
      ./who/opc/nixos.nix
      ./who/deploy-rs/nixos.nix

      # Modules & Role Assignments
      ./what/sshd.nix
      inputs.sched-reboot.nixosModules.default
      ./what/zerotier.nix
    ];
  };
}
