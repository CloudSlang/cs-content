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
#! @input port: optional - The port to use when connecting to the remote WinRM server.
#! @input protocol: optional - The protocol to use when connecting to the remote server.
#!                  Valid values are 'HTTP' and 'HTTPS'.
#!                  Default value is 'HTTPS'.
#! @input username: The username used to connect to the remote machine.
#! @input password: The password used to connect to the remote machine.
#! @input auth_type: optional - type of authentication used to execute the request on the target server
#!                   Valid: 'basic', 'form', 'springForm', 'digest', 'ntlm', 'kerberos', 'anonymous' (no authentication)
#!                   Default: 'basic'
#! @input proxy_host: optional - The proxy server used to access the remote host.
#! @input proxy_port: optional - The proxy server port.
#! @input proxy_username: optional - The username used when connecting to the proxy.
#! @input proxy_password: optional - The password used when connecting to the proxy.
#! @input trust_all_roots: optional - Specifies whether to enable weak security over SSL/TSL.
#!                         A certificate is trusted even if no trusted certification authority issued it.
#!                         Valid values : 'true' and 'false'.
#!                         Default value : 'false'.
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. The hostname
#!                                 verification system prevents communication with other hosts other than the ones you
#!                                 intended. This is done by checking that the hostname is in the subject alternative
#!                                 name extension of the certificate. This system is designed to ensure that, if an
#!                                 attacker(Man In The Middle) redirects traffic to his machine, the client will not
#!                                 accept the connection. If you set this input to "allow_all", this verification is
#!                                 ignored and you become vulnerable to security attacks. For the value
#!                                 "browser_compatible" the hostname verifier works the same way as Curl and Firefox.
#!                                 The hostname must match either the first CN, or any of the subject-alts. A wildcard
#!                                 can occur in the CN, and in any of the subject-alts. The only difference between
#!                                 "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with
#!                                 "browser_compatible" matches all subdomains, including "a.b.foo.com".
#!                                 From the security perspective, to provide protection against possible Man-In-The-Middle
#!                                 attacks, we strongly recommend to use "strict" option.
#!                                 Valid values are 'strict', 'browser_compatible', 'allow_all'.
#!                                 Default value is 'strict'.
#! @input kerberos_conf_file: A krb5.conf file with content similar to the one in the examples
#!                            (where you replace CONTOSO.COM with your domain and 'ad.contoso.com' with your kdc FQDN).
#!                            This configures the Kerberos mechanism required by the Java GSS-API methods.
#!                            Example: http://web.mit.edu/kerberos/krb5-1.4/krb5-1.4.4/doc/krb5-admin/krb5.conf.html
#! @input kerberos_login_conf_file: A login.conf file needed by the JAAS framework with the content similar to the one in examples
#!                                  Example: http://docs.oracle.com/javase/7/docs/jre/api/security/jaas/spec/com/sun/security/auth/module/Krb5LoginModule.html
#!                                  Examples: com.sun.security.jgss.initiate {com.sun.security.auth.module.Krb5LoginModule
#1                                            required principal=Administrator doNotPrompt=true useKeyTab=true
#!                                            keyTab="file:/C:/Users/Administrator.CONTOSO/krb5.keytab";};
#! @input kerberos_skip_port_for_lookup: Do not include port in the key distribution center database lookup.
#!                                       Default value: true
#!                                       Valid values: true, false
#! @input trust_keystore: optional - the pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: optional - the password associated with the Trusttore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input keystore: optional - the pathname of the Java KeyStore file.
#!                  You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trust_all_roots is 'true'
#!                  this input is ignored.
#!                  Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                  Format: Java KeyStore (JKS)
#! @input keystore_password: optional - the password associated with the KeyStore file. If trust_all_roots is false and
#!                           keystore is empty, keystore_password default will be supplied.
#!                           Default value: ''
#! @input winrm_max_envelop_size: The maximum size of a SOAP packet in bytes for all stream content.
#!                                 Default value is '153600'.
#! @input script: The PowerShell script that will be executed on the remote shell.
#! @input winrm_locale: The WinRM locale to use.
#!                     Default value is 'en-US'.
#! @input operation_timeout: Defines the OperationTimeout value in seconds to indicate that the clients expect a
#!                           response or a fault within the specified time.
#!                           Default value is '60'.
#!
#! @output return_code: '0' if the script succeeded or '-1' otherwise.
#! @output return_result: The scripts result.
#! @output stderr: The standard error output if any error occurred.
#! @output script_exit_code: The exitcode of the script.
#! @output exception: The return code of the script
#!
#! @result SUCCESS: If the script ran successfully with no error messages
#! @result FAILURE: If the script was invalid, the timeout was suppressed or an error occurred
#!!#
########################################################################################################################

namespace: io.cloudslang.base.powershell

operation:
   name: powershell_script

   inputs:
   -  host
   -  port:
         required: false
   -  protocol:
         required: false
         default: 'https'
   -  username:
         required: false
   -  password:
         sensitive: true
         required: false
   -  auth_type:
         required: false
         default: 'basic'
   -  authType:
         default: ${get("auth_type", "")}
         required: false
         private: true
   -  proxy_host:
         required: false
   -  proxyHost:
         default: ${get("proxy_host", "")}
         required: false
         private: true
   -  proxy_port:
         required: false
   -  proxyPort:
         default: ${get("proxy_port", "")}
         required: false
         private: true
   -  proxy_username:
         required: false
   -  proxyUsername:
         default: ${get("proxy_username", "")}
         required: false
         private: true
   -  proxy_password:
         required: false
         sensitive: true
   -  proxyPassword:
         default: ${get("proxy_password", "")}
         required: false
         private: true
         sensitive: true
   -  trust_all_roots:
         required: false
         default: 'false'
   -  trustAllRoots:
         default: ${get("trust_all_roots", "")}
         required: false
         private: true
   -  x_509_hostname_verifier:
         required: false
         default: 'strict'
   -  x509HostnameVerifier:
         default: ${get("x509hostname_verifier", "")}
         required: false
         private: true
   -  trust_keystore:
         required: false
   -  trustKeystore:
         default: ${get("trust_keystore", "")}
         required: false
         private: true
   -  trust_password:
         sensitive: true
         required: false
   -  trustPassword:
         default: ${get("trust_password", "")}
         required: false
         private: true
         sensitive: true
   -  kerberos_conf_file:
         required: false
   -  kerberosConfFile:
         default: ${get("kerberos_conf_file", "")}
         required: false
         private: true
   -  kerberos_login_conf_file:
         required: false
   -  kerberosLoginConfFile:
         default: ${get("kerberos_login_conf_file", "")}
         required: false
         private: true
   -  kerberos_skip_port_for_lookup:
         required: false
   -  kerberosSkipPortForLookup:
         default: ${get("kerberos_skip_port_for_lookup", "")}
         required: false
         private: true
   -  keystore:
         required: false
   -  keystore_password:
         sensitive: true
         default: 'changeit'
         required: false
   -  keystorePassword:
         default: ${get("keystore_password", "")}
         required: false
         private: true
         sensitive: true
   -  winrm_max_envelop_size:
         required: false
         default: '153600'
   -  winrmMaxEnvelopSize:
         default: ${get("winrm_max_envelop_size", "")}
         required: false
         private: true
   -  script
   -  winrm_locale:
         required: false
         default: 'en-US'
   -  winrmLocale:
         default: ${get("winrm_locale", "")}
         required: false
         private: true
   -  operation_timeout:
         required: false
         default: '60'
   -  operationTimeout:
         default: ${get("operation_timeout", "")}
         required: false
         private: true

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
