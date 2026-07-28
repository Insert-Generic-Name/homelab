# Kubernetes homelabbing = Suffering #
Personal testing battlefield

## Planning ##


### Tools & Techs ###
---------------------------

- .gitattributes for YAML/JSON lang detection
- .vscode ( to track extensions/settings )
- Renovate
- yamllint
- gitleaks
- Woodpecker CI/Github Actions ( not decided )
- Talos + Talhelper
- External Secrets Operator + OpenBao/Infiscal/Bitwarden ( Not decided) *ESO LIVES OUTSIDE CLUSTER*
- Custom self-made Helm chart for templating ( avoid 4 manifests per service)

### Services ###
---------------------------

#### Not decided yet ####
---------------------------
- Actual Budget
- ntfy
- https://docs.stakater.com/reloader/latest/ For reloading certs/secrets in k8s,
though it seems like envoy-gw does this automatically.
- Feishin ( Navidrome frontend, desktop app it seems)
- Slskd/Soularr etc ( For soulseek)
- Home assistant
- MC Server
- Mozhi
- RSS Feeder ( or other tools like homepage/flux/bookmark manager)
So when there is a new release of a service I get a notification with a link
( flux only alerts if deployments fails)

#### Planned ####
---------------------------


##### Tools #####
---------------------------
- Authentik/Authelia
- Cilium (CNI/LB) + Hubble UI
- Envoy gateway (GAPIC)
- FluxCD
- Cert-Manager
- Rook-Ceph
- Tailscale

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