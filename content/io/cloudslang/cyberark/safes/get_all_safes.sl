#   (c) Copyright 2022 Micro Focus, L.P.
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
#! @description: This method returns a list of all Safes in the Vault that the user has permissions for.
#!
#! @input hostname: The hostname or IP address of the host.
#! @input protocol: Specifies what protocol is used to execute commands on the remote host.
#!                  Valid values: http, https
#!                  Default value: https
#!                  Optional
#! @input auth_token: Token used to authenticate to the cyberark environment.
#! @input search: A list of keywords to search for in safes, separated by a space.
#!                Optional
#! @input offset: Offset of the first safe that is returned in the collection of results.
#!                Default value: 0
#!                Optional
#! @input sort: Sorts according to the safeName property in ascending order (default) or descending order to control the
#!              sort direction. Valid values: asc, desc
#!              Optional
#! @input limit: The maximum number of returned safes.
#!               When used together with the Offset parameter, this value
#!               determines the number of safes to return, starting from the first safe that is returned.
#!               Default value:
#!               25
#!               Optional
#! @input include_accounts: Whether or not to return accounts for each Safe as part of the response. If not sent, the
#!                          value is False.
#!                          Optional
#! @input extended_details: Whether or not to return all Safe details or only safeName as part of the response. If not
#!                          sent, the value is True.
#!                          Optional
#! @input proxy_host: The proxy server used to access the host.
#!                    Optional
#! @input proxy_port: The proxy server port.
#!                    Default value:8080
#!                    Optional
#! @input proxy_username: The username used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxyUsername input value.
#!                        Optional
#! @input tls_version: The version of TLS to use. The value of this input will be ignored if 'protocol'is set to 'HTTP'.
#!                     This capability is provided “as is”, please see product documentation for further
#!                     information.Valid values: TLSv1, TLSv1.1, TLSv1.2. 
#!                     Default value: TLSv1.2.
#!                     Optional
#! @input allowed_cyphers: A list of ciphers to use. The value of this input will be ignored if 'tlsVersion' does not
#!                         contain 'TLSv1.2'. This capability is provided “as is”, please see product documentation for
#!                         further security considerations.In order to connect successfully to the target host, it
#!                         should accept at least one of the following ciphers. If this is not the case, it is the
#!                         user's responsibility to configure the host accordingly or to update the list of allowed
#!                         ciphers. 
#!                         Default value: TLS_DHE_RSA_WITH_AES_256_GCM_SHA384,
#!                         TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
#!                         TLS_DHE_RSA_WITH_AES_256_CBC_SHA256, TLS_DHE_RSA_WITH_AES_128_CBC_SHA256,
#!                         TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,
#!                         TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
#!                         TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
#!                         TLS_RSA_WITH_AES_256_GCM_SHA384, TLS_RSA_WITH_AES_256_CBC_SHA256,
#!                         TLS_RSA_WITH_AES_128_CBC_SHA256.
#!                         Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no
#!                         trusted certification authority issued it.
#!                         Valid values: true, false
#!                         Default value: false
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to
#!                                 "allow_all" to skip any checking. For the value "browser_compatible" the hostname
#!                                 verifier works the same way as Curl and Firefox. The hostname must match either the
#!                                 first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of
#!                                 the subject-alts. The only difference between "browser_compatible" and "strict" is
#!                                 that a wildcard (such as "*.foo.com") with "browser_compatible" matches all
#!                                 subdomains, including "a.b.foo.com".
#!                                 Valid values: strict, browser_compatible, allow_all
#!                                 Default value: strict
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that
#!                        you expect to communicate with, or from Certificate Authorities that you trust to identify
#!                        other parties.  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is
#!                        'true' this input is ignored. 
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystore
#!                        is empty, trustPassword default will be supplied.
#!                        Optional
#! @input keystore: The pathname of the Java KeyStore file. You only need this if the server requires client
#!                  authentication. If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is
#!                  'true' this input is ignored. Format: Java KeyStore (JKS)
#!                  Optional
#! @input keystore_password: The password associated with the KeyStore file. If trustAllRoots is false and keystore is
#!                           empty, keystorePassword default will be supplied.
#!                           Optional
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.
#!                         Default: 60
#!                         Optional
#! @input execution_timeout: The amount of time (in seconds) to allow the client to complete the execution of an API
#!                           call. A value of '0' disables this feature. 
#!                           Default: 60
#!                           Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls. If
#!                    keepAlive is false, the already open connection will be used and afterexecution it will close it.
#!                    Valid values: true, false
#!                    Default value: false
#!                    Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.
#!                                   Default value: 2
#!                                   Optional
#! @input connections_max_total: The maximum limit of connections in total.
#!                               Default: 20
#!                               Optional
#!
#! @output return_result: 
#! @output status_code: 
#! @output return_code: 
#! @output exception: 
#!
#! @result SUCCESS: Generated description.
#! @result FAILURE: Generated description.
#!!#
########################################################################################################################

namespace: io.cloudslang.cyberark.safes

operation: 
  name: get_all_safes
  
  inputs: 
    - hostname    
    - protocol:
        default: 'https'
        required: false  
    - auth_token    
    - authToken: 
        default: ${get('auth_token', '')}  
        required: false 
        private: true 
    - search:  
        required: false  
    - offset:  
        required: false  
    - sort:  
        required: false  
    - limit:  
        required: false  
    - include_accounts:  
        required: false  
    - includeAccounts: 
        default: ${get('include_accounts', '')}  
        required: false 
        private: true 
    - extended_details:  
        required: false  
    - extendedDetails: 
        default: ${get('extended_details', '')}  
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
    - allowed_cyphers:
        required: false
    - allowedCyphers:
        default: ${get('allowed_cyphers', '')}
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
        required: false
        sensitive: true
    - keystorePassword:
        default: ${get('keystore_password', '')}
        required: false
        private: true
        sensitive: true
    - connect_timeout:
        default: '60'
        required: false
    - connectTimeout:
        default: ${get('connect_timeout', '')}
        required: false
        private: true
    - execution_timeout:
        default: '60'
        required: false
    - executionTimeout:
        default: ${get('execution_timeout', '')}
        required: false
        private: true
    - keep_alive:
        default: 'false'
        required: false
    - keepAlive:
        default: ${get('keep_alive', '')}
        required: false
        private: true
    - connections_max_per_route:
        default: '2'
        required: false
    - connectionsMaxPerRoute:
        default: ${get('connections_max_per_route', '')}
        required: false
        private: true
    - connections_max_total:
        default: '20'
        required: false  
    - connectionsMaxTotal: 
        default: ${get('connections_max_total', '')}  
        required: false 
        private: true 
    
  java_action:
    gav: 'io.cloudslang.content:cs-cyberark:1.0.0-SNAPSHOT'
    class_name: io.cloudslang.content.cyberark.actions.safes.GetAllSafes
    method_name: execute
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - status_code: ${get('statusCode', '')} 
    - return_code: ${get('returnCode', '')} 
    - exception: ${get('exception', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
