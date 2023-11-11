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
      ./where/basic.nix

      # Hardware Platform
      ./where/virtualbox/default.nix
      ./where/virtualbox/storage.nix

      # Firmware & Peripheral Choices
      # ./what/pipewire.nix

      # OS Configurations
      ./what/flakes.nix

      # Instance-specific system Overrides
      ./when/vbox-proxy.nix

      # Allowed Users
      ./who/nixos/nixos.nix

      # Modules & Role Assignments
      ./what/gui/awesome.nix
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
      ./where/basic.nix

      # Hardware Platform
      ./where/virtualbox/default.nix
      ./where/virtualbox/storage.nix

      # Firmware & Peripheral Choices

      # OS Configurations
      ./what/flakes.nix

      # Instance-specific system Overrides
      ./when/vbox-test.nix

      # Allowed Users
      ./who/nixos/nixos.nix

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
      ./where/basic.nix

      # Hardware Platform
      ./where/hyperv/default.nix
      ./where/hyperv/storage.nix

      # Firmware & Peripheral Choices

      # OS Configurations
      ./what/flakes.nix

      # Instance-specific system Overrides
      ./when/hyperv-test.nix

      # Allowed Users
      ./who/nixos/nixos.nix

      # Modules & Role Assignments
    ];
  };


}
