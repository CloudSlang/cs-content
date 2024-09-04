#   Copyright 2024 Open Text
#   This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: This operation executes CMD or PowerShell commands, on a remote Windows server, using the  WinRM protocol.
#!
#! Notes:
#! 1. This operations uses the Windows Remote Management (WinRM) implementation for WS-Management standard to execute CMD or PowerShell commands. This operations is designed to run PowerShell on remote hosts that have PowerShell installed and configured.
#! The Windows Remote Management (WS-Management) service on the remote host may not be started by default. Start the service and change its Startup type to Automatic (Delayed Start) before proceeding with the next steps.
#! On the remote host, open a Command Prompt using the Run as Administrator option and paste in the following lines:
#!     winrm quickconfig
#!     y
#! This command("winrm quickconfig") will start the WinRM service, and set the service startup type to auto-start. Configure a listener for the ports that send and receive WS-Management protocol messages using either HTTP or HTTPS on any IP address.
#! Open the ports for HTTP(5985) and HTTPS(5986). The winrm quickconfig command creates a firewall exception only for the current user profile.
#!
#! By default basic authentication is disabled in WinRM. Enable it if you are going to use local accounts to access the remote host:
#!     winrm set winrm/config/service/Auth @{Basic="true"}
#! Configure WinRM to allow unencrypted SOAP messages:
#!     winrm set winrm/config/service @{AllowUnencrypted="true"}
#! Kerberos authentication type should be enabled by default on the WinRM service. If you are not going to use domain accounts to access the remote host you can disable it:
#!     winrm set winrm/config/service/Auth @{Kerberos="false"}
#! Configure WinRM to provide enough memory to the commands that you are going to run, e.g. 1024 MB:
#!     winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1024"}
#! Manualy Enable the WinRM firewall exception if winrm quickconfig did not work:
#!     netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
#! Run this command to check your configurations:
#!     winrm get Winrm/config
#! Use the following command to enumerate the WinRM configured listeners. You should have one for http listening on 5985 and one for https listening on 5986:
#!     winrm enumerate winrm/config/listener
#! The default ports for WinRM connections are 5985 for HTTP and 5986 for HTTPS protocols. Use netstat -ano | findstr "5985" and netstat -ano | findstr "5986" to check if the ports are opened.
#!
#! 2. For HTTPS connection do the following:
#! Create a self signed certificate for the remote host and copy the thumbprint of the certificate.
#!     New-SelfSignedCertificate -DnsName "DnsName" -CertStoreLocation "cert:\LocalMachine\My"
#! Create an HTTPS WinRM listener on the remote host with the thumbprint of certificate you've just copied.
#!     winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname="HOSTNAME"; CertificateThumbprint="THUMBPRINT"; Port="5986"}
#! Export the certificate on the client and add it to the truststore.
#! Do a quickconfig for WinRM with HTTPS:
#!     winrm quickconfig -transport:https
#! Check the complete WinRM configurations and that the listeners have been configured with:
#!     winrm get winrm/config
#!     winrm enumerate winrm/config/listener
#!
#! 3. Basic authentication requires valid certificates for Https connection even if trust_all_roots is set to true.
#!
#! 4. Authenticating with domain accounts is possible through kerberos authentication type.
#! The bellow configurations are not needed if a krb5.conf is given to the input kerberos_conf_file and request_new_kerberos_ticket is "true".
#!
#! Kerberos configurations need to be made both on the client(OO), server(WSMAN) and on the Domain Controller if you are going to use Windows domain accounts to access the remote host.
#! For the execution of the operation with kerberos authentication you will need to create two configuration files: "login.conf" which contains the principal name of the user and the location of the keytab file associated to that user and "krb5.conf" file which contains the domain name and the kdc hostname.
#! First you need to create the keytab file for the user on the Domain Controller. Open a command prompt and type the following command:
#!   ktpass /princ username@CONTOSO.COM /pass password /ptype KRB5_NT_PRINCIPAL /out username.keytab
#!(OPTIONAL) Now in order to test the keytab, you'll need a copy of kinit. You can use the one from <OO_HOME>\java\bin\kinit.exe. You also need to setup your krb5.ini file and copy it under c:\windows\krb5.ini (on Windows) and /etc/krb5.conf (on Linux).
#!The krb5.ini file content looks like:
#!    [libdefaults]
#!	       default_realm = CONTOSO.COM
#!    [realms]
#!	       CONTOSO.COM = {
#!	            kdc = ad.contoso.com
#!	            admin_server = ad.contoso.com
#!         }
#!    where CONTOSO.COM is your domain name and ad.contoso.com is the fully qualified name of your KDC server(usually the domain controller).
#!Once you've got your Kerberos file setup, you can use kinit to test the keytab.  First, try to logon with your user account without using the keytab:
#!    kinit username@CONTOSO.COM
#!    - enter the password -
#!If that doesn't work, your krb5 file is wrong.  If it does work, now try the keytab file:
#!    kinit username@CONTOSO.COM -k -t username.keytab
#!Now you should successfully authenticate without being prompted for a password.  Success!
#!For the operation inputs kerberosConfFile and kerberosLoginConfFile we need to create the krb5.conf file and login.conf respectively. The content of the krb5.conf file is exactly the same as the krb5.ini file mentioned above.
#!The login.conf file content looks like this:
#!    com.sun.security.jgss.initiate {
#!		com.sun.security.auth.module.Krb5LoginModule required principal=Administrator
#!		doNotPrompt=true
#!		useKeyTab=true
#!		keyTab="file:/C:/Users/Administrator.CONTOSO/krb5.keytab";
#!	};
#!   where Administrator is the principal name of the domain account used to authenticate and the keytab property contains the path to the keytab file created on the server with the ktpass command mentioned above.
#!
#!The username and password inputs no longer need to be provided when the kerberos configuration files are provided.
#!
#!    The operation will request access to a Kerberos service principal name of the form WSMAN/HOST, for which an SPN should be configured automatically when you configure WinRM for a remote host.
#!If that was not configured correctly, you will have configure the service principal names manually. This can be achieved by invoking the setspn command, as an Administrator, on any host in the domain, as follows:
#!setspn -A PROTOCOL/ADDRESS:PORT WINDOWS-HOST
#!where:
#!PROTOCOL is either WSMAN (default) or HTTP.
#!ADDRESS is the address used to connect to the remote host,
#!PORT (optional) is the port used to connect to the remote host
#!WINDOWS-HOST is the short Windows hostname of the remote host.
#!Some other useful commands:
#!List all service principal names configured for a domain user: setspn -L <user>
#!List all service principal names configured for a specific host in the domain: setspn -L <hostname>
#!
#!5. In case the remote host on which the powershell script is being executed is running WinRM v3.0 (Windows Server 2008 SP2, Windows 7 SP1, Windows Server 2008R2 SP1, Windows 8 or Windows Server 2012) you might run into this issue: https://support.microsoft.com/en-us/kb/2842230
#!The issue occurs because the Windows Remote Management (WinRM) service does not use the customized value of the MaxMemoryPerShellMB quota. Instead, the WinRM service uses the default value, which is 150 MB. There's a hotfix available in the mentioned link.
#!
#! @input host: The hostname or IP address of the target host.
#! @input domain: The domain of the target host.
#! @input port: The port number used to connect to the host. The default value for this input dependents on the protocol
#!              input. The default values are 5985 for Http and 5986 for Https.
#!              Default value: 5986
#!              Optional
#! @input protocol: Specifies what protocol is used to execute commands on the remote host.
#!                  Valid values: http, https
#!                  Default value: https
#!                  Optional
#! @input username: The username to use when connecting to the host.
#!                  Optional
#! @input password: The password to use when connecting to the host.
#!                  Optional
#! @input auth_type: The type of authentication used by this operation when trying to execute the request on the target
#!                   WinRM service. The supported authentication types are: Basic, NTLM and Kerberos.
#!                   Default value: NTLM
#!                   Optional
#! @input command_type: This input is used to select the type of command to be executed. Use 'cmd' to execute CMD
#!                      commands and 'powershell' to execute PowerShell commands. Valid values: cmd, powershell.
#!                      Default value: cmd
#!                      Optional
#! @input command: The CMD command or PowerShell script that will be executed on the remote host. This capability is
#!                 provided “as is”, please see product documentation for further information.
#! @input configuration_name: The name of the PSSessionConfiguration to use. This can be used to target specific
#!                            versions of PowerShell if the PSSessionConfiguration is properly configured on the target.
#!                            By default, after PSRemoting is enabled on the target, the configuration name for
#!                            PowerShell v5 or lower is 'microsoft.powershell', for PowerShell v6 is 'PowerShell.6', for
#!                            PowerShell v7 is 'PowerShell.7'. Additional configurations can be created by the user on
#!                            the target machines. By default the operation will work with PowerShell 5.
#!                            If command_type input has as value 'cmd' then this input will be ignored.
#!                            Valid values: any PSConfiguration that exists on the host.
#!                            Examples: 'microsoft.powershell', 'PowerShell.6', 'PowerShell.7'
#!                            Optional
#! @input request_new_kerberos_ticket: Allows you to request a new ticket to the target computer specified by the
#!                                     service principal name (SPN). This input will be ignored if auth_type is not 'kerberos'.
#!                                     Valid values: true, false
#!                                     Default value: true
#!                                     Optional
#! @input kerberos_conf_file: A krb5.conf file path or a text (with \n used as new line) with content similar to the one in the examples (where you replace
#!                            CONTOSO.COM with your domain and 'ad.contoso.com' with your kdc FQDN). This configures
#!                            the Kerberos mechanism required by the Java GSS-API methods. This input will be ignored if
#!                            auth_type is not 'kerberos'.
#!                            Optional
#! @input kerberos_login_conf_file: A login.conf file path or a text (with \n used as new line) needed by the JAAS framework with the content similar to the one in examples.
#!                                  This input will be ignored if auth_type is not 'kerberos'
#!                                  Optional
#! @input use_subject_creds_only: True by default. Set to false to enable JAAS Kerberos login when JGSS cannot get credentials from the current Subject.
#!                                This input will be ignored if auth_type is not 'kerberos'
#!                                Valid values: true, false
#!                                Optional
#! @input working_directory: The path of the directory where to be executed the CMD or PowerShell command.
#!                           Optional
#! @input proxy_host: The proxy server used to access the host.
#!                    Optional
#! @input proxy_port: The proxy server port.
#!                    Default value: 8080
#!                    Optional
#! @input proxy_username: The username used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input tls_version: The version of TLS to use. By default, the operation tries to establish a secure connection over
#!                     TLSv1.2.
#!                     This capability is provided “as is”, please see product documentation for further
#!                     security considerations regarding TLS versions and ciphers. In order to connect successfully to
#!                     the target host, it should accept the specified TLS version. If this is not the case, it is the
#!                     user's responsibility to configure the host accordingly.
#!                     Valid values: TLSv1, TLSv1.1, TLSv1.2, TLSv1.3
#!                     Default value: TLSv1.2
#!                     Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no
#!                         trusted certification authority issued it.
#!                         Valid values: true, false
#!                         Default value: false
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
#!                                 "browser_compatible" matches all subdomains, including "a.b.foo.com". From the
#!                                 security perspective, to provide protection against possible Man-In-The-Middle
#!                                 attacks, we strongly recommend to use "strict" option.
#!                                 Valid values: strict, browser_compatible, allow_all
#!                                 Default: strict
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that
#!                        you expect to communicate with, or from Certificate Authorities that you trust to identify
#!                        other parties.  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is
#!                        'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystore
#!                        is empty, trustPassword default will be supplied.
#!                        Default value: changeit
#!                        Optional
#! @input keystore: The pathname of the Java KeyStore file. You only need this if the server requires client
#!                  authentication. If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is
#!                  'true' this input is ignored.
#!                  Format: Java
#!                  KeyStore (JKS)
#!                  Optional
#! @input keystore_password: The password associated with the KeyStore file. If trustAllRoots is false and keystore is
#!                           empty, keystorePassword default will be supplied.
#!                           Default value: changeit
#!                           Optional
#! @input operation_timeout: Defines the OperationTimeout value in seconds to indicate that the clients expect a
#!                           response or a fault within the specified time.
#!                           Default value: 60
#!                           Optional
#!
#! @output return_result: The result of the script execution written on the stdout stream of the opened shell in case of
#!                        success or the error from stderr in case of failure.
#! @output return_code: The return code of the operation: 0 for success, -1 for failure.
#! @output stdout: The result of the script execution written on the stdout stream of the opened shell.
#! @output stderr: The error messages and other warnings written on the stderr stream.
#! @output command_exit_code: The exit code returned by the powershell script execution.
#! @output exception: In case of failure response, this result contains the java stack trace of the runtime exception or
#!                    fault details that the remote server generated throughout its communication with the client.
#!
#! @result SUCCESS: The CMD or PowerShell command was executed successfully and the 'command_exit_code' value is 0.
#! @result FAILURE: The CMD or PowerShell command could not be executed or the value of the 'command_exit_code' is different than 0.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.winrm

operation: 
  name: winrm_command
  
  inputs: 
    - host
    - domain:
       required: false
    - port:
        default: '5986'
        required: false  
    - protocol:
        default: 'https'
        required: false  
    - username:  
        required: false  
    - password:  
        required: false  
        sensitive: true
    - auth_type:
        default: 'NTLM'
        required: false  
    - authType: 
        default: ${get('auth_type', '')}
        required: false 
        private: true
    - command_type:
        default: 'cmd'
        required: false
    - commandType:
        default: ${get('command_type', '')}
        required: false
        private: true
    - command
    - configuration_name:
        required: false
    - configurationName:
        default: ${get('configuration_name', '')}
        required: false
        private: true
    - request_new_kerberos_ticket:
        default: 'true'
        required: false
    - requestNewKerberosTicket:
        default: ${get('request_new_kerberos_ticket', '')}
        required: false
        private: true
    - kerberos_conf_file:
        required: false
    - kerberosConfFile:
        default: ${get('kerberos_conf_file', '')}
        required: false
        private: true
    - kerberos_login_conf_file:
        required: false
    - kerberosLoginConfFile:
        default: ${get('kerberos_login_conf_file', '')}
        required: false
        private: true
    - use_subject_creds_only:
        required: false
    - useSubjectCredsOnly:
        default: ${get('use_subject_creds_only', '')}
        required: false
        private: true
    - working_directory:
        required: false
    - workingDirectory:
        default: ${get('working_directory', '')}
        required: false
        private: true
    - proxy_host:  
        required: false  
    - proxyHost: 
        default: ${get('proxy_host', '')}  
        required: false 
        private: true 
    - proxy_port:
        default: '8080'
        required: false  
    - proxyPort: 
        default: ${get('proxy_port', '')}
        required: false 
        private: true 
    - proxy_username:  
        required: false  
    - proxyUsername: 
        default: ${get('proxy_username', '')}  
        required: false 
        private: true 
    - proxy_password:  
        required: false  
        sensitive: true
    - proxyPassword: 
        default: ${get('proxy_password', '')}  
        required: false 
        private: true 
        sensitive: true
    - tls_version:
        default: 'TLSv1.2'
        required: false
    - tlsVersion:
        default: ${get('tls_version', '')}
        required: false
        private: true
    - trust_all_roots:
        default: 'false'
        required: false  
    - trustAllRoots: 
        default: ${get('trust_all_roots', '')}
        required: false 
        private: true 
    - x_509_hostname_verifier:
        default: 'strict'
        required: false  
    - x509HostnameVerifier: 
        default: ${get('x_509_hostname_verifier', '')}
        required: false 
        private: true 
    - trust_keystore:  
        required: false  
    - trustKeystore: 
        default: ${get('trust_keystore', '')}
        required: false 
        private: true 
    - trust_password:
        default: 'changeit'
        required: false  
        sensitive: true
    - trustPassword: 
        default: ${get('trust_password', '')}
        required: false 
        private: true 
        sensitive: true
    - keystore:
        required: false  
    - keystore_password:
        default: 'changeit'
        required: false  
        sensitive: true
    - keystorePassword: 
        default: ${get('keystore_password', '')}
        required: false 
        private: true 
        sensitive: true
    - operation_timeout:
        default: '60'
        required: false  
    - operationTimeout: 
        default: ${get('operation_timeout', '')}
        required: false 
        private: true
    
  java_action: 
    gav: 'io.cloudslang.content:cs-winrm:0.0.19-SNAPSHOT'
    class_name: 'io.cloudslang.content.winrm.actions.WinRMAction'
    method_name: 'execute'
  
  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - stdout: ${get('stdout', '')}
    - stderr: ${get('stderr', '')} 
    - command_exit_code: ${get('commandExitCode', '')}
    - exception: ${get('exception', '')}
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE