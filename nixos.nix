inputs: {
  /*includeInputs' = [
    "self"
    "nixos" "nixos-hardware" "nixos-wsl"
    "impermanence" "home-manager"
    "vscode-server-patch" "nix-matlab" "argononed"
    "secret-wrapper"
  ];*/

  rpinix = {
    system = "aarch64-linux";
    includeInputs = [
      "nixos" "nixos-hardware"
      "impermanence"
      "vscode-server-patch" "argononed"
      "secret-wrapper"
    ];
    modules = [
      # Common Base Configs
      ./platform/basic.nix

      # Hardware Platform
      ./platform/0soft/raspberrypi/configuration.nix
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
      ./platform/0soft/raspberrypi/hardware.nix
      ./platform/0soft/raspberrypi/storage.nix

      # Firmware Choices
      ./platform/5soft/impermanence/wrapper.nix
      ./platform/5soft/impermanence/switcher.nix
      "${inputs.argononed}/OS/nixos/default.nix"
      ./platform/5soft/argononed.nix

      # OS Configurations
      # ./platform/soft/passwdmgr/default.nix
      ./platform/soft/flakes.nix
      ./platform/soft/avahi.nix

      # Roles Assignment
      ./assignments/sshd.nix
      ./assignments/ddclient.nix

      # Allowed Users
      ./id-10t.5/nixos.nix
      ./id-10t.5/ykis.nix
      ./id-10t.5/deploy-rs.nix

      # Instance-specific Overrides
      ./netflix-adaptations/rpinix/overrides.nix
    ];
  };

  vbox-proxy = {
    system = "x86_64-linux";
    includeInputs = [
      "nixos" "nixos-hardware"
      "impermanence"
      "secret-wrapper"
    ];
    modules = [
      # Common Base Configs
      ./platform/basic.nix

      # Hardware Platform
      ./platform/0soft/virtualbox/configuration.nix
      ./platform/0soft/virtualbox/hardware.nix
      ./platform/0soft/virtualbox/storage.nix

      # Firmware Choices
      # ./platform/5soft/pipewire.nix

      # OS Configurations
      ./platform/soft/flakes.nix

      # Roles Assignment
      ./assignments/gui/awesome.nix

      # Allowed Users
      ./id-10t.5/nixos.nix

      # Instance-specific Overrides
      ./netflix-adaptations/vbox-proxy/overrides.nix
    ];
  };

  vbox-test = {
    system = "x86_64-linux";
    includeInputs = [
      "nixos" "nixos-hardware"
      "impermanence"
      "secret-wrapper"
    ];
    modules = [
      # Common Base Configs
      ./platform/basic.nix

      # Hardware Platform
      ./platform/0soft/virtualbox/configuration.nix
      ./platform/0soft/virtualbox/hardware.nix
      ./platform/0soft/virtualbox/storage.nix

      # Firmware Choices

      # OS Configurations
      ./platform/soft/flakes.nix

      # Roles Assignment

      # Allowed Users
      ./id-10t.5/nixos.nix

      # Instance-specific Overrides
      ./netflix-adaptations/vbox-test/overrides.nix
    ];
  };

  hyperv-test = {
    system = "x86_64-linux";
    includeInputs = [
      "nixos" "nixos-hardware"
      "impermanence"
      "secret-wrapper"
    ];
    modules = [
      # Common Base Configs
      ./platform/basic.nix

      # Hardware Platform
      ./platform/0soft/hyperv/configuration.nix
      ./platform/0soft/hyperv/hardware.nix
      ./platform/0soft/hyperv/storage.nix

      # Firmware Choices

      # OS Configurations
      ./platform/soft/flakes.nix

      # Roles Assignment

      # Allowed Users
      ./id-10t.5/nixos.nix

      # Instance-specific Overrides
      ./netflix-adaptations/hyperv-test/overrides.nix
    ];
  };

  wslnix = {
    system = "x86_64-linux";
    includeInputs = [
      "nixos" "nixos-wsl"
      "vscode-server-patch"
      "secret-wrapper"
    ];
    modules = [
      # Common Base Configs
      ./platform/basic.nix

      # Hardware Platform
      inputs.nixos-wsl.nixosModules.wsl
      ./platform/0soft/wsl/configuration.nix

      # Firmware Choices

      # OS Configurations
      ./platform/soft/flakes.nix

      # Roles Assignment

      # Allowed Users

      # Instance-specific Overrides
      ./netflix-adaptations/wslnix/overrides.nix
    ];
  };

  oci-master = {
    system = "aarch64-linux";
    includeInputs = [
      "nixos" "nixos-hardware"
      "impermanence"
    ];
    modules = [
      # Common Base Configs
      ./platform/basic.nix

      # Hardware Platform
      ./platform/0soft/oracle-cloud/configuration.nix
      ./platform/0soft/oracle-cloud/hardware.nix
      "${inputs.nixos}/nixos/modules/profiles/qemu-guest.nix"
      ./platform/0soft/oracle-cloud/storage.nix

      # Firmware Choices

      # OS Configurations

      # Roles Assignment
      ./assignments/sshd.nix

      # Allowed Users
      ./id-10t.5/opc.nix
      ./id-10t.5/deploy-rs.nix

      # Instance-specific Overrides
      ./netflix-adaptations/oci-master/overrides.nix
    ];
  };
}
