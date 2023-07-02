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
      ./platform/basic.nix

      # Hardware Platform
      ./platform/0soft/raspberrypi/default.nix
      ./platform/0soft/raspberrypi/storage.nix

      # Firmware & Peripheral Choices
      ./platform/5soft/impermanence/default.nix
      ./platform/5soft/argononed.nix
      ./platform/5soft/yubikey.nix

      # OS Configurations
      # ./platform/soft/passwdmgr/default.nix
      ./platform/soft/flakes.nix
      ./platform/soft/avahi.nix

      # Instance-specific system Overrides
      ./netflix-adaptations/rpinix/overrides.nix

      # Allowed Users
      ./id-10t.5/nixos.nix
      ./id-10t.5/ykis.nix
      ./id-10t.5/deploy-rs.nix

      # Modules & Role Assignments
      ./assignments/sshd.nix
      inputs.sched-reboot.nixosModules.default
      ./assignments/zerotier.nix
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
      ./platform/basic.nix

      # Hardware Platform
      ./platform/0soft/raspberrypi/default.nix
      ./platform/0soft/raspberrypi/storage.nix

      # Firmware & Peripheral Choices
      ./platform/5soft/impermanence/default.nix
      ./platform/5soft/argononed.nix
      ./platform/5soft/yubikey.nix

      # OS Configurations
      # ./platform/soft/passwdmgr/default.nix
      ./platform/soft/flakes.nix
      ./platform/soft/avahi.nix

      # Instance-specific system Overrides
      ./netflix-adaptations/rpi/overrides.nix

      # Allowed Users
      ./id-10t.5/nixos.nix
      ./id-10t.5/ykis.nix
      ./id-10t.5/deploy-rs.nix

      # Modules & Role Assignments
      ./assignments/sshd.nix
      inputs.sched-reboot.nixosModules.default
      ./assignments/zerotier.nix
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
      ./platform/basic.nix

      # Hardware Platform
      ./platform/0soft/wsl/default.nix

      # Firmware & Peripheral Choices

      # OS Configurations
      ./platform/soft/flakes.nix

      # Instance-specific system Overrides
      ./netflix-adaptations/wslnix/overrides.nix

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
      ./platform/basic.nix

      # Hardware Platform
      ./platform/0soft/oci-a1flex/default.nix
      ./platform/0soft/oci-a1flex/storage-ol86.nix
      # ./platform/0soft/oci-a1flex/storage-ubuntu2204.nix

      # Firmware & Peripheral Choices

      # OS Configurations
      ./platform/soft/flakes.nix

      # Instance-specific system Overrides
      ./netflix-adaptations/oci-master/overrides.nix

      # Allowed Users
      ./id-10t.5/opc.nix
      ./id-10t.5/deploy-rs.nix

      # Modules & Role Assignments
      ./assignments/sshd.nix
      inputs.sched-reboot.nixosModules.default
      ./assignments/zerotier.nix
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
      ./platform/basic.nix

      # Hardware Platform
      ./platform/0soft/oci-a1flex/default.nix
      ./platform/0soft/oci-a1flex/storage-ol86.nix
      # ./platform/0soft/oci-a1flex/storage-ubuntu2204.nix

      # Firmware & Peripheral Choices

      # OS Configurations
      ./platform/soft/flakes.nix

      # Instance-specific system Overrides
      ./netflix-adaptations/oci-support/overrides.nix

      # Allowed Users
      ./id-10t.5/opc.nix
      ./id-10t.5/deploy-rs.nix

      # Modules & Role Assignments
      ./assignments/sshd.nix
      inputs.sched-reboot.nixosModules.default
      ./assignments/zerotier.nix
    ];
  };
}
