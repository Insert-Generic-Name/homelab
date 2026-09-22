# Stage 2

## Introduction
**Stage 2 is the responsible for bootstrapping the kubernetes platform**

## Pre-requesites

0. The operations must be executed on a machine deemed as trusted since secrets interact with the environment
1. Mise must be installed [and activated](https://mise.jdx.dev/getting-started.html#activate-mise) manually on the same machine in which the operations are beeing executed
2. All the necessary tools must be installed with mise CLI
3. Stage 1 must have been finished already and all nodes must be running kubernetes
4. OpenBao must be populated with key-value type secrets on the following path and with the following table:

Path: kubernetes/bootstrap

```
{
  "BAO_TOKEN": "",
  "DOMAIN": ""
}
```

5. OpenBao CLI must be authenticated and able to retrieve secrets
6. Kubectl must be able to communicate with the cluster

## Getting started

In order to get started, just run the following command:

```
$ just s2 deploy # Triggers Stage 2
```
You will be prompted to confirm if you want to run the stage
```
Ready to deploy Stage 2? [y|n]
```
To proceed, type "y" or "yes" inside the terminal


## Troubleshooting

Make **SURE** you have read properly the [Pre-requesites](#pre-requesites) section. By default the script will give "lazy" warnings and exit if it encounters any error, this document is the main source for troubleshooting

> If needed, edit the script manually and delete the /dev/null redirectors to see the issue.