#   (c) Copyright 2020 EntIT Software LLC, a Micro Focus company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: This operation can be used to execute PowerShell scripts towards PowerShell Core hosts.
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
#! Configure WinRM to provide enough memory to the commands that you are going to run, e.g. 1024 MB:
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
#! 3. For information on how to use PowerShell Core with Linux target machines please see release notes of
#! io.cloudslang.base.ssh.ssh_command operation.
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
#! @input script: The PowerShell script that will be executed on the remote shell.
#! @input configuration_name: The name of the PSSessionConfiguration to use. This can be used to target specific versions
#!                            of PowerShell if the PSSessionConfiguration is properly configured on the target.
#!                            By default, after PSRemoting is enabled on the target, the configuration name for
#!                            PowerShell v5 or lower is 'microsoft.powershell', for PowerShell v6 is 'PowerShell.6',
#!                            for PowerShell v7 is 'PowerShell.7'.
#!                            Additional configurations can be created by the user on the target machines.
#!                            Valid values: any PSConfiguration that exists on the host.
#!                            Examples: 'microsoft.powershell', 'PowerShell.6', 'PowerShell.7'
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
  name: pwsh_script

  inputs:
    - host
    - port:
        required: false
    - protocol:
        default: 'https'
        required: false
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - script
    - configuration_name:
        required: false
    - configurationName:
        default: ${get("configuration_name", "")}
        required: false
        private: true
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        required: false
        private: true
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get("proxy_port", "")}
        required: false
        private: true
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get("proxy_username", "")}
        required: false
        private: true
    - proxy_password:
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get("proxy_password", "")}
        required: false
        private: true
        sensitive: true
    - trust_all_roots:
        default: 'false'
        required: false
    - trustAllRoots:
        default: ${get("trust_all_roots", "")}
        required: false
        private: true
    - x_509_hostname_verifier:
        default: 'strict'
        required: false
    - x509HostnameVerifier:
        default: ${get("x_509_hostname_verifier", "")}
        required: false
        private: true
    - trust_keystore:
        default: ''
        required: false
    - trustKeystore:
        default: ${get("trust_keystore", "")}
        required: false
        private: true
    - trust_password:
        default: 'changeit'
        required: false
        sensitive: true
    - trustPassword:
        default: ${get("trust_password", "")}
        required: false
        private: true
        sensitive: true
    - keystore:
        default: ''
        required: false
    - keystore_password:
        default: 'changeit'
        required: false
        sensitive: true
    - keystorePassword:
        default: ${get("keystore_password", "")}
        required: false
        private: true
        sensitive: true
    - winrm_max_envelop_size:
        default: '153600'
        required: false
    - winrmMaxEnvelopSize:
        default: ${get("winrm_max_envelop_size", "")}
        required: false
        private: true
    - winrm_locale:
        default: 'en-US'
        required: false
    - winrmLocale:
        default: ${get("winrm_locale", "")}
        required: false
        private: true
    - operation_timeout:
        default: '60'
        required: false
    - operationTimeout:
        default: ${get("operation_timeout", "")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-powershell:0.0.10'
    class_name: io.cloudslang.content.actions.PwshScriptAction
    method_name: execute

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - script_exit_code: ${get('scriptExitCode', '')}
    - stderr: ${get('stderr', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
