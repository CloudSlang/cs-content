#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Executes a PowerShell script on a remote host.
#!
#! @input host: The hostname or ip address of the remote host.
#! @input port: The port to use when connecting to the remote WinRM server.
#! @input protocol: The protocol to use when connecting to the remote server.
#!                  Valid values are 'HTTP' and 'HTTPS'.
#!                  Default value is 'HTTPS'.
#! @input username: The username used to connect to the remote machine.
#! @input password: The password used to connect to the remote machine.
#! @input proxyHost: The proxy server used to access the remote host.
#! @input proxyPort: The proxy server port.
#! @input proxyUsername: The username used when connecting to the proxy.
#! @input proxyPassword: The password used when connecting to the proxy.
#! @input trustAllRoots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it.
#!                       Default value is 'false'.
#!                       Valid values are 'true' and 'false'.
#! @input x509HostnameVerifier: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the
#!                              X.509 certificate. The hostname verification system prevents communication with other hosts other than the ones you intended.
#!                              This is done by checking that the hostname is in the subject alternative name extension of the certificate. This system is
#!                              designed to ensure that, if an attacker(Man In The Middle) redirects traffic to his machine, the client will not accept the
#!                              connection. If you set this input to "allow_all", this verification is ignored and you become vulnerable to security attacks.
#!                              For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match
#!                              either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only
#!                              difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches
#!                              all subdomains, including "a.b.foo.com". From the security perspective, to provide protection against possible Man-In-The-Middle
#!                              attacks, we strongly recommend to use "strict" option.
#!                              Valid values are 'strict', 'browser_compatible', 'allow_all'.
#!                              Default value is 'strict'.
#! @input trustKeystore: The pathname of the Java TrustStore file. This contains certificates from other parties that you expect to communicate with, or from
#!                       Certificate Authorities that you trust to identify other parties.  If the protocol selected is not 'https' or if trustAllRoots
#!                       is 'true' this input is ignored.
#!                       Format of the keystore is Java KeyStore (JKS).
#! @input trustPassword: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystore is empty, trustPassword default will be supplied.
#!                       Default value is 'changeit'.
#! @input keystore: The pathname of the Java KeyStore file. You only need this if the server requires client authentication. If the protocol selected is not
#!                  'https' or if trustAllRoots is 'true' this input is ignored.
#!                  Format of the keystore is Java KeyStore (JKS).
#! @input keystorePassword: The password associated with the KeyStore file. If trustAllRoots is false and keystore is empty, keystorePassword default will be supplied.
#!                          Default value is 'changeit'.
#! @input maxEnvelopeSize: The maximum size of a SOAP packet in bytes for all stream content.
#!                         Default value is '153600'.
#! @input script: The PowerShell script that will be executed on the remote shell.
#! @input winrmLocale: The WinRM locale to use.
#!                     Default value is 'en-US'.
#! @input operationTimeout: Defines the OperationTimeout value in seconds to indicate that the clients expect a response or a fault within the specified time.
#!                          Default value is '60'.
#!
#! @output return_code: 0 if the script succeeded or -1 otherwise.
#! @output return_result: The scripts result.
#! @output stderr: The standard error output if any error occurred.
#! @output script_exit_code: The exitcode of the script.
#! @output exception: The return code of the script
#!
#! @result SUCCESS: If the script ran successfully with no error messages
#! @result FAILURE: If the script was invalid, the timeout was suppressed or an error occurred
#!!#
########################################################################################################################

namespace: io.cloudslang.base.scripts

operation:
   name: powershell_script
   inputs:
   -  host:
         required: true
   -  port:
         required: false
   -  protocol:
         required: false
   -  username:
         required: false
   -  password:
         sensitive: true
         required: false
   -  auth_type:
         required: false
   -  authType:
         private: true
         default: ${get("auth_type", "")}
         required: false
   -  proxy_host:
         required: false
   -  proxyHost:
         private: true
         default: ${get("proxy_host", "")}
         required: false
   -  proxy_port:
         required: false
   -  proxyPort:
         private: true
         default: ${get("proxy_port", "")}
         required: false
   -  proxy_username:
         required: false
   -  proxyUsername:
         private: true
         default: ${get("proxy_username", "")}
         required: false
   -  proxy_password:
         sensitive: true
         required: false
   -  proxyPassword:
         private: true
         default: ${get("proxy_password", "")}
         sensitive: true
         required: false
   -  trust_all_roots:
         required: false
   -  trustAllRoots:
         private: true
         default: ${get("trust_all_roots", "")}
         required: false
   -  x509hostname_verifier:
         required: false
   -  x509HostnameVerifier:
         private: true
         default: ${get("x509hostname_verifier", "")}
         required: false
   -  trust_keystore:
         required: false
   -  trustKeystore:
         private: true
         default: ${get("trust_keystore", "")}
         required: false
   -  trust_password:
         sensitive: true
         required: false
   -  trustPassword:
         private: true
         default: ${get("trust_password", "")}
         sensitive: true
         required: false
   -  kerberos_conf_file:
         required: false
   -  kerberosConfFile:
         private: true
         default: ${get("kerberos_conf_file", "")}
         required: false
   -  kerberos_login_conf_file:
         required: false
   -  kerberosLoginConfFile:
         private: true
         default: ${get("kerberos_login_conf_file", "")}
         required: false
   -  kerberos_skip_port_for_lookup:
         required: false
   -  kerberosSkipPortForLookup:
         private: true
         default: ${get("kerberos_skip_port_for_lookup", "")}
         required: false
   -  keystore:
         required: false
   -  keystore_password:
         sensitive: true
         required: false
   -  keystorePassword:
         private: true
         default: ${get("keystore_password", "")}
         sensitive: true
         required: false
   -  winrm_max_envelop_size:
         required: false
   -  winrmMaxEnvelopSize:
         private: true
         default: ${get("winrm_max_envelop_size", "")}
         required: false
   -  script:
         required: true
   -  winrm_locale:
         required: false
   -  winrmLocale:
         private: true
         default: ${get("winrm_locale", "")}
         required: false
   -  operation_timeout:
         required: false
   -  operationTimeout:
         private: true
         default: ${get("operation_timeout", "")}
         required: false
   java_action:
      gav: 'io.cloudslang.content:cs-powershell:0.0.3'
      method_name: execute
      class_name: io.cloudslang.content.actions.PowerShellScriptAction
   outputs:
   -  return_code: ${returnCode}
   -  return_result: ${returnResult}
   -  stderr: ${stderr}
   -  script_exit_code: ${scriptExitCode}
   -  exception: ${exception}
   results:
   -  SUCCESS: ${returnCode == '0'}
   -  FAILURE
