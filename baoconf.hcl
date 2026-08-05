# General Settings
ui            = true
cluster_addr  = "https://127.0.0.1:8201"
api_addr      = "https://127.0.0.1:8200"
cluster_name  = "openbao-internal"

# Listeners
listener "tcp" {
  address          = "127.0.0.1:8200"
  tls_disable      = true
  # get real certs!
  # tls_cert_file  = "/bao/certs/cert.pem"
  # tls_key_file   = "/bao/certs/key.pem"
}

# Storage
storage "raft" {
  path    = "/bao/data"
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

audit "file" "Persistant" {
  description = "Persistant logging via file path"
  options = {
    file_path = "/bao/logs"
    log_raw   = "false"
  }
}

# User lockout policies
user_lockout "all" {
  lockout_threshold     = "3"
  lockout_duration      = "24h"
  lockout_counter_reset = "24h"
}