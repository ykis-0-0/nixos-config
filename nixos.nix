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
      ./platform/0soft/raspberrypi/configuration.nix
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
      ./platform/0soft/raspberrypi/hardware.nix
      ./platform/0soft/raspberrypi/storage.nix
      ./platform/5soft/impermanence/wrapper.nix
      ./platform/5soft/impermanence/switcher.nix
      ./platform/soft/passwdmgr/default.nix
      ./platform/soft/flakes.nix
      "${inputs.argononed}/OS/nixos/default.nix"
      ./expectations/argononed.nix
      ./platform/soft/avahi.nix
      ./assignments/sshd.nix
      ./assignments/ddclient.nix
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
      ./platform/basic.nix
      ./platform/0soft/virtualbox/configuration.nix
      ./platform/0soft/virtualbox/hardware.nix
      ./platform/0soft/virtualbox/storage.nix
      ./platform/5soft/impermanence/wrapper.nix
      ./platform/5soft/impermanence/switcher.nix
      ./platform/soft/flakes.nix
      # ./platform/5soft/pipewire.nix
      ./assignments/gui/awesome.nix
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
      ./platform/basic.nix
      ./platform/0soft/virtualbox/configuration.nix
      ./platform/0soft/virtualbox/hardware.nix
      ./platform/0soft/virtualbox/storage.nix
      ./platform/5soft/impermanence/wrapper.nix
      ./platform/5soft/impermanence/switcher.nix
      ./platform/soft/flakes.nix
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
      ./platform/basic.nix
      ./platform/0soft/hyperv/configuration.nix
      ./platform/0soft/hyperv/hardware.nix
      ./platform/0soft/hyperv/storage.nix
      ./platform/5soft/impermanence/wrapper.nix
      ./platform/5soft/impermanence/switcher.nix
      ./platform/soft/flakes.nix
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
      ./platform/basic.nix
      ./platform/0soft/wsl/configuration.nix
      inputs.nixos-wsl.nixosModules.wsl
      ./platform/soft/flakes.nix
    ];
  };
}
