Done:
- Make helmfile create namespaces

Todo:
- Deploy Flux alert controller once observability stack is done
- Enable flux operator compatibility with prometheus
- Remove .vscode extensions ( terraform, ansible)
- Change Cilium operator replicas to 2 when on real hardware
- Enable Cilium compatibility with prometheus
- Change Envoy deployment replicas to 2 when on real hardware
- Get all of envoy CRDs working ( EnvoyProxy, Client Policy,etc)
- Reconfigure httpRoute for flux operator later on
- Switch from Tailscale operator to BGP load balancing later on
- Fine-tune Cilium ( values.yaml)
- Disable tailscale operator later on ( envoy.yaml)