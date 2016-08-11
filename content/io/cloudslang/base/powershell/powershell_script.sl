namespace: io.cloudslang.base.powershell

operation:
   name: powershell_script
   inputs:
   -  host:
         private: false
         sensitive: false
         required: true
   -  port:
         private: false
         sensitive: false
         required: false
   -  protocol:
         private: false
         sensitive: false
         required: false
   -  username:
         private: false
         sensitive: false
         required: false
   -  password:
         private: false
         sensitive: true
         required: false
   -  auth_type:
         private: false
         sensitive: false
         required: false
   -  authType:
         private: true
         default: ${get("auth_type", "")}
         sensitive: false
         required: false
   -  proxy_host:
         private: false
         sensitive: false
         required: false
   -  proxyHost:
         private: true
         default: ${get("proxy_host", "")}
         sensitive: false
         required: false
   -  proxy_port:
         private: false
         sensitive: false
         required: false
   -  proxyPort:
         private: true
         default: ${get("proxy_port", "")}
         sensitive: false
         required: false
   -  proxy_username:
         private: false
         sensitive: false
         required: false
   -  proxyUsername:
         private: true
         default: ${get("proxy_username", "")}
         sensitive: false
         required: false
   -  proxy_password:
         private: false
         sensitive: true
         required: false
   -  proxyPassword:
         private: true
         default: ${get("proxy_password", "")}
         sensitive: true
         required: false
   -  trust_all_roots:
         private: false
         sensitive: false
         required: false
   -  trustAllRoots:
         private: true
         default: ${get("trust_all_roots", "")}
         sensitive: false
         required: false
   -  x509hostname_verifier:
         private: false
         sensitive: false
         required: false
   -  x509HostnameVerifier:
         private: true
         default: ${get("x509hostname_verifier", "")}
         sensitive: false
         required: false
   -  trust_keystore:
         private: false
         sensitive: false
         required: false
   -  trustKeystore:
         private: true
         default: ${get("trust_keystore", "")}
         sensitive: false
         required: false
   -  trust_password:
         private: false
         sensitive: true
         required: false
   -  trustPassword:
         private: true
         default: ${get("trust_password", "")}
         sensitive: true
         required: false
   -  kerberos_conf_file:
         private: false
         sensitive: false
         required: false
   -  kerberosConfFile:
         private: true
         default: ${get("kerberos_conf_file", "")}
         sensitive: false
         required: false
   -  kerberos_login_conf_file:
         private: false
         sensitive: false
         required: false
   -  kerberosLoginConfFile:
         private: true
         default: ${get("kerberos_login_conf_file", "")}
         sensitive: false
         required: false
   -  kerberos_skip_port_for_lookup:
         private: false
         sensitive: false
         required: false
   -  kerberosSkipPortForLookup:
         private: true
         default: ${get("kerberos_skip_port_for_lookup", "")}
         sensitive: false
         required: false
   -  keystore:
         private: false
         sensitive: false
         required: false
   -  keystore_password:
         private: false
         sensitive: true
         required: false
   -  keystorePassword:
         private: true
         default: ${get("keystore_password", "")}
         sensitive: true
         required: false
   -  winrm_max_envelop_size:
         private: false
         sensitive: false
         required: false
   -  winrmMaxEnvelopSize:
         private: true
         default: ${get("winrm_max_envelop_size", "")}
         sensitive: false
         required: false
   -  script:
         private: false
         sensitive: false
         required: true
   -  winrm_locale:
         private: false
         sensitive: false
         required: false
   -  winrmLocale:
         private: true
         default: ${get("winrm_locale", "")}
         sensitive: false
         required: false
   -  operation_timeout:
         private: false
         sensitive: false
         required: false
   -  operationTimeout:
         private: true
         default: ${get("operation_timeout", "")}
         sensitive: false
         required: false
   java_action:
      method_name: execute
      class_name: io.cloudslang.content.actions.PowerShellScriptAction
   outputs:
   -  return_code: ${returnCode}
   -  return_result: ${returnResult}
   -  stderr: ${stderr}
   -  script_exit_code: ${scriptExitCode}
   -  exception: ${exception}
   results:
   -  SUCCESS: ${returnCode=='0'}
   -  FAILURE: ${returnCode=='-1'}
