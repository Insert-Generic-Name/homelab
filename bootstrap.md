# Boostrapping pre-requesites #

Notes:
Do not change omni.asc. The omni db stores the gpg key for decryption, so changing it requires recreating the db.

## Common
1- GNUPG and Docker must be installed manually on the same machine where Omni is beeing deployed
3- OpenBao CLI must be authenticated and able to retrieve the secrets
0- The script must be ran on a machine deemed as trusted since secrets interact with the environment
2- Mise must be installed **and activated** Run mise install and hook it to your shell
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

## Stage 1 | Step 2
Note that the Omni container must be running and operative before proceeding, the script will NOT warn about this!

- the omniconfig must be named "omniconfig" not "omniconfig.yaml" nor any other name