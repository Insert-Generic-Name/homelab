# Important

>MAKE HTTPROUTE SEPARATE ( LIKE FLUX OPERATOR RBAC) AND REMOVE FROM HELMRELEASEE SO IN BOOTSTRAPPING ${DOMAIN} DOESNT EXIST, ( TO AVOID USING HELM OVERLAYS OR WEIRD STUFF)

Maybe use [Trivy](https://trivy.dev/) + kyverno for opsec

Use [flux operator docker image](https://fluxoperator.dev/docs/guides/cli/#:~:text=Container%20Image) as the image inside the CI pipeline since it packages everything necessary to get started, incluiding schema validators