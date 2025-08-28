# dotfiles

## Hosts

| Server Name             | Responsibility                                              | Hardware                                                       | OS          | Software                                                                     | Kubernetes Role        |
| ----------------------- | ----------------------------------------------------------- | -------------------------------------------------------------- | ----------- | ---------------------------------------------------------------------------- | ---------------------- |
| 常磐 (Tokiwa)           | Management and monitoring of the entire home server system. | Mini Computer (N97, RAM 16GB)                                  | NixOS       | Kubernetes Control Plane, Grafana, Loki, Prometheus, Power Management Server | Control Plane + Worker |
| 花明 (Hanaakari)        | Hosting of applications provided by home servers.           | Mini Computer (N97, RAM 16GB)                                  | NixOS       | VaultWarden                                                                  | Worker                 |
| 蓬 (Yomogi)             | Storage provision.                                          | Raspberry Pi 4 Model B (Cortex-A72, RAM 4GB, External 1TB SSD) | NixOS       | Seafile, Navidrome                                                           | Worker                 |
| 夜もすがら (Yomosugara) | Development environment provision.                          | Desktop (Core i5 13400, RAM 32GB)                              | NixOS       | -                                                                            | Worker                 |
| 藤袴 (Fujibakama)       | LLM hosting.                                                | Desktop (Core i5 12600K, RTX 5070, RAM 32GB)                   | NixOS (WSL) | Ollama                                                                       | Worker                 |

## Usage

Install Nix in advance or use NixOS.

- [Nix Installer](https://github.com/DeterminateSystems/nix-installer)


```sh
cd ~/
git clone https://github.com/ichi-h/dotfiles

cd dotfiles
cp .envrc.example .envrc
vim .envrc # edit this
direnv allow

# For Linux (x86_64)
nix run nixpkgs#home-manager -- switch --flake .#linux-x86

# For Linux (arm64)
nix run nixpkgs#home-manager -- switch --flake .#linux-arm64

# For Darwin
nix run nixpkgs#home-manager -- switch --flake .#darwin

# Rebuild NixOS
sudo direnv allow; sudo direnv exec . nixos-rebuild switch --flake .#(environment) --impure
```

### Why not use sops-nix, agenix and so on?

This project tolerates being **impure** and manages secret information using `.envrc`.  
When calling environment variables in nix expressions, if an empty string is obtained, an exception is thrown, allowing us to detect missing environment variable configurations in advance.

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

As a general approach to managing secret information in NixOS, methods using sops-nix or agenix are available.  
For example, when using sops-nix, encrypted secret information is included in commits, and the encrypted files are decrypted to disk during `nixos-build`, making it possible to handle the paths of decrypted files in nix expressions as `config.sops.secrets.xxxxx.path`.  
If you want to use decrypted values on the host, you can manage shell scripts like `export SECRET_VALUE=(cat ${config.sops.secrets.xxxxx.path})` in nix expressions, allowing you to call them as environment variables.  
On the other hand, agenix retrieves encrypted information from a private repository, decrypts it, and handles the file paths of the extracted files on the disk using Nix expressions.
This way, flakes can ensure security while maintaining purity.

However, when choosing the above approach, what can be handled **in nix expressions** is merely the **path of the decrypted file**, not the **decrypted value** itself. If you want to handle decrypted values in nix expressions, you need to reveal those values in advance and ensure purity, which defeats the purpose.

Following the _external quality factors_ from Bertrand Meyer's "Object-Oriented Software Construction," purity in NixOS is established at the expense of benefits such as _Reusability_, _Portability_, and _Repairability_, as well as _Extendibility_ and _Integrity_ (though he doesn't mention it, I understand this as one of the evaluation criteria for security).  
In other words, by making the OS declarative and pure, it becomes easy to reuse common configurations across hosts and migrate identical environments to different hardware with very high precision. Even if troubles occur, environment rollbacks can be performed easily. Wonderful!  
However, to ensure purity, even minor additions or changes to packages become cumbersome, and everything—including confidential information—must be explicitly declared in some form. While countermeasures are indeed provided and theoretically may not pose problems, you'll surely agree this is far more troublesome than **normal** management (of course, if we ignore the drawbacks of impurity).

Ultimately, these problems stem from the purity of NixOS and nix expressions. So what should I do?  
How about this? **Giving up purity.**

Wait a minute! Wouldn't that eliminate the appeal of NixOS?  
Yes, that opinion is correct. However, it doesn't mean that the appeal of NixOS would be **completely** lost.  
Certainly, if I allow impurity, I can't predict what might happen. So instead, this project consolidates impure mechanisms in `/impurelibs`.  
Of course, it's not as robust as pure mechanisms, but at least there's only one place that needs careful management, and the calling side can understand that it's impure, making it a better management approach than letting things become lawless.
