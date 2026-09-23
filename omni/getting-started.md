# Stage 1

## Introduction
**Stage 1 is the responsible for bootstrapping, configuring and deploying Omni, the platform used to manage kubernetes nodes at the host level. To keep everything simple, Stage 1 splits the deployment into 2 steps:**

* Step 1 (Bootstrap): Bootstraps and handles initial Omni configuration
* Step 2 (Deploy): Configures Omni for the kubernetes workload ( cluster settings)

>Note: Do **NOT** modify omni.asc. Omni stores the gpg key for decryption, so changing it requires recreating the omni db (deleting the docker volume).

## Pre-requesites

### General requirements
0. The operations must be executed on a machine deemed as trusted since secrets interact with the environment
1. Mise must be installed [and activated](https://mise.jdx.dev/getting-started.html#activate-mise) manually on the same machine in which the operations are beeing executed
2. All the necessary tools must be installed with mise CLI
3. This guide assumes that you are using DNS01 challenge with a Cloudflare domain.

### Step 1 (Bootstrap) requirements
0. [GNUPG](https://gnupg.org/) and [Docker engine](https://docs.docker.com/engine/) must be installed manually on the same machine in which Omni is going to be deployed
1. OpenBao must be populated with key-value type secrets on the following path and with the following table:

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

2. OpenBao CLI must be authenticated and able to retrieve secrets

### Step 2 (Deploy) requirements
0. Omni container must be ready before proceeding, the script will **NOT** warn about this!
1. The omniconfig must be named "omniconfig" not "omniconfig.yaml" nor similars.


## Getting started

In order to get started, just run the following commands:

```
$ just s1 bootstrap # Triggers Step 1
$ just s1 deploy    # Triggers step 2
```
You will be prompted to confirm if you want to run the stage
```
Ready to deploy Stage 1|Step: Bootstrap? [y|n]
```
To proceed, type "y" or "yes" inside the terminal


## Troubleshooting

Make **SURE** you have read properly the [Pre-requesites](#pre-requesites) section. By default the script will give "lazy" warnings and exit if it encounters any error, this document is the main source for troubleshooting

> If needed, edit the script manually and delete the /dev/null redirectors to see the issue.