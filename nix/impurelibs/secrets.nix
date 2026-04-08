let
  getEnvWrapper = { key, default ? null }:
    let
      value = builtins.getEnv key;
    in
      if value == "" then
        if default != null then
          default
        else
          throw "`${key}` is empty, or you are running in pure mode."
      else
        value;
in
{
  secrets = {
    username = getEnvWrapper { key = "USERNAME"; default = "ichi"; };

    k8s-master-node-apitoken = getEnvWrapper { key = "K8S_MASTER_NODE_APITOKEN"; };

    hashed-user-passwd-tokiwa = getEnvWrapper { key = "HASHED_USER_PASSWD_TOKIWA"; };
    hashed-user-passwd-hanaakari = getEnvWrapper { key = "HASHED_USER_PASSWD_HANAAKARI"; };
    hashed-user-passwd-yomogi = getEnvWrapper { key = "HASHED_USER_PASSWD_YOMOGI"; };
    hashed-user-passwd-shiosai = getEnvWrapper { key = "HASHED_USER_PASSWD_SHIOSAI"; };
    hashed-user-passwd-fujibakama = getEnvWrapper { key = "HASHED_USER_PASSWD_FUJIBAKAMA"; };

    ip-address-tokiwa = {
      tailscale = getEnvWrapper { key = "TAILSCALE_IP_ADDRESS_TOKIWA"; };
      private = getEnvWrapper { key = "PRIVATE_IP_ADDRESS_TOKIWA"; };
    };
    ip-address-hanaakari = {
      tailscale = getEnvWrapper { key = "TAILSCALE_IP_ADDRESS_HANAAKARI"; };
      private = getEnvWrapper { key = "PRIVATE_IP_ADDRESS_HANAAKARI"; };
    };
    ip-address-yomogi = {
      tailscale = getEnvWrapper { key = "TAILSCALE_IP_ADDRESS_YOMOGI"; };
      private = getEnvWrapper { key = "PRIVATE_IP_ADDRESS_YOMOGI"; };
    };
    ip-address-shiosai = {
      tailscale = getEnvWrapper { key = "TAILSCALE_IP_ADDRESS_SHIOSAI"; };
      private = getEnvWrapper { key = "PRIVATE_IP_ADDRESS_SHIOSAI"; };
    };
    ip-address-fujibakama = {
      tailscale = getEnvWrapper { key = "TAILSCALE_IP_ADDRESS_FUJIBAKAMA"; };
      private = getEnvWrapper { key = "PRIVATE_IP_ADDRESS_FUJIBAKAMA"; };
    };

    mac-address-tokiwa = getEnvWrapper { key = "MAC_ADDRESS_TOKIWA"; };
    mac-address-hanaakari = getEnvWrapper { key = "MAC_ADDRESS_HANAAKARI"; };
    mac-address-yomogi = getEnvWrapper { key = "MAC_ADDRESS_YOMOGI"; };
    mac-address-shiosai = getEnvWrapper { key = "MAC_ADDRESS_SHIOSAI"; };
    mac-address-fujibakama = getEnvWrapper { key = "MAC_ADDRESS_FUJIBAKAMA"; };

    notify-webhook-url = getEnvWrapper { key = "NOTIFY_WEBHOOK_URL"; default = ""; };
  };
}
