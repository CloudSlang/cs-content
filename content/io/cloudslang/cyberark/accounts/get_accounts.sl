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
#! @description: This method returns a list of all the accounts in Privilege Cloud. The user who runs this web service
#!               requires List Accounts permissions in the Safe.
#!
#! @input hostname: The hostname or IP address of the host.
#! @input protocol: Specifies what protocol is used to execute commands on the remote host.
#!                  Valid values: http, https
#!                  Default value: https
#!                  Optional
#! @input auth_token: Token used to authenticate to the CyberArk environment.
#! @input search: A list of keywords to search for in accounts, separated by a space.
#!                Optional
#! @input search_type: Get accounts that either contain or start with the value specified in the Search parameter.
#!                     Valid values: contains/startswith
#!                     Default value: contains
#!                     Optional
#! @input sort: The property or properties that you want to sort returned accounts, followed by asc (default) or desc to
#!              control sort direction. Separate multiple properties with commas, up to a maximum of three properties.
#!              Optional
#! @input offset: Offset of the first account that is returned in the collection of results.
#!                Default value: 0
#!                Optional
#! @input limit: The maximum number of returned accounts. The maximum number that you can specify is 1000.
#!               When used
#!               together with the Offset parameter, this value determines the number of accounts to return, starting
#!               from the first account that is returned.
#!               Default value: 50
#!               Optional
#! @input filter: Search for accounts using a filter.
#!                To use more than one filter, use the AND operator.
#!                Optional
#! @input saved_filter: Search for accounts using a saved filter(s).
#!                      Search using any of the following saved filter types:
#!                      Regular
#!                      Recently
#!                      New
#!                      Link
#!                      Deleted
#!                      PolicyFailures
#!                      AccessedByUsers
#!                      ModifiedByUsers
#!                      ModifiedByCPM
#!                      DisabledPasswordByUser
#!                      DisabledPasswordByCPM
#!                      ScheduledForChange
#!                      ScheduledForVerify
#!                      ScheduledForReconcile
#!                      SuccessfullyReconciled
#!                      FailedChange
#!                      FailedVerify
#!                      FailedReconcile
#!                      LockedOrNew
#!                      Locked
#!                      Favorites
#! @input proxy_host: The proxy server used to access the host.
#!                    Optional
#! @input proxy_port: The proxy server port.
#!                    Default value: 8080
#!                    Optional
#! @input proxy_username: The username used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input tls_version: The version of TLS to use. The value of this input will be ignored if 'protocol' is set to 'HTTP'.
#!                     This capability is provided “as is”, please see product documentation for further
#!                     information.Valid values: TLSv1.2
#!                     Default value: TLSv1.2
#!                     Optional
#! @input allowed_ciphers: A list of ciphers to use. This capability is provided “as is”, please see product documentation for
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
#! @input x509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to
#!                                 "allow_all" to skip any checking.
#!                                 Valid values: strict, browser_compatible, allow_all
#!                                 Default value: strict
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that
#!                        you expect to communicate with, or from Certificate Authorities that you trust to identify
#!                        other parties.  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is
#!                        'true' this input is ignored. 
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file.
#!                        Optional
#! @input keystore: The pathname of the Java KeyStore file. You only need this if the server requires client
#!                  authentication. If the protocol (specified by the 'url') is not 'https' this input is ignored.
#!                  Format: Java KeyStore (JKS)
#!                  Optional
#! @input keystore_password: The password associated with the KeyStore file.
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
#!                    keep_alive is false, the already open connection will be used and after execution it will close it.
#!                    Valid values: true, false
#!                    Default value: false
#!                    Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.
#!                                   Default: 2
#!                                   Optional
#! @input connections_max_total: The maximum limit of connections in total.
#!                               Default: 20
#!                               Optional
#!
#! @output return_result: Contains a human readable message describing the status of the CyberArk action or the CyberArk response if one was provided.
#! @output status_code: The status_code returned by the server.
#! @output return_code: The returnCode of the operation: 0 for success, -1 for failure
#! @output exception: In case of success response, this result is empty. In case of failure response, this result contains the java stack trace of the runtime exception.
#!
#! @result SUCCESS: The operation executed successfully and the 'return_code' is 0.
#! @result FAILURE: The operation could not be executed or the value of the 'return_code' is different than 0.
#!!#
########################################################################################################################

namespace: io.cloudslang.cyberark.accounts

operation: 
  name: get_accounts
  
  inputs: 
    - hostname    
    - protocol:
        default: 'https'
        required: false  
    - auth_token    
    - authToken: 
        default: ${get('auth_token', "")}
        required: false 
        private: true 
    - search:
        required: false  
    - search_type:
        default: 'contains'
        required: false  
    - searchType: 
        default: ${get('search_type', "")}
        required: false 
        private: true 
    - sort:
        required: false
    - offset:
        default: '0'
        required: false
    - limit:
        default: '50'
        required: false  
    - filter:
        required: false  
    - saved_filter:
        required: false  
    - savedFilter: 
        default: ${get('saved_filter', "")}
        required: false 
        private: true 
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get('proxy_host', "")}
        required: false
        private: true
    - proxy_port:
        default: '8080'
        required: false
    - proxyPort:
        default: ${get('proxy_port', "")}
        required: false
        private: true
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get('proxy_username', "")}
        required: false
        private: true
    - proxy_password:
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get('proxy_password', "")}
        required: false
        private: true
        sensitive: true
    - tls_version:
        default: 'TLSv1.2'
        private: true
        required: false
    - tlsVersion:
        default: ${get('tls_version', "")}
        required: false
        private: true
    - allowed_ciphers:
        required: false
    - allowedCiphers:
        default: ${get('allowed_ciphers', "")}
        required: false
        private: true
    - trust_all_roots:
        default: 'false'
        required: false
    - trustAllRoots:
        default: ${get('trust_all_roots', "")}
        required: false
        private: true
    - x509_hostname_verifier:
        default: 'strict'
        required: false
    - x509HostnameVerifier:
        default: ${get('x509_hostname_verifier', "")}
        required: false
        private: true
    - trust_keystore:
        required: false
    - trustKeystore:
        default: ${get('trust_keystore', "")}
        required: false
        private: true
    - trust_password:
        required: false
        sensitive: true
    - trustPassword:
        default: ${get('trust_password', "")}
        required: false
        private: true
        sensitive: true
    - keystore:
        required: false
        default: ''
    - keystore_password:
        required: false
        sensitive: true
    - keystorePassword:
        default: ${get('keystore_password', "")}
        required: false
        private: true
        sensitive: true
    - connect_timeout:
        default: '60'
        required: false
    - connectTimeout:
        default: ${get('connect_timeout', "")}
        required: false
        private: true
    - execution_timeout:
        default: '60'
        required: false
    - executionTimeout:
        default: ${get('execution_timeout', "")}
        required: false
        private: true
    - keep_alive:
        default: 'false'
        required: false
    - keepAlive:
        default: ${get('keep_alive', "")}
        required: false
        private: true
    - connections_max_per_route:
        default: '2'
        required: false
    - connectionsMaxPerRoute:
        default: ${get('connections_max_per_route', "")}
        required: false
        private: true
    - connections_max_total:
        default: '20'
        required: false  
    - connectionsMaxTotal: 
        default: ${get('connections_max_total', "")}
        required: false 
        private: true 


  java_action: 
    gav: 'io.cloudslang.content:cs-cyberark:0.0.5-SNAPSHOT'
    class_name: io.cloudslang.content.cyberark.actions.accounts.GetAccounts
    method_name: execute
  
  outputs: 
    - return_result: ${get('returnResult', "")}
    - status_code: ${get('statusCode', "")}
    - return_code: ${get('returnCode', "")}
    - exception: ${get('exception', "")}
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
