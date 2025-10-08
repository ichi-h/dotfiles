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
    k8s-master-node-apitoken = getEnvWrapper "K8S_MASTER_NODE_APITOKEN";

    hashed-user-passwd-tokiwa = getEnvWrapper "HASHED_USER_PASSWD_TOKIWA";
    hashed-user-passwd-hanaakari = getEnvWrapper "HASHED_USER_PASSWD_HANAAKARI";
    hashed-user-passwd-yomogi = getEnvWrapper "HASHED_USER_PASSWD_YOMOGI";
    hashed-user-passwd-shiosai = getEnvWrapper "HASHED_USER_PASSWD_SHIOSAI";
    hashed-user-passwd-fujibakama = getEnvWrapper "HASHED_USER_PASSWD_FUJIBAKAMA";

    ip-address-tokiwa = {
      tailscale = getEnvWrapper "TAILSCALE_IP_ADDRESS_TOKIWA";
      private = getEnvWrapper "PRIVATE_IP_ADDRESS_TOKIWA";
    };
    ip-address-hanaakari = {
      tailscale = getEnvWrapper "TAILSCALE_IP_ADDRESS_HANAAKARI";
      private = getEnvWrapper "PRIVATE_IP_ADDRESS_HANAAKARI";
    };
    ip-address-yomogi = {
      tailscale = getEnvWrapper "TAILSCALE_IP_ADDRESS_YOMOGI";
      private = getEnvWrapper "PRIVATE_IP_ADDRESS_YOMOGI";
    };
    ip-address-shiosai = {
      tailscale = getEnvWrapper "TAILSCALE_IP_ADDRESS_SHIOSAI";
      private = getEnvWrapper "PRIVATE_IP_ADDRESS_SHIOSAI";
    };
    ip-address-fujibakama = {
      tailscale = getEnvWrapper "TAILSCALE_IP_ADDRESS_FUJIBAKAMA";
      private = getEnvWrapper "PRIVATE_IP_ADDRESS_FUJIBAKAMA";
    };

    mac-address-tokiwa = getEnvWrapper "MAC_ADDRESS_TOKIWA";
    mac-address-hanaakari = getEnvWrapper "MAC_ADDRESS_HANAAKARI";
    mac-address-yomogi = getEnvWrapper "MAC_ADDRESS_YOMOGI";
    mac-address-shiosai = getEnvWrapper "MAC_ADDRESS_SHIOSAI";
    mac-address-fujibakama = getEnvWrapper "MAC_ADDRESS_FUJIBAKAMA";
  };
}
