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
      ./platform/basic.nix
      ./platform/raspberrypi/rpinix/configuration.nix
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
      ./platform/raspberrypi/rpinix/hardware.nix
      ./platform/raspberrypi/rpinix/storage.nix
      ./expectations/switch_persistence.nix
      ./platform/soft/passwdmgr/default.nix
      ./platform/soft/flakes.nix
      ./expectations/argononed.nix
      ./platform/soft/avahi.nix
      ./assignments/sshd.nix
      ./assignments/ddclient.nix
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
      ./platform/basic.nix
      ./platform/vbox/base/configuration.nix
      ./platform/vbox/base/hardware.nix
      ./platform/vbox/base/storage.nix
      ./expectations/switch_persistence.nix
      ./platform/soft/flakes.nix
      # ./expectations/pipewire.nix
      ./assignments/gui/awesome.nix
      ./platform/vbox/proxy/overrides.nix
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
      ./platform/basic.nix
      ./platform/vbox/base/configuration.nix
      ./platform/vbox/base/hardware.nix
      ./platform/vbox/base/storage.nix
      ./expectations/switch_persistence.nix
      ./platform/soft/flakes.nix
      ./platform/vbox/test/overrides.nix
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
      ./platform/basic.nix
      ./platform/hyperv/base/configuration.nix
      ./platform/hyperv/base/hardware.nix
      ./platform/hyperv/base/storage.nix
      ./expectations/switch_persistence.nix
      ./platform/soft/flakes.nix
      ./platform/hyperv/test/overrides.nix
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
      ./platform/basic.nix
      ./platform/wsl/base/configuration.nix
      inputs.nixos-wsl.nixosModules.wsl
      ./platform/soft/flakes.nix
    ];
  };
}
