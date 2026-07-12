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
- SABnzbd/Others ( Usenet downloader)
- Actual Budget
- ntfy
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
- Rook-Ceph
- Tailscale

##### Main  #####
---------------------------

- Arrstack ( Sonarr + Radarr + Prowlarr + Lidarr + Recyclarr )
- Bentopdf
- Gamevault
- Grafana
- Homepage
- Immich
- Invidious
- Jellyfin
- Ludasavi
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
- Hotio Qbitorrent ( for VPN support)
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
