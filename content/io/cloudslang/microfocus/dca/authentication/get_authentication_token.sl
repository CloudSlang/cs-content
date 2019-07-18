#   (c) Copyright 2019 Micro Focus, L.P.
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
#! @description: This operation is used to retrieve an authentication token from an IdM instance, in order to be used
#!               with the DCA operations and flows.
#!
#! @input idm_host: The hostname or IP of the IdM with which to authenticate.
#! @input idm_port: The port on which IdM is listening on the host.
#!                  Default: '5443'
#!                  Optional
#! @input protocol: The protocol to use when connecting to IdM.
#!                  Valid: 'http' or 'https'
#!                  Default: 'https'
#!                  Optional
#! @input idm_username: The IdM username to use when authenticating.
#! @input idm_password: The password of the IdM user.
#! @input dca_username: The DCA user to authenticate.
#! @input dca_password: The password of the DCA user.
#! @input dca_tenant_name: The tenant of the DCA user to authenticate.
#!                         Default: 'PROVIDER'
#!                         Optional
#! @input preemptive_auth: If this field is 'true' authentication info will be sent in the first request. If this is
#!                         'false' a request with no authentication info will be made and if server responds with 401
#!                         and a header like WWW-Authenticate: Basic realm="myRealm" only then the authentication info
#!                         will be sent.
#!                         Optional
#! @input proxy_host: The proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: The proxy server port.
#!                    Valid values: -1 and integer values greater than 0. The value '-1' indicates that the proxy
#!                    port is not set and the protocol default port will be used. If the protocol is 'http' and the
#!                    'proxy_port' is set to '-1' then port '80' will be used.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: The user name used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxyUsername input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no
#!                         trusted certification authority issued it.
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to
#!                                 "allow_all" to skip any checking. For the value "browser_compatible" the hostname
#!                                 verifier works the same way as Curl and Firefox. The hostname must match either the
#!                                 first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of
#!                                 the subject-alts. The only difference between "browser_compatible" and "strict" is
#!                                 that a wildcard (such as "*.foo.com") with "browser_compatible" matches all
#!                                 subdomains, including "a.b.foo.com".
#!                                 Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that
#!                        you expect to communicate with, or from Certificate Authorities that you trust to identify
#!                        other parties.  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is
#!                        'true' this input is ignored. Format: Java KeyStore (JKS)
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
#!                         Optional
#! @input socket_timeout: The timeout for waiting for data (a maximum period inactivity between two consecutive data
#!                        packets), in seconds. A socketTimeout value of '0' represents an infinite timeout.
#!                        Optional
#! @input use_cookies: Specifies whether to enable cookie tracking or not. Cookies are stored between consecutive calls
#!                     in a serializable session object therefore they will be available on a branch level. If you
#!                     specify a non-boolean value, the default value is used.
#!                     Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls. If
#!                    keepAlive is false, the already open connection will be used and after execution it will close it.
#!                    Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.
#!                                   Optional
#! @input connections_max_total: The maximum limit of connections in total.
#!                               Optional
#!
#! @output return_result: The authentication token in case of success, or an error message in case of failure.
#! @output return_code: The return code of the operation, 0 in case of success, -1 in case of failure
#! @output exception: In case of failure, the error message, otherwise empty.
#! @output auth_token: The authentication token returned by the IdM service.
#! @output refresh_token: The refresh token returned by the IdM service.
#!
#! @result SUCCESS: Operation succeeded, returnCode is '0'.
#! @result FAILURE: Operation failed, returnCode is '-1'.
#!!#
########################################################################################################################

namespace: io.cloudslang.microfocus.dca.authentication

operation: 
  name: get_authentication_token
  
  inputs: 
    - idm_host    
    - idmHost: 
        default: ${get('idm_host', '')}  
        required: false 
        private: true 
    - idm_port:
        default: '5443'
        required: false  
    - idmPort: 
        default: ${get('idm_port', '')}  
        required: false 
        private: true 
    - protocol:
        default: 'https'
        required: false  
    - idm_username    
    - idmUsername: 
        default: ${get('idm_username', '')}  
        required: false 
        private: true 
    - idm_password:    
        sensitive: true
    - idmPassword: 
        default: ${get('idm_password', '')}  
        required: false 
        private: true 
        sensitive: true
    - dca_username    
    - dcaUsername: 
        default: ${get('dca_username', '')}  
        required: false 
        private: true 
    - dca_password:    
        sensitive: true
    - dcaPassword: 
        default: ${get('dca_password', '')}  
        required: false 
        private: true 
        sensitive: true
    - dca_tenant_name:
        default: 'PROVIDER'
        required: false  
    - dcaTenantName: 
        default: ${get('dca_tenant_name', '')}  
        required: false 
        private: true 
    - preemptive_auth:  
        required: false  
    - preemptiveAuth: 
        default: ${get('preemptive_auth', '')}  
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
    - connect_timeout:  
        required: false  
    - connectTimeout: 
        default: ${get('connect_timeout', '')}  
        required: false 
        private: true 
    - socket_timeout:  
        required: false  
    - socketTimeout: 
        default: ${get('socket_timeout', '')}  
        required: false 
        private: true 
    - use_cookies:  
        required: false  
    - useCookies: 
        default: ${get('use_cookies', '')}  
        required: false 
        private: true 
    - keep_alive:  
        required: false  
    - keepAlive: 
        default: ${get('keep_alive', '')}  
        required: false 
        private: true 
    - connections_max_per_route:

        required: false  
    - connectionsMaxPerRoute: 
        default: ${get('connections_max_per_route', '')}  
        required: false 
        private: true 
    - connections_max_total:  
        required: false  
    - connectionsMaxTotal: 
        default: ${get('connections_max_total', '')}  
        required: false 
        private: true 
    
  java_action:
    gav: 'io.cloudslang.content:cs-microfocus-dca:1.1.1'
    class_name: 'io.cloudslang.content.dca.actions.authentication.GetAuthenticationToken'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - return_code: ${get('returnCode', '')} 
    - exception: ${get('exception', '')} 
    - auth_token: ${get('authToken', '')} 
    - refresh_token: ${get('refreshToken', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
