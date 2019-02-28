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
#! @description: This operation initiates a graceful failover for a specific server node.
#!               'https://developer.couchbase.com/documentation/server/4.6/rest-api/rest-failover-graceful.html'
#!
#! @input endpoint: Endpoint to which request will be sent.
#!                  Example: 'http://somewhere.couchbase.com:8091'
#! @input username: Username used in basic authentication.
#! @input password: Password associated with "username" input to be used in basic authentication.
#! @input proxy_host: Proxy server used to connect to Couchbase API. If empty no proxy will be used.
#!                    Optional
#! @input proxy_port: Proxy server port. You must either specify values for both proxy_host
#!                    and proxy_port inputs or leave them both empty.
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL.
#!                         A certificate is trusted even if no trusted certification authority issued it.
#!                         Valid: 'true', 'false'
#!                         Default: 'true'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the
#!                                 subject's Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Set this to "allow_all" to skip any checking. For the value "browser_compatible"
#!                                 the hostname verifier works the same way as Curl and Firefox. The hostname must
#!                                 match either the first CN, or any of the subject-alts. A wildcard can occur in
#!                                 the CN, and in any of the subject-alts. The only difference between
#!                                 "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com")
#!                                 with "browser_compatible" matches all subdomains, including "a.b.foo.com".
#!                                 Valid values: "strict", "browser_compatible", "allow_all"
#!                                 Default value: "allow_all"
#!                                 Optional
#! @input trust_keystore: Pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities
#!                        that you trust to identify other parties. If the protocol (specified by the "url")
#!                        is not "https" or if trustAllRoots is "true" this input is ignored.
#!                        Default: '../java/lib/security/cacerts'
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: Password associated with the TrustStore file. If trust_all_roots is
#!                        'false' and trustKeystore is empty, trustPassword default will be supplied.
#!                        Default: 'changeit'
#!                        Optional
#! @input keystore: Pathname of the Java KeyStore file. You only need this if the server
#!                  requires client authentication. If the protocol (specified by the 'url') is not
#!                  'https' or if trust_all_roots is 'true' this input is ignored.
#!                  Format: Java KeyStore (JKS)
#!                  Default: '../java/lib/security/cacerts.'
#!                  Optional
#! @input keystore_password: Password associated with the KeyStore file. If trust_all_roots is 'false'
#!                           and keystore is empty, keystorePassword default will be supplied.
#!                           Default: 'changeit'
#!                           Optional
#! @input connect_timeout: Time to wait for a connection to be established, in seconds. A timeout
#!                         value of '0' represents an infinite timeout.
#!                         Default: '0'
#!                         Optional
#! @input socket_timeout: Timeout for waiting for data (a maximum period inactivity between two
#!                        consecutive data packets), in seconds. A socket_timeout value of '0' represents
#!                        an infinite timeout.
#!                        Default: '0'
#!                        Optional
#! @input use_cookies: Specifies whether to enable cookie tracking or not. Cookies are stored
#!                     between consecutive calls in a serializable session object therefore they will
#!                     be available on a branch level. If you specify a non-boolean value, the default
#!                     value is used.
#!                     Valid: 'true', 'false'
#!                     Default: 'true'
#!                     Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in
#!                    subsequent calls. If keepAlive is 'false', the already open connection will be
#!                    used and after execution it will close it.
#!                    Valid: 'true', 'false'
#!                    Default: 'true'
#!                    Optional
#! @input internal_node_ip_address: Indicates a specific node to be graceful failed over.
#!                                  Example: 'ns_2@10.0.0.2'
#!                                  Optional
#!
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#! @output return_result: A map with strings as keys and strings as values that contains the outcome of the operation.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: A gracefully failover has been initiated successfully for the specified server node.
#! @result FAILURE: An error occurred while trying to initiate a graceful failover for the specified server node.
#!!#
########################################################################################################################

namespace: io.cloudslang.couchbase.nodes

operation: 
  name: graceful_fail_over_node
  
  inputs: 
    - endpoint    
    - username    
    - password:    
        sensitive: true
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
        default: 'true'
        required: false
    - trustAllRoots:
        default: ${get('trust_all_roots', '')}
        required: false
        private: true
    - x_509_hostname_verifier:
        default: 'allow_all'
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
    - connect_timeout:
        default: '0'
        required: false
    - connectTimeout:
        default: ${get('connect_timeout', '')}
        required: false
        private: true
    - socket_timeout:
        default: '0'
        required: false
    - socketTimeout:
        default: ${get('socket_timeout', '')}
        required: false
        private: true
    - use_cookies:
        default: 'true'
        required: false
    - useCookies:
        default: ${get('use_cookies', '')}
        required: false
        private: true
    - keep_alive:
        default: 'true'
        required: false
    - internal_node_ip_address:  
        required: false  
    - internalNodeIpAddress: 
        default: ${get('internal_node_ip_address', '')}  
        required: false 
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-couchbase:0.1.0'
    class_name: 'io.cloudslang.content.couchbase.actions.nodes.GracefulFailOverNode'
    method_name: 'execute'
  
  outputs: 
    - return_code: ${returnCode} 
    - return_result: ${returnResult} 
    - exception: ${exception} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
