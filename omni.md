Ok so
1- Download omniconfig and configure it # https://docs.siderolabs.com/omni/getting-started/install-and-configure-omnictl
2- Create cluster # https://docs.siderolabs.com/omni/getting-started/getting-started

1-
Download omni config manually
then run
mv omniconfig.yaml ~/.talos/omni/config

❯ omnictl config contexts
CURRENT   NAME      URL
*         default   https://omni.external.insert-generic-domain.com/
( Use this for failsafe)

omnictl get clusters ( authenticate via browser, could use for failcheck too)

2-
Create ISO manually :kek: ( To avoid mental overhead)
Download it and flash it manually

Create machineclass.yaml ( For dynamic provision instead of relying on UUID pasting)
omnictl apply -f machine-class.yaml