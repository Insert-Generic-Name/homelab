# General Settings
ui            = true
cluster_addr  = "http://0.0.0.0:8201"
api_addr      = "http://0.0.0.0:8200"
cluster_name  = "openbao"

# Listeners
listener "tcp" {
  address          = "0.0.0.0:8200"
  # Use default signed certs that get installed ( atleast on debian)
  tls_cert_file = "/openbao/tls/tls.crt"
  tls_key_file  = "/openbao/tls/tls.key"
}

# Storage
storage "raft" {
  path    = "/openbao/data"
  node_id = "main"
}

# Auditors
audit "file" "Live" {
  description = "Live logging via stdout"
  options {
    file_path = "stdout"
    log_raw   = "false"
  }
}

audit "file" "Persistent" {
  description = "Persistent logging via file path"
  options = {
    file_path = "/openbao/audit"
    log_raw   = "false"
  }
}

# User lockout policies
user_lockout "all" {
  lockout_threshold     = "3"
  lockout_duration      = "24h"
  lockout_counter_reset = "24h"
}

