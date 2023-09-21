{ self, deploy-rs, ... } @ inputs: let
  getArch = config: config.pkgs.stdenv.hostPlatform.system;
  mkDeploy = baseOs: deployer: let
    d-lib = deploy-rs.lib.${getArch baseOs};
  in deployer {
    inherit baseOs d-lib;
  };
in {
  rpinix = mkDeploy self.nixosConfigurations.rpinix ({ baseOs, d-lib }: {
    hostname = "rpinix.local";
    sshUser = "deploy-rs";

    profilesOrder = [ "system" /*"nixos"*/ ];

    profiles = {
      system = {
        user = "root";
        path = d-lib.activate.nixos baseOs;
      };

      /*nixos = {
        user = "nixos";
        path = d-lib.activate.home-manager self.homeConfigurations."nixos@rpi"; # TODO create
      };*/
    };
  });

  rpi = mkDeploy self.nixosConfigurations.rpi ({ baseOs, d-lib }: {
    hostname = "rpi.local";
    sshUser = "deploy-rs";

    profilesOrder = [ "system" /*"nixos"*/ ];

    profiles = {
      system = {
        user = "root";
        path = d-lib.activate.nixos baseOs;
      };

      /*nixos = {
        user = "nixos";
        path = d-lib.activate.home-manager self.homeConfigurations."nixos@rpinix";
      };*/
    };
  });

  oci-master = mkDeploy self.nixosConfigurations.oci-master ({ baseOs, d-lib }: {
    hostname = "ykis-ocimaster.ddns.net";
    sshUser = "deploy-rs";

    profilesOrder = [ "system" ];

    profiles = {
      system = {
        user = "root";
        path = d-lib.activate.nixos baseOs;
      };
    };
  });

  oci-agent = mkDeploy self.nixosConfigurations.oci-agent ({ baseOs, d-lib }: {
    hostname = "ykis-ociagent.ddns.net";
    sshUser = "deploy-rs";

    profilesOrder = [ "system" ];

    profiles = {
      system = {
        user = "root";
        path = d-lib.activate.nixos baseOs;
      };
    };
  });
}
