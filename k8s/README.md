# Kubernetes

## Dev usage

```sh
nix develop # or write `use flake` in .envrc

# Apply manifests and Helmfile.
kubectl apply -f src/ --recursive
helmfile apply

# Download available Helm Chart values.
helm inspect values {helm_chart} > {file_name}.yaml
```
