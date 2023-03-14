client {
  // enabled = false # Decided per node

  // servers = [] # Dominated by server_join
  // server_join # Controlled by NixOS Config

  // node_class # Controlled by NixOS Config
  // meta # Controlled by NixOS Config

  // state_dir = "[/var/lib/nomad]/client"
  // alloc_dir = "[/var/lib/nomad]/alloc"

  // cni_path = ${pkgs.cni-plugins}/bin
  // cni_config_dir = "/opt/cni/config"

  chroot_env {
    # Unpopulated
  }

  // cgroup_parent = "/nomad"
  // disable_remote_exec =  false
  // no_host_uuid = true
  // max_kill_timeout = "30s"
  // network_interface = "" # interface to force network fingerprinting on

  // cpu_total_compute = 0
  // memory_total_mb = 0
  // disk_total_mb = 0
  // disk_free_mb = 0

  reserved {
    // cpu = 0
    // cores = 0
    memory = 10
    disk = 20
    // reserved_ports = ""
  }

  // min_dynamic_port = 20000
  // max_dynamic_port = 32000

  // bridge_network_name= "nomad"
  // bridge_network_subnet= "172.26.64.0/20"
  // bridge_network_hairpin_mode= "false"

  // gc_interval = "1m"
  // gc_disk_usage_threshold = 80
  // gc_inode_usage_threshold = 70
  // gc_max_allocs = 50
  // gc_parallel_destroys = 2

  /* host_network "test" {
    interface = ""
    cidr = ""
    reserved_ports = ""
  } */

  /* host_volume "test" {
    path = ""
    read_only = false
  } */

  // options = null

  artifact {
    // http_read_timeout = "30m"
    // http_max_size = "100GB"
    // gcs_timeout = "30m"
    // git_timeout = "30m"
    // hg_timeout = "30m"
    // s3_timeout = "30m"
    // decompression_size_limit = "100GB"
    // decompression_file_count_limit = 4096
    // disable_filesystem_isolation = false
    // set_environment_variables = ""
  }

  template {
    // function_denylist = ["plugin", "writeToFile"]
    // disable_file_sandbox = false
    // max_stale = "87600h"
    // block_query_wait = "5m"

    wait {
      // min = "5s"
      // max = "4m"
    }

    wait_bounds{
      // min = "5s"
      // max = "10s"
    }

    consul_retry {
      // attenpts = 0
      // backoff = "250ms"
      // max_backoff = "1m"
    }

    vault_retry {
      // attenpts = 0
      // backoff = "250ms"
      // max_backoff = "1m"
    }

    nomad_retry {
      // attenpts = 0
      // backoff = "250ms"
      // max_backoff = "1m"
    }
  }
}
