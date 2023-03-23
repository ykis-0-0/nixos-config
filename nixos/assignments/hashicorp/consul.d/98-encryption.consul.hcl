# Only overrides TLS certificate CN
// server_name = null

tls {
  defaults {
    // ca_file = ""
    // ca_path = ""
    // cert_file = ""
    // key_file = ""

    // tls_min_version = "TLSv1_2"
    // tls_cipher_suites = null # for TLS <= 1.2, Default unknown

    // verify_incoming = false
    // verify_outgoing = false
  }

  grpc {
    # inherits defaults

    // use_auto_cert = false

    # verify_outgoing unapplicable
  }

  https {
    # inherits defaults
  }

  internal_rpc {
    # inherits defaults

    // verify_server_hostname = false
  }
}

auto_encrypt {
  allow_tls = true
}
