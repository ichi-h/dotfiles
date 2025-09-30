kubectl label nodes tokiwa role=application
kubectl label nodes hanaakari role=application
kubectl label nodes hanaakari proxy=true

helmfile repos
helmfile -e prod sync
