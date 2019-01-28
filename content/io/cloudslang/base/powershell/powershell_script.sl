#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
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
#!  Notes:
#!  1. This operations uses the Windows Remote Management (WinRM) implementation for WS-Management standard to execute
#!  PowerShell scripts. This operations is designed to run on remote hosts that have PowerShell installed and configured.
#!
#!  The Windows Remote Management (WS-Management) service on the remote host may not be started by default.
#!  Start the service and change its Startup type to Automatic (Delayed Start) before proceeding with the next steps.
#!  On the remote host, open a Command Prompt using the Run as Administrator option and paste in the following lines:
#!    winrm quickconfig
#!    y
#! This command("winrm quickconfig") will start the WinRM service, and set the service startup type to auto-start.
#! Configure a listener for the ports that send and receive WS-Management protocol messages using either
#! HTTP or HTTPS on any IP address.
#!
#! Open the ports for HTTP(5985) and HTTPS(5986).
#! The winrm quickconfig command creates a firewall exception only for the current user profile.
#!
#! By default basic authentication is disabled in WinRM.
#! Enable it if you are going to use local accounts to access the remote host:
#!    winrm set winrm/config/service/Auth @{Basic="true"}
#! Configure WinRM to allow unencrypted SOAP messages:
#!    winrm set winrm/config/service @{AllowUnencrypted="true"}
#! Kerberos authentication type should be enabled by default on the winrm service.
#! If you are not going to use domain accounts to access the remoet host you can disable it:
#!	winrm set winrm/config/service/Auth @{Kerberos="false"}
#!Configure WinRM to provide enough memory to the commands that you are going to run, e.g. 1024 MB:
#!    winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1024"}
#! Manualy Enable the WinRM firewall exception if winrm quickconfig did not work:
#!    netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
#! Run this command to check your configurations:
#!    winrm get Winrm/config
#! Use the following command to enumerate the winrm configured listeners.
#! You should have one for http listening on 5985 and one for https listening on 5986:
#!	winrm enumerate winrm/config/listener
#! The defult ports for WinRM connections are 5985 for HTTP and 5986 for HTTPS protocols.
#! Use netstat -ano | findstr "5985" and netstat -ano | findstr "5986" to check if the ports are opened.
#!
#! 2. For HTTPS connection do the following:
#! Create a self signed certificate for the remote host.
#! Import the certificate in the client keystore and copy the certificate thumbrpint.
#! Create an HTTPS WinRM listener on the remote host with the thumbprint of the certificate you've just copied.
#!  winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname="HOSTNAME"; CertificateThumbprint="THUMBPRINT"}
#! Do a quickconfig for WinRM with HTTPS:
#!    winrm quickconfig -transport:https
#! Check the complete WinRM configurations and that the listeners have been configured with:
#!    winrm get winrm/config
#! 	winrm enumerate winrm/config/listener
#!
#! 3. Authenticating with domain accounts is possible through kerberos authentication type.
#! Kerberos configurations need to be made both on the client(OO), server(WSMAN) and on the Domain Controller if you
#! are going to use Windows domain accounts to access the remote host.
#! During setup, WinRM creates the local group WinRMRemoteWMIUsers__. WinRM then restricts remote access to any user
#! that is not a member of either the local administration group or the WinRMRemoteWMIUsers__ group.
#! The domain user needs to be a member of this group in order to access resources over WinRM.
#! For the execution of the operation with kerberos authentication you will need to create two configuration files:
#! "login.conf" which contains the principal name of the user and the location of the keytab file associated to that user
#! and "krb5.conf" file which contains the domain name and the kdc hostname.
#! First you need to create the keytab file for the user on the Domain Controller.
#! Open a command prompt and type the following command:
#!    ktpass ﻿/princ username@MYDOMAIN.COM /pass password /ptype KRB5_NT_PRINCIPAL /out username.keytab
#! (OPTIONAL) Now in order to test the keytab, you'll need a copy of kinit.
#! You can use the one from <OO_HOME>\java\bin\kinit.exe. You also need to setup your krb5.ini file and copy it under
#! c:\windows\krb5.ini (on Windows) and /etc/krb5.conf (on Linux).
#! The krb5.ini file content looks like:
#!    [libdefaults]
#!	               default_realm = CONTOSO.COM
#!	[realms]
#!	               CONTOSO.COM = {
#!	                              kdc = ad.contoso.com
#!	                              admin_server = ad.contoso.com
#!    where CONTOSO.COM is your domain name and ad.contoso.com is the fully qualified name of your
#!    KDC server(usually the domain controller).
#! Once you've got your Kerberos file setup, you can use kinit to test the keytab.
#! First, try to logon with your user account without using the keytab:
#!    kinit username@CONTOSO.COM
#!    - enter the password -
#! If that doesn't work, your krb5 file is wrong.  If it does work, now try the keytab file:
#!    kinit username@CONTOSO.COM -k -t username.keytab
#! Now you should successfully authenticate without being prompted for a password.  Success!
#! For the operation inputs kerberosConfFile and kerberosLoginConfFile we need to create the krb5.conf file and
#! login.conf respectively. The content of the krb5.conf file is exactly the same as the krb5.ini file mentioned above.
#! The login.conf file content looks like this:
#!    om.sun.security.jgss.initiate {
#!		com.sun.security.auth.module.Krb5LoginModule required principal=Administrator
#!		doNotPrompt=true
#!		useKeyTab=true
#!		keyTab="file:/C:/Users/Administrator.CONTOSO/krb5.keytab";
#!	};
#!    where Administrator is the principal name of the domain account used to authenticate and the keytab property
#!    contains the path to the keytab file created on the server with the ktpass command mentioned above.
#!
#! The username and password inputs no longer need to be provided when the kerberos configuration files are provided.
#!
#! The operation will request access to a Kerberos service principal name of the form WSMAN/HOST,
#! for which an SPN should be configured automatically when you configure WinRM for a remote host.
#! If that was not configured correctly, you will have configure the service principal names manually.
#! This can be achieved by invoking the setspn command, as an Administrator, on any host in the domain, as follows:
#!    setspn -A PROTOCOL/ADDRESS:PORT WINDOWS-HOST
#!    where:
#!    PROTOCOL is either WSMAN (default) or HTTP.
#!    ADDRESS is the address used to connect to the remote host,
#!    PORT (optional) is the port used to connect to the remote host (usually 5985 or 5986,
#!         only necessary if kerberosSkipPortForLookup has been set to false)
#!    WINDOWS-HOST is the short Windows hostname of the remote host.
#! Some other useful commands:
#!    List all service principal names configured for a domain user: setspn -L <user>
#!    List all service principal names configured for a specific host in the domain: setspn -L <hostname>
#!
#! @input host: The hostname or ip address of the remote host.
#! @input port: The port to use when connecting to the remote WinRM server.
#!              Optional
#! @input protocol: The protocol to use when connecting to the remote server.
#!                  Valid: 'http' or 'https'.
#!                  Default: 'https'
#!                  Optional
#! @input username: The username used to connect to the remote machine.
#!                  Optional
#! @input password: The password used to connect to the remote machine.
#!                  Optional
#! @input auth_type: Optional - type of authentication used to execute the request on the target server
#!                   Valid: 'basic', digest', 'ntlm', 'kerberos', 'anonymous' (no authentication)
#!                   Default: 'basic'
#! @input proxy_host: The proxy server used to access the remote host.
#!                    Optional
#! @input proxy_port: The proxy server port.
#!                    Optional
#! @input proxy_username: The username used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: The password used when connecting to the proxy.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL.
#!                         A certificate is trusted even if no trusted certification authority issued it.
#!                         Valid: 'true' or 'false'
#!                         Default: 'false'
#!                         Optional
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
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'.
#!                                 Default: 'strict'.
#!                                 Optional
#! @input kerberos_conf_file: A krb5.conf file with content similar to the one in the examples
#!                            (where you replace CONTOSO.COM with your domain and 'ad.contoso.com' with your kdc FQDN).
#!                            This configures the Kerberos mechanism required by the Java GSS-API methods.
#!                            Example: http://web.mit.edu/kerberos/krb5-1.4/krb5-1.4.4/doc/krb5-admin/krb5.conf.html
#!                            Optional
#! @input kerberos_login_conf_file: A login.conf file needed by the JAAS framework with the content similar to the one in examples
#!                                  Example: http://docs.oracle.com/javase/7/docs/jre/api/security/jaas/spec/com/sun/
#!                                           security/auth/module/Krb5LoginModule.html
#!                                  Examples: com.sun.security.jgss.initiate {com.sun.security.auth.module.Krb5LoginModule
#!                                            required principal=Administrator doNotPrompt=true useKeyTab=true
#!                                            keyTab="file:/C:/Users/Administrator.CONTOSO/krb5.keytab";};
#!                                  Optional
#! @input kerberos_skip_port_for_lookup: Do not include port in the key distribution center database lookup.
#!                                       Valid: 'true' or 'false'
#!                                       Default: 'true'
#!                                       Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Default value: 'JAVA_HOME/java/lib/security/cacerts'
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Default value: 'changeit'
#!                        Optional
#! @input keystore: The pathname of the Java KeyStore file.
#!                  You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trust_all_roots is 'true'
#!                  this input is ignored.
#!                  Format: Java KeyStore (JKS)
#!                  Default value: 'JAVA_HOME/java/lib/security/cacerts'
#!                  Optional
#! @input keystore_password: The password associated with the KeyStore file. If trust_all_roots is false and
#!                           keystore is empty, keystore_password default will be supplied.
#!                           Default value: 'changeit'
#!                           Optional
#! @input winrm_max_envelop_size: The maximum size of a SOAP packet in bytes for all stream content.
#!                                Default: '153600'
#!                                Optional
#! @input script: The PowerShell script that will be executed on the remote shell.
#! @input winrm_locale: The WinRM locale to use.
#!                      Default: 'en-US'
#!                      Optional
#! @input operation_timeout: Defines the operation_timeout value in seconds to indicate that the clients expect a
#!                           response or a fault within the specified time.
#!                           Default: '60'
#!
#! @output return_result: The scripts result.
#! @output return_code: '0' if the script succeeded or '-1' otherwise.
#! @output stderr: The standard error output if any error occurred.
#! @output script_exit_code: The exit code of the script.
#! @output exception: The return code of the script.
#!
#! @result SUCCESS: If the script ran successfully with no error messages.
#! @result FAILURE: If the script was invalid, the timeout was suppressed or an error occurred.
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
         default: 'https'
         required: false
   -  username:
         required: false
   -  password:
         required: false
         sensitive: true
   -  auth_type:
         default: 'basic'
         required: false
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
         default: 'false'
         required: false
   -  trustAllRoots:
         default: ${get("trust_all_roots", "")}
         required: false
         private: true
   -  x_509_hostname_verifier:
         default: 'strict'
         required: false
   -  x509HostnameVerifier:
         default: ${get("x_509_hostname_verifier", "")}
         required: false
         private: true
   -  trust_keystore:
         default: ''
         required: false
   -  trustKeystore:
         default: ${get("trust_keystore", "")}
         required: false
         private: true
   -  trust_password:
         default: 'changeit'
         required: false
         sensitive: true
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
         default: ''
         required: false
   -  keystore_password:
         default: 'changeit'
         required: false
         sensitive: true
   -  keystorePassword:
         default: ${get("keystore_password", "")}
         required: false
         private: true
         sensitive: true
   -  winrm_max_envelop_size:
         default: '153600'
         required: false
   -  winrmMaxEnvelopSize:
         default: ${get("winrm_max_envelop_size", "")}
         required: false
         private: true
   -  script
   -  winrm_locale:
         default: 'en-US'
         required: false
   -  winrmLocale:
         default: ${get("winrm_locale", "")}
         required: false
         private: true
   -  operation_timeout:
         default: '60'
         required: false
   -  operationTimeout:
         default: ${get("operation_timeout", "")}
         required: false
         private: true

   java_action:
      gav: 'io.cloudslang.content:cs-powershell:0.0.7'
      class_name: io.cloudslang.content.actions.PowerShellScriptAction
      method_name: execute

   outputs:
   -  return_result: ${get('returnResult', '')}
   -  return_code: ${get('returnCode', '')}
   -  script_exit_code: ${get('scriptExitCode', '')}
   -  stderr: ${get('stderr', '')}
   -  exception: ${get('exception', '')}

   results:
   -  SUCCESS: ${returnCode == '0'}
   -  FAILURE
