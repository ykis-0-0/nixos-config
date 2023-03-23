{ config, lib, pkgs, ... }: {
  # The NixOS Kubernetes module have so fucking many traps

  virtualisation.containerd.enable = true;

  services.kubernetes = {
    # TODO make rpi basis
    # TODO make zerotier live on k8s

    /*
      We're going to use static pods in our case,
      so none of these should be enabled.

      Well they are originally disabled anyways lmao
    */
    #region Disable all components & addons except kubelet
    apiserver.enable = false;
    controllerManager.enable = false;
    scheduler.enable = false;
    pki.enable = false;
    proxy.enable = false;
    flannel.enable = false;
    addonManager.enable = false;
    addons.dns.enable = false;
    #endregion

    kubeconfig = {
      caFile = null; # default = cfg.caFile
      certFile = null;
      keyFile = null;
      server = null;
    };

    kubelet = {
      enable = null;
      # address = null;
      # clusterDns = null;
      # clusterDomain = null;
      cni = {
        config = null;
        configDir = null;
        packages = null;
      };
      containerRuntime = "remote";
      containerRuntimeEndpoint = "unix:///run/containerd/containerd.sock";
      extraOpts = null;
      # featureGates = null;
      # healthz = {
      #   bind = null;
      #   port = null;
      # };
      hostname = null;
      kubeconfig = {
        caFile = null;
        certFile = null;
        keyFile = null;
        server = null;
      };
      # manifests = null;
      nodeIp = null; # intentionally left empty
      # port = null;
      # registerNode = null;
      seedDockerImages = null;
      taints."<name>" = {
        effect = null;
        key = null;
        value = null;
      };
      clientCaFile = null;
      tlsCertFile = null;
      tlsKeyFile = null;
      unschedulable = null;
      verbosity = null;
    };

    clusterCidr = null; # "10.1.0.0/16"
    roles = []; # FIXME DO NOT USE "master" or "node" OR ELSE NIXOS FUCKS US UP

    # dataDir = /var/lib/kubernetes;
    # secretsPath = "${cfg.dataDir}"/secrets;

    # services.kubernetes.apiserverAddress = let
    #   apiSrvHost = if
    #     cfg.apiserver.advertiseAddress != null
    #   then
    #     cfg.apiserver.advertiseAddress
    #   else
    #     "${cfg.masterAddress}:${toString cfg.apiserver.securePort}"
    #   ;
    # in mkDefault "https://${apiSrvHost}";
    apiserverAddress = null;
    masterAddress = null;

    easyCerts = false; # Set this up ourselves
    caFile = null;

    featureGates = [];
    path = [];
  };
}
