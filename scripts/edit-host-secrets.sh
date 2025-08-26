nix-shell -p sops --run "SOPS_AGE_KEY_FILE='sops/age/$1.txt' sops hosts/$1/secrets.yaml"
