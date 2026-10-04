# Important

>MAKE HTTPROUTE SEPARATE ( LIKE FLUX OPERATOR RBAC) AND REMOVE FROM HELMRELEASEE SO IN BOOTSTRAPPING ${DOMAIN} DOESNT EXIST, ( TO AVOID USING HELM OVERLAYS OR WEIRD STUFF)

Maybe use [Trivy](https://trivy.dev/) + kyverno for opsec

Use [flux operator docker image](https://fluxoperator.dev/docs/guides/cli/#:~:text=Container%20Image) as the image inside the CI pipeline since it packages everything necessary to get started, incluiding schema validators

https://oneuptime.com/blog/post/2026-01-17-helm-schema-validation-values/view#validate-during-development
Maybe use this for validating schemas inside helmreleases or maybe add IDE integration

- Maybe build a docker image ( Dockerfile) that contains every necesssary tool that I need
so I dont need to use diferent images for each task and can run the pipeline on the same single step
without needing to rebuild steps

<<- if hasPrefix "oci://" inputs.source.url >>
test

Add excalidraw, bentopdf and anki to the list

add a mise task to run local CI seamlessly ( should run linters only not the full pipeline)