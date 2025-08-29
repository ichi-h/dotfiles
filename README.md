# dotfiles

## Hosts

| Server Name             | Responsibility                                              | Hardware                                                       | OS          | Software                                            | Kubernetes Role        |
| ----------------------- | ----------------------------------------------------------- | -------------------------------------------------------------- | ----------- | --------------------------------------------------- | ---------------------- |
| 常磐 (Tokiwa)           | Management and monitoring of the entire home server system. | Mini Computer (N97, RAM 16GB)                                  | NixOS       | Kubernetes Control Plane, Grafana, Loki, Prometheus | Control Plane + Worker |
| 花明 (Hanaakari)        | Hosting of applications provided by home servers.           | Mini Computer (N97, RAM 16GB)                                  | NixOS       | VaultWarden, Seafile, Navidrome                     | Worker                 |
| 夜もすがら (Yomosugara) | Development environment provision.                          | Desktop (Core i5 13400, RAM 32GB)                              | NixOS       | -                                                   | Worker                 |
| 藤袴 (Fujibakama)       | LLM hosting.                                                | Desktop (Core i5 12600K, RTX 5070, RAM 32GB)                   | NixOS (WSL) | Ollama                                              | Worker                 |
| 蓬 (Yomogi)             | Wake on LAN for home servers.                               | Raspberry Pi 4 Model B (Cortex-A72, RAM 4GB, External 1TB SSD) | NixOS       | Power Management Server                             | (Outside the cluster)  |

## Usage

Install Nix beforehand, and NixOS if necessary.

- [Nix Installer](https://github.com/DeterminateSystems/nix-installer)

### Setup

```sh
cd ~/
git clone https://github.com/ichi-h/dotfiles

cd dotfiles
cp .envrc.example .envrc
vim .envrc # edit this
direnv allow
```

### Nix and NixOS

```sh
cd nix

# For Linux (x86_64)
nix run nixpkgs#home-manager -- switch --flake .#linux-x86

# For Linux (arm64)
nix run nixpkgs#home-manager -- switch --flake .#linux-arm64

# For Darwin
nix run nixpkgs#home-manager -- switch --flake .#darwin

# Rebuild NixOS
sudo direnv allow # if you edited .envrc
sudo direnv exec . nixos-rebuild switch --flake .#(environment) --impure
```

### Why not use sops-nix, agenix and so on?

This project tolerates being **impure** and manages secret information using `.envrc`.  
When calling environment variables in Nix expressions, if an empty string is obtained, an exception is thrown. This allow the user to detect missing environment variable configurations in advance.

```nix
let
  getEnvWrapper = key:
    let
      value = builtins.getEnv key;
    in
      if value == "" then
        throw "`${key}` is empty, or you are running in pure mode."
      else
        value;
in
{
  secrets = {
    secret-1 = getEnvWrapper "SECRET_1";
    secret-2 = getEnvWrapper "SECRET_2";
    secret-3 = getEnvWrapper "SECRET_3";
    # ...
  };
}
```

Why have I adopted such a mechanism?

In NixOS, methods using sops-nix or agenix are standard approach to managing secret information.  
For example, when using sops-nix, you first include encrypted secret information in your commit. During `nixos-build` execution, sops-nix decrypts the encrypted files onto the host disk. This allows you to treat the path to the decrypted file as `config.sops.secrets.xxxxx.path` within Nix expressions.
If you want to use decrypted values on the host, write shell scripts like `export SECRET_VALUE=(cat ${config.sops.secrets.xxxxx.path})` in Nix expressions. By doing this, you can call them as environment variables on your shell.  
On the other hand, agenix retrieves encrypted information from a private repository and decrypts it. this allows you to handle the file paths of them on the disk using Nix expressions.
This way, flakes can ensure security while maintaining purity.

However, when choosing the above approach, what can be handled **in Nix expressions** is merely the **path of the decrypted file**, not the **decrypted value** itself. If you want to handle decrypted values in Nix expressions, you need to reveal those values in advance and ensure purity, but this defeats the purpose.

If we follow Bertrand Meyer's _external quality factors_ from _Object-Oriented Software Construction_, we can consider that purity in NixOS is established at the benefits such as _Reusability_, _Portability_, and _Repairability_, but at the cost of sacrificing _Extendibility_ and _Integrity_ (which he doesn't mention, but I understand this as one of the evaluation criteria for security).  
In other words, by making the OS declarative and pure, it becomes easy to reuse common configurations across hosts and migrate identical environments to different hardware with very high precision. Even if troubles occur, environment rollbacks can be performed easily. Wonderful!  
However, to ensure purity, even minor additions or changes to packages become cumbersome, and everything—including confidential information—must be explicitly declared in some form. While countermeasures are indeed provided and theoretically may not pose security problems, you'll surely agree this is more troublesome than **normal** management (of course, if we ignore the drawbacks of impurity).

Ultimately, these problems stem from the purity of NixOS and Nix expressions. So what should I do?  
I decided to do this. In other words, **I gave up on purity**.

Wait a minute! Wouldn't that eliminate the appeal of NixOS?  
Yes, that opinion is correct, but it doesn't mean that the appeal of NixOS would be **completely** lost.  
Certainly, if I allow impurity, I can't predict what might happen. However, if we minimize the impure portion and understand its scope precisely, it is possible to obtain the desired output with accuracy nearly indistinguishable from that of a reference-transparent function, with only a slight amount of care.  
To that end, this project aggregates impure methods within `/impurelibs` and allow the user can call it by `impurelibs.xxx`. This also includes the Nix expression for managing the secrets introduced at the beginning.  
Of course, it's not as robust as pure mechanisms, but at least there's only one place that needs careful management, and the calling side can understand that it's impure, making it a better management approach than letting things become lawless.
