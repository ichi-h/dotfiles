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
    hashed-user-passwd-tokiwa = getEnvWrapper "HASHED_USER_PASSWD_TOKIWA";
    hashed-user-passwd-hanaakari = getEnvWrapper "HASHED_USER_PASSWD_HANAAKARI";
    hashed-user-passwd-yomogi = getEnvWrapper "HASHED_USER_PASSWD_YOMOGI";
    hashed-user-passwd-yomosugara = getEnvWrapper "HASHED_USER_PASSWD_YOMOSUGARA";
    hashed-user-passwd-fujibakama = getEnvWrapper "HASHED_USER_PASSWD_FUGIBAKAMA";

    ip-address-tokiwa = getEnvWrapper "IP_ADDRESS_TOKIWA";
    ip-address-hanaakari = getEnvWrapper "IP_ADDRESS_HANAAKARI";
    ip-address-yomogi = getEnvWrapper "IP_ADDRESS_YOMOGI";
    ip-address-yomosugara = getEnvWrapper "IP_ADDRESS_YOMOSUGARA";
    ip-address-fujibakama = getEnvWrapper "IP_ADDRESS_FUGIBAKAMA";

    mac-address-tokiwa = getEnvWrapper "MAC_ADDRESS_TOKIWA";
    mac-address-hanaakari = getEnvWrapper "MAC_ADDRESS_HANAAKARI";
    mac-address-yomogi = getEnvWrapper "MAC_ADDRESS_YOMOGI";
    mac-address-yomosugara = getEnvWrapper "MAC_ADDRESS_YOMOSUGARA";
    mac-address-fujibakama = getEnvWrapper "MAC_ADDRESS_FUGIBAKAMA";
  };
}
