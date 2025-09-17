mkdir -p volumes/loki

mkdir -p volumes/prometheus/server
mkdir -p volumes/prometheus/alertmanager

mkdir -p volumes/vaultwarden

mkdir -p -m 770 volumes/shared/data
mkdir -p volumes/shared/config
mkdir -p volumes/shared/custom_apps
mkdir -p volumes/shared/themes

mkdir -p volumes/traefik

mkdir -p volumes/grafana

if ! kind get clusters | grep -q '^kind$'; then
  echo "Creating kind cluster..."
  kind create cluster --config kind-config.yaml
else
  echo "Kind cluster 'kind' already exists."
fi
