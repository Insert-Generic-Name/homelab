set quiet
set no-exit-message
set default-script
set default-list
set shell := ['bash', '-euo', 'pipefail', '-c']
set script-interpreter := ['bash', '-euo', 'pipefail']

mod s1 './omni/mod.just'
mod s2 './kubernetes/bootstrap/mod.just'
