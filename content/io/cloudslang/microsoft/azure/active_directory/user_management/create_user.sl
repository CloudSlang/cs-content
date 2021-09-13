########################################################################################################################
#!!
#! @description: Create a new user. The request body contains the user to create. At a minimum, you must specify the
#!               required properties for the user. You can optionally specify any other writable properties.
#!
#! @input auth_token: Authentication token
#! @input account_enabled: true if the account is enabled; otherwise, false.
#!                         Optional
#! @input display_name: Required if body not set - The name to display in the address book for the user.
#!                      Optional
#! @input on_premises_immutable_id: Only needs to be specified when creating a new user account if you are using a
#!                                  federated domain for the user's userPrincipalName (UPN) property.
#!                                  Optional
#! @input mail_nickname: Required if body not set -The mail alias for the user.
#!                       Optional
#! @input force_change_password_next_sign_in: true if the user must change her password on the next login; otherwise
#!                                            false. If not set, default is false. NOTE: For Azure B2C tenants, set to
#!                                            false and instead use custom policies and user flows to force password
#!                                            reset at first sign in.
#!                                            Optional
#! @input password: Required if body not set -The password for the user. This property is required when a user is
#!                  created. It can be updated, but the user will be required to change the password on the next login.
#!                  The password must satisfy minimum requirements as specified by the user’s passwordPolicies property.
#!                  By default, a strong password is required.
#!                  Optional
#! @input user_principal_name: Required if body not set -The user principal name (someuser@contoso.com).
#!                             Optional
#! @input body: Full json body if the user wants to set additional properties. All the other inputs are ignored if the
#!              body is given.
#!              Optional
#! @input proxy_host: Proxy server used to access the Azure Active Directory service.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Azure Active Directory service.Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
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
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.
#!                         Optional
#! @input socket_timeout: The timeout for waiting for data (a maximum period inactivity between two consecutive data
#!                        packets), in seconds. A socketTimeout value of '0' represents an infinite timeout.
#!                        Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls. If
#!                    keepAlive is false, the already open connection will be used and after execution it will close it.
#!                    Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.
#!                                   Optional
#! @input connections_max_total: The maximum limit of connections in total.
#!                               Optional
#! @input response_character_set: The maximum limit of connections in total.
#!                                Optional
#!
#! @output return_result: If successful, returns the complete API response.
#! @output return_code: 0 if success, -1 otherwise.
#! @output status_code: The HTTP status code for Azure API request, successful if between 200 and 300.
#!
#! @result SUCCESS: SUCCESS_DESC
#! @result FAILURE: FAILURE_DESC
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.active_directory.user_management

operation: 
  name: create_user
  
  inputs: 
    - auth_token    
    - authToken: 
        default: ${get('auth_token', '')}  
        required: false 
        private: true 
    - account_enabled:  
        required: false  
    - accountEnabled: 
        default: ${get('account_enabled', '')}  
        required: false 
        private: true 
    - display_name:  
        required: false  
    - displayName: 
        default: ${get('display_name', '')}  
        required: false 
        private: true 
    - on_premises_immutable_id:  
        required: false  
    - onPremisesImmutableId: 
        default: ${get('on_premises_immutable_id', '')}  
        required: false 
        private: true 
    - mail_nickname:  
        required: false  
    - mailNickname: 
        default: ${get('mail_nickname', '')}  
        required: false 
        private: true 
    - force_change_password_next_sign_in:  
        required: false  
    - forceChangePasswordNextSignIn: 
        default: ${get('force_change_password_next_sign_in', '')}  
        required: false 
        private: true 
    - password:  
        required: false  
        sensitive: true
    - user_principal_name:  
        required: false  
    - userPrincipalName: 
        default: ${get('user_principal_name', '')}  
        required: false 
        private: true 
    - body:  
        required: false  
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
    - response_character_set:  
        required: false  
    - responseCharacterSet: 
        default: ${get('response_character_set', '')}  
        required: false 
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-microsoft-ad:1.1.9-SNAPSHOT'
    class_name: 'io.cloudslang.content.microsoftAD.actions.userManagement.CreateUser'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - return_code: ${get('returnCode', '')} 
    - status_code: ${get('statusCode', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
