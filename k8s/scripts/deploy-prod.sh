kubectl label nodes hanaakari role=application

helmfile -e prod sync
