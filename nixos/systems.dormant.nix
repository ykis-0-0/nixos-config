# pastebin for dormant systems definitions (for saving the flake checking time)
inputs: {
  vbox-proxy = {
    moduleArgs = {
      inherit (inputs)
      impermanence
      secret-wrapper
      ;
    };
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

      # Instance-specific system Overrides
      ./netflix-adaptations/vbox-proxy/overrides.nix

      # Allowed Users
      ./id-10t.5/nixos.nix

      # Modules & Role Assignments
      ./assignments/gui/awesome.nix
    ];
  };

  vbox-test = {
    moduleArgs = {
      inherit (inputs)
      impermanence
      secret-wrapper
      ;
    };
    modules = [
      # Common Base Configs
      ./platform/basic.nix

      # Hardware Platform
      ./platform/0soft/virtualbox/default.nix
      ./platform/0soft/virtualbox/storage.nix

      # Firmware & Peripheral Choices

      # OS Configurations
      ./platform/soft/flakes.nix

      # Instance-specific system Overrides
      ./netflix-adaptations/vbox-test/overrides.nix

      # Allowed Users
      ./id-10t.5/nixos.nix

      # Modules & Role Assignments
    ];
  };

  hyperv-test = {
    moduleArgs = {
      inherit (inputs)
      impermanence
      secret-wrapper
      ;
    };
    modules = [
      # Common Base Configs
      ./platform/basic.nix

      # Hardware Platform
      ./platform/0soft/hyperv/default.nix
      ./platform/0soft/hyperv/storage.nix

      # Firmware & Peripheral Choices

      # OS Configurations
      ./platform/soft/flakes.nix

      # Instance-specific system Overrides
      ./netflix-adaptations/hyperv-test/overrides.nix

      # Allowed Users
      ./id-10t.5/nixos.nix

      # Modules & Role Assignments
    ];
  };


}
