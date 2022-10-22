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
      ./platform/0soft/virtualbox/default.nix
      ./platform/0soft/virtualbox/storage.nix

      # Firmware & Peripheral Choices
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
      ./platform/0soft/virtualbox/default.nix
      ./platform/0soft/virtualbox/storage.nix

      # Firmware & Peripheral Choices

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
      ./platform/0soft/hyperv/default.nix
      ./platform/0soft/hyperv/storage.nix

      # Firmware & Peripheral Choices

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
      ./platform/0soft/wsl/default.nix

      # Firmware & Peripheral Choices

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
      ./platform/0soft/oracle-cloud/default.nix
      ./platform/0soft/oracle-cloud/storage-ol86.nix
      # ./platform/0soft/oracle-cloud/storage-ubuntu2204.nix

      # Firmware & Peripheral Choices

      # OS Configurations
      ./platform/soft/flakes.nix

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
