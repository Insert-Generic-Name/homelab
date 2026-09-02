# Kubernetes homelabbing = Suffering #
Personal testing battlefield

- Dont forget to run helmfile init to install needed plugins!
## Planning ##

### Services ###
---------------------------

#### Not decided yet ####
---------------------------
- Actual Budget
- Local git instance to get FluxCD webhooks without port forwarding ( mirrors my main instance or otherwise)
- ntfy
- https://docs.stakater.com/reloader/latest/ For reloading certs/secrets in k8s,
though it seems like envoy-gw does this automatically. ( Use it only for apps that arent served
by envoy, like authelia that sits in front of it )
- Feishin ( Navidrome frontend, desktop app it seems)
- Slskd/Soularr etc ( For soulseek)
- Home assistant
- MC Server
- Mozhi
- RSS Feeder ( or other tools like homepage/flux/bookmark manager)
So when there is a new release of a service I get a notification with a link
( flux only alerts if deployments fails)
- Make terraform bootstrap Openbao l0 + Talos l1 + Kubernetes l2  to avoid relying on external tools (*l=layer)

#### Planned ####
---------------------------
Misc:
Use https://dashboardicons.com/ for homepage

##### Tools #####
--------------------------
- Talos
- Authentik/Authelia
- Cilium (CNI/LB) + Hubble UI
- Envoy gateway (GAPIC)
- External Secrets Operator (OpenBao provider)
- FluxCD + Operator
- Cert-Manager
- Rook-Ceph
- Tailscale
- yamllint + gitleaks + .vscode + .gitattributes.
- Renovate
- Custom self-made Helm chart for templating ( avoid 4 manifests per service)


##### Main  #####
---------------------------

- Arrstack ( Sonarr + Radarr + Prowlarr + Recyclarr + SABnzbd + Hotio qbittorrent + Metube)
- Bentopdf
- Gamevault
- Grafana
- Homepage
- Immich
- Invidious
- Jellyfin
- Ludusavi
- Mealie
- Microbin
- n8n
- Navidrome
- Nextcloud
- Ollama
- Open Web UI
- OnlyOffice
- Openspeedtest
- Pi-hole
- Prometheus
- Paperless-ngx
- Scrutiny
- SearxNG
- Seer
- Uptime Kuma
- Vaultwarden
- Vikunja

##### Discarded #####
---------------------------

- Gitea/Gitlab ( Dumb idea self hosting your source of truth)
- Portainer ( Just let CD handle the deployment)
- age/sops ( Just use an ESO, its safer and more robust)
- Proxmox ( Will run k8s on bare metal to avoid latency and resource overhead)
- Terraform ( ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^)
- Ansible   (^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^)
- Gluetun ((for qbittorrent)) ( Discarded due to Hotio Qbittorrent beeing a better solution)
- Lidarr ( "non-mainstream" music lack, me-tube is a better suit for my needs)

###### Readded ######
