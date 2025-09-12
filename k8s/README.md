# Kubernetes

## Dev usage

```sh
nix develop # or write `use flake` in .envrc

touch key.txt # edit secret key

# Create Kind cluster.
./scripts/create-kind-cluster.sh

# Apply Helmfiles.
helmfile -e dev apply

# Download available Helm Chart values.
helm inspect values {helm_chart} > {file_name}.yaml

# Encrypt and edit secrets.
helm secrets encrypt -i secrets/{environment}-secrets.yaml
helm secrets edit secrets/{environment}-secrets.yaml
```

## Prod usage

```sh
nix develop # or write `use flake` in .envrc

touch key.txt # edit secret key

# Deploy Helmfiles.
./deploy-prod.sh

# TODO: Create backup to S3.
```
