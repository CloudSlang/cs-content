########################################################################################################################
#!!
#! @description: This operation can be used to retrieve a list of all properties that contain in the property name the
#!               string "param_" and all the values associated with the selected items
#!
#! @input url: The web address to make the request to.
#! @input auth_type: The type of authentication used by this operation when trying toexecute the request on the target
#!                   server. The authentication is not preemptive: a plain request not including authentication info
#!                   will be made and only when the server responds with a 'WWW-Authenticate' header, the client sends
#!                   the required headers. If the server needs no authentication but you specify one in this input the
#!                   request will still be valid but the client cannot choose the authentication method and there is no
#!                   fallback so you have to know which one you need. If the web application and proxy use different
#!                   authentication types, these must be specified as shown in the example.Default value: BasicValid
#!                   values: Basic, digest, ntlm, kerberos, any, anonymous, or a list of valid values separated by
#!                   comma.Example: Basic,digest
#!                   Optional
#! @input username: The user name used for authentication. For NTLM authentication, the required format is
#!                  "domain\user". If you only specify the user, a period is added in the format ".\user" so that a
#!                  local user on the target machine can be used. The username is required for all authentication
#!                  schemes except Kerberos.
#!                  Optional
#! @input password: The password used for authentication.
#!                  Optional
#! @input proxy_host: The proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: The proxy server port. Default value: 8080. Valid values: -1 and integer values greater than 0.
#!                    The value '-1' indicates that the proxy port is not set and the protocol default port will be
#!                    used. If the protocol is 'http' and the 'proxyPort' is set to '-1' then port '80' will be used.
#!                    Optional
#! @input proxy_username: The user name used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxyUsername input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no
#!                         trusted certification authority issued it.
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to
#!                                 "allow_all" to skip any checking. For the value "browser_compatible" the hostname
#!                                 verifier works the same way as Curl and Firefox. The hostname must match either the
#!                                 first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of
#!                                 the subject-alts. The only difference between "browser_compatible" and "strict" is
#!                                 that a wildcard (such as "*.foo.com") with "browser_compatible" matches all
#!                                 subdomains, including "a.b.foo.com".
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
#! @input query_params: The list containing query parameters to append to the URL. The names and the values must not be
#!                      URL encoded unless you specify queryParamsAreURLEncoded=true because if they are encoded and
#!                      queryParamsAreURLEncoded =false they will get double encoded.The separator between name-value
#!                      pairs is &. The query name will be separated from query value by =. Note that you need to URL
#!                      encode at least & to %26 and = to %3D and set queryParamsAreURLEncoded= true if you leave the
#!                      other special URL characters un-encoded they will be encoded by the HTTP Client. Examples:
#!                      parameterName1=parameterValue1&parameterName2=parameterValue2;
#!                      Optional
#!
#! @output return_code: The return code of the operation, 0 in case of success, -1 in case of failure
#! @output return_result: 
#! @output exception: In case of failure, the error message, otherwise empty.
#! @output final_list: The final list which is composed of all properties name and their values 
#!
#! @result SUCCESS: Generated description.
#! @result FAILURE: Generated description.
#!!#
########################################################################################################################

namespace: io.cloudslang.hcm.utils

operation: 
  name: get_subscription_params
  
  inputs: 
    - url    
    - auth_type:  
        required: false  
    - authType: 
        default: ${get('auth_type', '')}  
        required: false 
        private: true 
    - username:  
        required: false  
    - password:  
        required: false
        sensitive: true
    - proxy_host:  
        required: false  
    - proxyHost: 
        default: ${get('proxy_host', '')}  
        required: false 
        private: true 
    - proxy_port:  
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
        required: false  
    - trustAllRoots: 
        default: ${get('trust_all_roots', '')}  
        required: false 
        private: true 
    - x_509_hostname_verifier:  
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
    - query_params:  
        required: false  
    - queryParams: 
        default: ${get('query_params', '')}  
        required: false 
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-microfocus-hcm:1.0.0'
    class_name: 'io.cloudslang.content.hcm.actions.utils.GetSubscriptionParamsAction'
    method_name: 'execute'
  
  outputs: 
    - return_code: ${get('returnCode', '')} 
    - return_result: ${get('returnResult', '')} 
    - exception: ${get('exception', '')} 
    - final_list: ${get('finalList', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
