#   (c) Copyright 2021 EntIT Software LLC, a Micro Focus company, L.P.
#   All rights reserved. This program and the accompanying materials
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
#! @description: This operation executes PowerShell scripts on a remote Windows server using WinRM.
#!
#! Notes:
#! 1. This operations uses the Windows Remote Management (WinRM) implementation for WS-Management standard to execute PowerShell scripts. This operations is designed to run on remote hosts that have PowerShell installed and configured.
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
#! Kerberos authentication type should be enabled by default on the winrm service. If you are not going to use domain accounts to access the remoet host you can disable it:
#!     winrm set winrm/config/service/Auth @{Kerberos="false"}
#! Configure WinRM to provide enough memory to the commands that you are going to run, e.g. 1024 MB:
#!     winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1024"}
#! Manualy Enable the WinRM firewall exception if winrm quickconfig did not work:
#!     netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
#! Run this command to check your configurations:
#!     winrm get Winrm/config
#! Use the following command to enumerate the winrm configured listeners. You should have one for http listening on 5985 and one for https listening on 5986:
#!     winrm enumerate winrm/config/listener
#! The defult ports for WinRM connections are 5985 for HTTP and 5986 for HTTPS protocols. Use netstat -ano | findstr "5985" and netstat -ano | findstr "5986" to check if the ports are opened.
#!
#! 2. For HTTPS connection do the following:
#! Create a self signed certificate for the remote host. Import the certificate in the client keystore and copy the certificate thumbrpint.
#! Create an HTTPS WinRM listener on the remote host with the thumbprint of the certificate you've just copied.
#!     winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname="HOSTNAME"; CertificateThumbprint="THUMBPRINT"}
#! Do a quickconfig for WinRM with HTTPS:
#!     winrm quickconfig -transport:https
#! Check the complete WinRM configurations and that the listeners have been configured with:
#!     winrm get winrm/config
#!     winrm enumerate winrm/config/listener
#!
#! @input host: The hostname or IP address of the host.
#! @input script: The PowerShell script that will be executed on the remote shell. Check the notes section for security
#!                implications of using this input.
#! @input port: The port number used to connect to the host. The default value for this input dependents on the protocol
#!              input.
#!              Valid values: 5985 for Http and 5986 for Https.
#!              Default value: 5986
#!              Optional
#! @input protocol: Specifies what protocol is used to execute commands on the remote host.
#!                  Valid values: http, https
#!                  Default: 'https'
#!                  Optional
#! @input username: The username to use when connecting to the host.
#!                  Optional
#! @input password: The password to use when connecting to the host.
#!                  Optional
#! @input auth_type: The type of authentication used by this operation when trying to execute the request on the target
#!                   WinRM service. The supported authentication types are: Basic, NTLM and Kerberos.
#!                   Default value: NTLM
#!                   Optional
#! @input proxy_host: The proxy server used to access the host.
#!                    Optional
#! @input proxy_port: The proxy server port.
#!                    Default value:8080
#!                    Optional
#! @input proxy_username: The username used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxyUsername input value.
#!                        Optional
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
#!                        Default value: <OO_Home>/java/lib/security/cacerts
#!                        Format: Java
#!                        KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystore
#!                        is empty, trustPassword default will be supplied.
#!                        Default value: changeit
#!                        Optional
#! @input keystore: The pathname of the Java KeyStore file. You only need this if the server requires client
#!                  authentication. If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is
#!                  'true' this input is ignored.
#!                  Default value: <OO_Home>/java/lib/security/cacerts
#!                  Format: Java
#!                  KeyStore (JKS)
#!                  Optional
#! @input keystore_password: The password associated with the KeyStore file. If trustAllRoots is false and keystore is
#!                           empty, keystorePassword default will be supplied.
#!                           Default value: change it
#!                           Optional
#! @input operation_timeout: Defines the OperationTimeout value in seconds to indicate that the clients expect a
#!                           response or a fault within the specified time.
#!                           Default value: 60
#!                           Optional
#! @input tls_version: The version of TLS to use. By default, the operation tries to establish a secure connection over
#!                     TLSv1.2.
#!                     Valid values: SSLv3, TLSv1, TLSv1.1, TLSv1.2, TLSv1.3.
#!                     Default value: TLSv1.2
#!                     Optional
#! @input request_new_kerberos_ticket: Allows you to request a new ticket to the target computer specified by the
#!                                     service principal name (SPN).
#!                                     Valid values: true, false.
#!                                     Default value: true
#!                                     Optional
#! @input working_directory: The path of the directory where to be executed the PowerShell script.
#!                           Optional
#!
#! @output return_code: The result of the script execution written on the stdout stream of the opened shell in case of
#!                      success or the error from stderr in case of failure.
#! @output return_result: The result of the script execution written on the stdout stream of the opened shell in case of
#!                        success or the error from stderr in case of failure.
#! @output stderr: The error messages and other warnings written on the stderr stream.
#! @output script_exit_code: The exit code returned by the powershell script execution.
#! @output exception: In case of failure response, this result contains the java stack trace of the runtime exception or
#!                    fault details that the remote server generated throughout its communication with the client.
#! @output stdout: The result of the script execution written on the stdout stream of the opened shell.
#!
#! @result SUCCESS: The PowerShell script was executed successfully and the 'scriptExitCode' value is 0.
#! @result FAILURE: The PowerShell script could not be executed or the value of the 'scriptExitCode' is different than
#!                  0.
#!!#
########################################################################################################################

namespace: io.cloudslang.winrm

operation: 
  name: winrm_command
  
  inputs: 
    - host    
    - script    
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
        required: false  
    - authType: 
        default: ${get('auth_type', 'NTLM')}
        required: false 
        private: true 
    - proxy_host:  
        required: false  
    - proxyHost: 
        default: ${get('proxy_host', '')}  
        required: false 
        private: true 
    - proxy_port:  
        required: false  
    - proxyPort: 
        default: ${get('proxy_port', '8080')}
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
    - trust_all_roots:  
        required: false  
    - trustAllRoots: 
        default: ${get('trust_all_roots', 'false')}
        required: false 
        private: true 
    - x_509_hostname_verifier:  
        required: false  
    - x509HostnameVerifier: 
        default: ${get('x_509_hostname_verifier', 'strict')}
        required: false 
        private: true 
    - trust_keystore:  
        required: false  
    - trustKeystore: 
        default: ${get('trust_keystore', '<OO_Home>/java/lib/security/cacerts')}
        required: false 
        private: true 
    - trust_password:  
        required: false  
        sensitive: true
    - trustPassword: 
        default: ${get('trust_password', 'changeit')}
        required: false 
        private: true 
        sensitive: true
    - keystore:
        default: '<OO_Home>/java/lib/security/cacerts'
        required: false  
    - keystore_password:  
        required: false  
        sensitive: true
    - keystorePassword: 
        default: ${get('keystore_password', 'changeit')}
        required: false 
        private: true 
        sensitive: true
    - operation_timeout:  
        required: false  
    - operationTimeout: 
        default: ${get('operation_timeout', '60')}
        required: false 
        private: true 
    - tls_version:  
        required: false  
    - tlsVersion: 
        default: ${get('tls_version', 'TLSv1.2')}
        required: false 
        private: true 
    - request_new_kerberos_ticket:  
        required: false  
    - requestNewKerberosTicket: 
        default: ${get('request_new_kerberos_ticket', '')}  
        required: false 
        private: true 
    - working_directory:  
        required: false  
    - workingDirectory: 
        default: ${get('working_directory', '')}  
        required: false 
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-winrm:0.0.1-RC1'
    class_name: 'io.cloudslang.content.winrm.actions.WinRMAction'
    method_name: 'execute'
  
  outputs: 
    - return_code: ${get('returnCode', '')} 
    - return_result: ${get('returnResult', '')} 
    - stderr: ${get('stderr', '')} 
    - script_exit_code: ${get('scriptExitCode', '')} 
    - exception: ${get('exception', '')} 
    - stdout: ${get('stdout', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
