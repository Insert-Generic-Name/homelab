# Boostrapping pre-requesites #


## Common
- GNUPG and Docker must be installed manually on the same machine where Omni is beeing deployed
- OpenBao CLI must be authenticated and able to retrieve the secrets
- The script must be ran on a machine deemed as trusted since secrets interact with the environment

## Stage 1
- OpenBao must be populated with secrets already on the following locations and the following tables:

Path: omni/omni

{
  "CLOUDFLARE_API_TOKEN": "",
  "EMAIL": "",
  "GITHUB_CLIENT_ID": "",
  "GITHUB_CLIENT_SECRET": "",
  "OMNI_ACCOUNT_UUID": "",
  "OMNI_CLIENT_ID": "",
  "OMNI_CLIENT_SECRET": "",
  "OMNI_DOMAIN": ""
}

Path: kubernetes/bootstrap

{
  "BAO_TOKEN": "",
  "DOMAIN": ""
}

