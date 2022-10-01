{ self, deploy-rs, ... } @ inputs: let
  getArch = config: config.pkgs.stdenv.hostPlatform.system;
  mkDeploy = baseOs: deployer: let
    d-lib = deploy-rs.lib.${getArch baseOs};
  in deployer {
    inherit baseOs d-lib;
  };
in {
  /* oci-master = {
    host = "ykis.ddns.net";
    system = {};
  }; */

  rpinix = mkDeploy self.nixosConfigurations.rpinix ({ baseOs, d-lib }: {
    hostname = "rpinix";
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
}
