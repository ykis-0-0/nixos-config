plugin "nomad-driver-podman" {
  // args = []

  config {
    // socket_path = "unix://run/user/<USER_ID>/podman/io.podman"
    // recover_stopped = true

    // disable_log_collection = false

    // client_http_timeout = "60s"

    gc {
      // container = true
    }

    volumes {
      // enabled      = true
      // selinuxlabel = "z"
    }
  }
}
