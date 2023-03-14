server {
  // enabled = false # Decided per node
  bootstrap_expect = 1 # TODO provide more resiliency when possible
  // event_buffer_size = 100
  // authoritative_region = "" (local)
  rejoin_after_leave = false

  server_join {
    // retry_join = ${}
  }

  // encrypt = ""

  // job_max_priority = 100
  // job_default_priority = 50

  // num_schedulers = (# of cores)
  default_scheduler_config {
    memory_oversubscription_enabled = true
  }

  plan_rejection_tracker {
    enabled = true
    // node_threshold = 100
    // node_window = "5m"
  }

  search {
    // fuzzy_enabled   = true
    // limit_query     = 200
    // limit_results   = 1000
    // min_term_length = 5
  }

  node_gc_threshold = "72h"
  // acl_token_gc_threshold = "1h"
  // eval_gc_threshold = "1h"
  // batch_eval_gc_threshold = "24h" # "90m"
  // job_gc_interval = "1h" # "5m"
  // job_gc_threshold = "2h" # "4h"
  // deployment_gc_threshold = "1h"
  // csi_plugin_gc_threshold = "1h"
  // csi_volume_claim_gc_interval = "5m"
  // csi_volume_claim_gc_threshold = "1h"

  // min_heartbeat_ttl = "10s"
  // max_heartbeats_per_second = "50.0"
  // heartbeat_grace = "10s"
  // failover_heartbeat_ttl = "5m"

  // root_key_gc_interval = "10m"
  // root_key_gc_threshold = "1h"
  // root_key_rotation_threshold = "720h"

  raft_boltdb {
    // no_freelist_sync = false
  }
  // raft_protocol = 3
  // raft_multiplier = 1
  // raft_snapshot_threshold = 8192
  // raft_snapshot_interval = "120s"
  // raft_trailing_logs = 10240
}
