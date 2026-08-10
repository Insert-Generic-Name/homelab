# General Settings
ui            = true
cluster_addr  = "http://127.0.0.1:8201"
api_addr      = "http://0.0.0.0:8200"
cluster_name  = "openbao-external"

# Listeners
listener "tcp" {
  address          = "0.0.0.0:8200"
  tls_disable      = "true"
}

# Storage
storage "raft" {
  path    = "/openbao/raft"
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
    file_path = "/var/openbao/logs"
    log_raw   = "false"
  }
}

# User lockout policies
user_lockout "all" {
  lockout_threshold     = "3"
  lockout_duration      = "24h"
  lockout_counter_reset = "24h"
}
