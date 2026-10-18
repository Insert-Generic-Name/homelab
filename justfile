set quiet
set no-exit-message
set default-script
set default-list
set shell := ['bash', '-euo', 'pipefail', '-c']
set script-interpreter := ['bash', '-euo', 'pipefail']

[doc('Omni bootstrapping & cluster configuration')]
mod s1 './omni/mod.just'
[doc('Kubernetes bootstrapping')]
mod s2 './kubernetes/bootstrap/mod.just'

[private]
log lvl msg *args:
    gum log -s -l "{{ lvl }}" "{{ msg }}" {{ args }}
