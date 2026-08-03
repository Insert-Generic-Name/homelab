ui            = true
cluster_addr  = "https://127.0.0.1:8201"
api_addr      = "https://127.0.0.1:8200"

storage "raft" {
  path     = "./bao/data"
  node_id  = "main"
}

audit "file"  {
  options = {
    file_path  = "./bao/audit"
    log_raw    = "false"
  }
}

user_lockout "all" {
  lockout_threshold       = "3"
  lockout_duration        = "24h"
  lockout_counter_reset   = "24h"
}

listener "tcp" {
  address          = "100.78.66.64:8200"
  # tls_cert_file  = "/bao/certs/cert.pem"
  # tls_key_file   = "/bao/certs/key.pem"
}

telemetry {
  statsite_address = "127.0.0.1:8125"
  disable_hostname = true
}