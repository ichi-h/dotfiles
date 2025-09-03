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

## Permission issue with the /var/www/html/data directory in Nextcloud

This project persists data in /var/www/html/data, but Nextcloud changes the permissions of the /var/www/html/data directory to 770 during initialization. As a result, Kubernetes is unable to mount this directory.  
If you encounter this issue, you currently need to execute `kubectl exec -it {nextcloud-pod} -- chmod 755 /var/www/html/data` manually.
