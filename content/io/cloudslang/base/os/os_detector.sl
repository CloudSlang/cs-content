#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: Attempts to detect the operating system of a machine by using system calls (if the machine is local),
#!               connecting to the machine using SSH or PowerShell (and running specific commands) or by running a Nmap command.
#!
#! @input host: The hostname or ip address of the remote host.
#! @input username: The username used to connect to the remote machine (For SSH and PowerShell detection).
#!                  Optional
#! @input password: The password used to connect to the remote machine (For SSH and PowerShell detection).
#!                  Optional
#! @input port: The port to use when connecting to the remote server (For SSH and PowerShell detection).
#!              Example: '22', '5985', '5986'
#!              Default for SSH: '22'
#!              Default for PowerShell: '5986'
#!              Optional
#! @input proxy_host: The proxy server used to access the remote host (For SSH, PowerShell and Nmap detection).
#!                    Optional
#! @input proxy_port: The proxy server port (For SSH, PowerShell and Nmap detection).
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: The username used when connecting to the proxy (For SSH and PowerShell detection).
#!                        Optional
#! @input proxy_password: The password used when connecting to the proxy (For SSH and PowerShell detection).
#!                        Optional
#! @input private_key_file: The path to the private key file (OpenSSH type) on the machine where is the worker
#!                          (For SSH detection).
#!                          Optional
#! @input private_key_data: A string representing the private key (OpenSSH type) used for authenticating the user.
#!                          This string is usually the content of a private key file. The 'privateKeyData' and the
#!                          'privateKeyFile' inputs are mutually exclusive. For security reasons it is recommend
#!                          that the private key be protected by a passphrase that should be provided through the
#!                          'password' input (For SSH detection).
#!                          Optional
#! @input known_hosts_policy: The policy used for managing known_hosts file (For SSH detection).
#!                            Valid: 'allow', 'strict', 'add'
#!                            Default: 'strict'
#!                            Optional
#! @input known_hosts_path: The path to the known hosts file. (For SSH detection).
#!                          Optional
#! @input allowed_ciphers: A comma separated list of ciphers that will be used in the client-server handshake
#!                         mechanism when the connection is created. Check the notes section for security concerns
#!                         regarding your choice of ciphers. The default value will be used even if the input is not
#!                         added to the operation (For SSH detection).
#!                         Default: 'aes128-ctr,aes128-cbc,3des-ctr,3des-cbc,blowfish-cbc,aes192-ctr,aes192-cbc,aes256-ctr,aes256-cbc'
#!                         Optional
#! @input agent_forwarding: Enables or disables the forwarding of the authentication agent connection (For SSH detection).
#!                          Agent forwarding should be enabled with caution.
#!                          Optional
#! @input ssh_timeout: Time in milliseconds to wait for the command to complete (For SSH detection).
#!                     Default: '90000'
#!                     Optional
#! @input ssh_connect_timeout: Time in milliseconds to wait for the connection to be made (For SSH detection).
#!                             Default: '10000'
#!                             Optional
#! @input protocol: The protocol to use when connecting to the remote server (For PowerShell detection).
#!                  Valid: 'http' and 'https'
#!                  Default: 'https'
#!                  Optional
#! @input auth_type: Type of authentication used to execute the request on the target server (For PowerShell detection).
#!                   Valid: 'basic', 'form', 'springForm', 'digest', 'ntlm', 'kerberos', 'anonymous' (no authentication)
#!                   Default: 'basic'
#!                   Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even
#!                         if no trusted certification authority issued it (For PowerShell detection).
#!                         Valid: 'true', 'false'
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's Common
#!                                 Name (CN) or subjectAltName field of the X.509 certificate. The hostname verification
#!                                 system prevents communication with other hosts other than the ones you intended.
#!                                 This is done by checking that the hostname is in the subject alternative name extension
#!                                 of the certificate. This system is designed to ensure that, if an attacker(Man In The
#!                                 Middle) redirects traffic to his machine, the client will not accept the connection.
#!                                 If you set this input to "allow_all", this verification is ignored and you become
#!                                 vulnerable to security attacks. For the value "browser_compatible" the hostname verifier
#!                                 works the same way as Curl and Firefox. The hostname must match either the first CN,
#!                                 or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts.
#!                                 The only difference between "browser_compatible" and "strict" is that a wildcard
#!                                 (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com".
#!                                 From the security perspective, to provide protection against possible Man-In-The-Middle
#!                                 attacks, we strongly recommend to use "strict" option (For PowerShell detection).
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties
#!                        that you expect to communicate with, or from Certificate Authorities that you trust to
#!                        identify other parties.  If the protocol selected is not 'https' or if trustAllRoots
#!                        is 'true' this input is ignored (For PowerShell detection).
#!                        Format: Java KeyStore (JKS)
#!                        Default: ''
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and
#!                        trustKeystore is empty, trustPassword default will be supplied (For PowerShell detection).
#!                        Default: ''
#!                        Optional
#! @input keystore: The pathname of the Java KeyStore file. You only need this if the server requires client
#!                  authentication. If the protocol selected is not 'https' or if trustAllRoots is 'true'
#!                  this input is ignored (For PowerShell detection).
#!                  Format: Java KeyStore (JKS)
#!                  Default: ''
#!                  Optional
#! @input keystore_password: The password associated with the KeyStore file. If trustAllRoots is false and keystore
#!                           is empty, keystorePassword default will be supplied (For PowerShell detection).
#!                           Optional
#! @input kerberos_conf_file: A krb5.conf file with content similar to the one in the examples (where you
#!                            replace CONTOSO.COM with your domain and 'ad.contoso.com' with your kdc FQDN).
#!                            This configures the Kerberos mechanism required by the Java GSS-API methods
#!                            (For PowerShell detection).
#!                            Example: http://web.mit.edu/kerberos/krb5-1.4/krb5-1.4.4/doc/krb5-admin/krb5.conf.html
#!                            Optional
#! @input kerberos_login_conf_file: A login.conf file needed by the JAAS framework with the content similar to the one
#!                                  in examples (For PowerShell detection).
#!                                  Example: http://docs.oracle.com/javase/7/docs/jre/api/security/jaas/spec/com/sun/security/auth/module/Krb5LoginModule.html
#!                                  Optional
#! @input kerberos_skip_port_for_lookup: Do not include port in the key distribution center database lookup (For PowerShell detection).
#!                                       Valid: 'true', 'false'
#!                                       Default: 'true'
#!                                       Optional
#! @input winrm_locale: The WinRM locale to use (For PowerShell detection).
#!                      Default: 'en-US'
#!                      Optional
#! @input powershell_operation_timeout: Defines the OperationTimeout value in seconds to indicate that the clients expect a
#!                                      response or a fault within the specified time (For PowerShell detection).
#!                                      Default: '60000'
#!                                      Optional
#! @input nmap_path: The absolute path to the Nmap executable or "nmap" if added in system path (For Nmap detection).
#!                   Note: the path can be a network path.
#!                   Example: //my-network-share//nmap, nmap, "C:\\Program Files (x86)\\Nmap\\nmap.exe"
#!                   Default: 'nmap'
#!                   Optional
#! @input nmap_arguments: The Nmap arguments for operating system detection. (For Nmap detection).
#!                        Refer to this document for more details: https://nmap.org/book/man.html.
#!                        Default: '-sS -sU -O -Pn --top-ports 20'
#!                        Optional
#! @input nmap_validator: The validation level for the Nmap arguments. It is recommended to use a
#!                        restrictive validator (For Nmap detection).
#!                        Valid: 'restrictive', 'permissive'
#!                        Default: 'restrictive'
#!                        Optional
#! @input nmap_timeout: Time in milliseconds to wait for the Nmap command to finish execution (For Nmap detection).
#!                      Default: '30000'
#!                      Optional
#!
#! @output return_result: The primary output, containing a success message or the exception message in case of failure.
#! @output return_code: The return code of the operation. 0 if the operation goes to success, -1 if the operation goes to failure.
#! @output os_family: The operating system family in case of success. If the osFamily can not be determined
#!                    from either direct outputs of the detection commands or osName the value will be "Other".
#! @output os_name: The operating system name in case of success. This result might not be present.
#! @output os_architecture: The operating system architecture in case of success. This result might not be present.
#! @output os_version: The operating system version in case of success. This result might not be present.
#! @output os_commands: The output of the commands that were run in order to detect the operating system.
#! @output exception: The stack trace of the exception in case an exception occurred.
#!
#! @result SUCCESS: Operation succeeded.
#! @result FAILURE: Operation failed.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.os

operation: 
  name: os_detector
  
  inputs: 
    - host    
    - username:  
        required: false  
    - password:  
        required: false
        sensitive: true
    - port:  
        required: false  
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
    - private_key_file:  
        required: false  
    - privateKeyFile: 
        default: ${get('private_key_file', '')}  
        required: false 
        private: true 
    - private_key_data:  
        required: false  
        sensitive: true
    - privateKeyData: 
        default: ${get('private_key_data', '')}  
        required: false 
        private: true 
        sensitive: true
    - known_hosts_policy:
        default: 'strict'
        required: false  
    - knownHostsPolicy: 
        default: ${get('known_hosts_policy', '')}  
        required: false 
        private: true 
    - known_hosts_path:  
        required: false  
    - knownHostsPath: 
        default: ${get('known_hosts_path', '')}  
        required: false 
        private: true 
    - allowed_ciphers:
        default: 'aes128-ctr,aes128-cbc,3des-ctr,3des-cbc,blowfish-cbc,aes192-ctr,aes192-cbc,aes256-ctr,aes256-cbc'
        required: false  
    - allowedCiphers: 
        default: ${get('allowed_ciphers', '')}  
        required: false 
        private: true 
    - agent_forwarding:  
        required: false  
    - agentForwarding: 
        default: ${get('agent_forwarding', '')}  
        required: false 
        private: true 
    - ssh_timeout:
        default: '90000'
        required: false  
    - sshTimeout: 
        default: ${get('ssh_timeout', '')}  
        required: false 
        private: true 
    - ssh_connect_timeout:
        default: '10000'
        required: false  
    - sshConnectTimeout: 
        default: ${get('ssh_connect_timeout', '')}  
        required: false 
        private: true 
    - protocol:
        default: 'https'
        required: false  
    - auth_type:
        default: 'basic'
        required: false  
    - authType: 
        default: ${get('auth_type', '')}  
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
        default: ''
        required: false  
    - trustKeystore: 
        default: ${get('trust_keystore', '')}  
        required: false 
        private: true 
    - trust_password:
        default: ''
        required: false  
        sensitive: true
    - trustPassword: 
        default: ${get('trust_password', '')}  
        required: false 
        private: true 
        sensitive: true
    - keystore:
        default: ''
        required: false  
    - keystore_password:  
        required: false  
        sensitive: true
    - keystorePassword: 
        default: ${get('keystore_password', '')}  
        required: false 
        private: true 
        sensitive: true
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
    - kerberos_skip_port_for_lookup:
        default: 'true'
        required: false  
    - kerberosSkipPortForLookup: 
        default: ${get('kerberos_skip_port_for_lookup', '')}  
        required: false 
        private: true 
    - winrm_locale:  
        required: false  
    - winrmLocale: 
        default: ${get('winrm_locale', '')}  
        required: false 
        private: true 
    - powershell_operation_timeout:
        default: '60000'
        required: false  
    - powershellOperationTimeout: 
        default: ${get('powershell_operation_timeout', '')}  
        required: false 
        private: true 
    - nmap_path:
        default: 'nmap'
        required: false  
    - nmapPath: 
        default: ${get('nmap_path', '')}  
        required: false 
        private: true 
    - nmap_arguments:
        default: '-sS -sU -O -Pn --top-ports 20'
        required: false  
    - nmapArguments: 
        default: ${get('nmap_arguments', '')}  
        required: false 
        private: true 
    - nmap_validator:
        default: 'restrictive'
        required: false  
    - nmapValidator: 
        default: ${get('nmap_validator', '')}  
        required: false 
        private: true 
    - nmap_timeout:
        default: '30000'
        required: false  
    - nmapTimeout: 
        default: ${get('nmap_timeout', '')}  
        required: false 
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-utilities:0.1.4'
    class_name: 'io.cloudslang.content.utilities.actions.OsDetector'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - os_family: ${get('osFamily', '')}
    - os_name: ${get('osName', '')}
    - os_architecture: ${get('osArchitecture', '')}
    - os_version: ${get('osVersion', '')}
    - os_commands: ${get('osCommands', '')}
    - exception: ${get('exception', '')}
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
