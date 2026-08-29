Done:
- Make helmfile create namespaces

Issues:
-
Context:
- Refer to values.yaml (mainly) for tasks like "enable x feature"

Maybe:
- Migrate gitless gitops to ensure that the cluster is up regardless of the git provider ( github,gitlab,etc)
in the case of a github blackout I dont have to patch manually URLs.
This applies to all CD runners incluiding dococd and maybe Argo
- Add coredns deployment manually
- Migrate from envoy-gw to Istio
- Make the domain secret used by Flux postbuild be provided by ESO ( Investigate bootstrapping problems, e.g cilium needs DOMAIN but cant get it because ESO is supposed to be alive blah blah)
Misc:
- https://craftycontrol.com/
- https://modrinth.com/mod/waylandcraft
Important Todo:
- Recheck all values.yaml refering to their charts in ArtifactHub and tune as needed ( especialyl for prometheus)
- How to manage ExternalSecrets with the split app/config dir ( where does it go) Refer to envoy
- Learn about Todo, and fix all of the values.yaml regarding prometheus since you can deploy it in different ways
or so it seems ( tl:dr check if the values.yaml for prometheus are actually for k8s prometheus or raw prometheus, in which case fix them for k8s prometheus)

Todo:
- Update Openbao URL in ESO provider.yaml
- Rewrite bootstrap.sh to Justfile
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
- Add both prometheus and HA compatibility to cert-manager later on
- Add prometheus compatibility with coredns
- Migrate from Cilium ARP to BGP announcements later on when I get rid off my shit ISP router