- Deploy Flux alert controller once observability stack is done
- Enable flux operator compatibility with prometheus
- Remove .vscode extensions ( terraform, ansible)
- Find a way to injecting manifests ( ./config) to a service ( like homepage which relies
on IaC git driven apps)
Current ideas:
1- Make chart be able to declare a volumeMount from a configMap
2- Make a kustomization.yaml create a configMap