# Stage 1

**Stage 1 is the responsible for bootstrapping, configuring and deploying Omni, the platform used to manage our kubernetes nodes at the host level. To make things simple, Stage 1 divides**

>Note: Do **NOT** modify omni.asc. Omni stores the gpg key for decryption, so changing it requires recreating the omni db (deleting the docker volume).

## General  pre-requesites

0. The operations must be executed on a machine deemed as trusted since secrets interact with the environment
1. [GNUPG](https://gnupg.org/) and [Docker engine](https://docs.docker.com/engine/) must be installed manually on the same machine in which Omni is going to be deployed
2. Mise must be installed [and activated](https://mise.jdx.dev/getting-started.html#activate-mise) manually on the same machine in which the operations are beeing executed
3. All the necessary tools must be installed with mise CLI
4. OpenBao CLI must be authenticated and able to retrieve the secrets

### Step 1  requirements
1. OpenBao must be populated with key-value type secrets on the following locations and with the following tables:

Path: omni/omni

```
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
```
Path: kubernetes/bootstrap

```
{
  "BAO_TOKEN": "",
  "DOMAIN": ""
}
```
## Stage 1 | Step 2
Note that the Omni container must be running and operative before proceeding, the script will NOT warn about this!

- the omniconfig must be named "omniconfig" not "omniconfig.yaml" nor any other name