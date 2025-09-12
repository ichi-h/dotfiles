kubectl label nodes hanaakari role=application

helmfile repos
helmfile -e prod sync
