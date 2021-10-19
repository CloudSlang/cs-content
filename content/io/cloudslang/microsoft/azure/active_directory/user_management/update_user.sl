#   (c) Copyright 2021 Micro Focus, L.P.
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
#! @description: Updates user's properties.
#!               Note: In order to check all the application permissions and the prerequisites required to run this
#!               operation please check the "Use" section of the content pack's release notes.
#!
#! @input auth_token: Token used to authenticate to Azure Active Directory.
#! @input user_principal_name: The user principal name. This input is mutually exclusive with the user_id input.
#!                             Example: someuser@contoso.com
#!                             Optional
#! @input user_id: The ID of the user to perform the action on. This input is mutually exclusive with the
#!                 user_principal_name input.
#!                 Optional
#! @input body: Full json body if the user wants to set additional properties. This input is mutually exclusive with the
#!              account_enabled, display_name, on_premises_immutable_id, mail_nickname, force_change_password_next_sign_in,
#!              password and updated_user_principal_name inputs.
#!              Optional
#! @input account_enabled: This property must be set to 'true' if the account is enabled otherwise, 'false'. This property
#!                         is required when a user is created. This input is mutually exclusive with the body input and
#!                         will be ignored if the body is populated.
#!                         Optional
#! @input display_name: The name to display in the address book for the user. This property is required when a user is
#!                      created and it cannot be cleared during updates. This input is mutually exclusive with the
#!                      body input and will be ignored if the body is populated.
#!                      Optional
#! @input on_premises_immutable_id: This property is used to associate an on-premises Active Directory user account to
#!                                  their Azure AD user object. This property must be specified when creating a new user
#!                                  account in the Graph if you are using a federated domain for the user’s user_principal_name
#!                                  (UPN) property. The $ and _ characters cannot be used when specifying this property.
#!                                  This input is mutually exclusive with the body input and will be ignored if the body
#!                                  is populated.
#!                                  Optional
#! @input mail_nickname: The mail alias for the user. This property must be specified when the user is created. This input
#!                       is mutually exclusive with the body input and will be ignored if the body is populated.
#!                       Optional
#! @input force_change_password_next_sign_in: In case the value for the input is 'true', the user must change the password
#!                                            on the next login. This input is mutually exclusive with the body input and
#!                                            will be ignored if the body is populated.
#!                                            NOTE: For Azure B2C tenants, set this input to 'false' and instead use
#!                                            custom policies and user flows to force password reset at first sign in.
#!                                            Optional
#! @input password: The password for the user. This property is required when a user is created. The password must satisfy
#!                  minimum requirements as specified by the user’s passwordPolicies property. By default, a strong password
#!                  is required. This input is mutually exclusive with the body input and will be ignored if the body is
#!                  populated.
#!                  Optional
#! @input updated_user_principal_name: The new user principal name. This input is mutually exclusive with the body input
#!                                     and will be ignored if the body is populated.
#!                                     Example: someuser@contoso.com
#!                                     Optional
#! @input proxy_host: Proxy server used to access the Azure Active Directory service.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Azure Active Directory service.
#!                    Default: 8080
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no
#!                         trusted certification authority issued it.
#!                         Default: false
#!                         Valid values: true, false
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to
#!                                 "allow_all" to skip any checking. For the value "browser_compatible" the hostname
#!                                 verifier works the same way as Curl and Firefox. The hostname must match either the
#!                                 first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of
#!                                 the subject-alts. The only difference between "browser_compatible" and "strict" is
#!                                 that a wildcard (such as "*.foo.com") with "browser_compatible" matches all
#!                                 subdomains, including "a.b.foo.com".
#!                                 Default: strict
#!                                 Valid values: strict, browser_compatible, allow_all
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that
#!                        you expect to communicate with, or from Certificate Authorities that you trust to identify
#!                        other parties.  If the protocol (specified by the 'url') is not 'https' or if trust_all_roots is
#!                        'true' this input is ignored. Format: Java KeyStore (JKS).
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file. If trust_all_roots is false and trust_keystore
#!                        is empty, the default trust_password will be supplied.
#!                        Default: changeit
#!                        Optional
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A connect_timeout value of '0'
#!                         represents an infinite timeout.
#!                         Default: 0
#!                         Optional
#! @input socket_timeout: The timeout for waiting for data (a maximum period inactivity between two consecutive data
#!                        packets), in seconds. A socket_timeout value of '0' represents an infinite timeout.
#!                        Default: 0
#!                        Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls. If
#!                    keep_alive is false, the already open connection will be used and after execution it will close it.
#!                    Default: false
#!                    Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.
#!                                   Default: 2
#!                                   Optional
#! @input connections_max_total: The maximum limit of connections in total.
#!                               Default: 20
#!                               Optional
#!
#! @output return_result: If successful, this method returns 204 No Content response code. It does not return anything
#!                        in the response body.
#! @output return_code: 0 if success, -1 if failure.
#! @output status_code: The HTTP status code for Azure API request, successful if between 200 and 300.
#! @output exception: The error message in case of failure.
#!
#! @result SUCCESS: The user's properties were updated successfully.
#! @result FAILURE: There was an error while trying to update user's properties.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.active_directory.user_management

operation: 
  name: update_user
  
  inputs: 
    - auth_token    
    - authToken: 
        default: ${get('auth_token', '')}  
        required: false 
        private: true
    - user_principal_name:
        required: false
    - userPrincipalName:
        default: ${get('user_principal_name', '')}
        required: false
        private: true
    - user_id:
        required: false
    - userId:
        default: ${get('user_id', '')}
        required: false
        private: true
    - body:
        required: false
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
    - mail_nickname:
        required: false
    - mailNickname:
        default: ${get('mail_nickname', '')}
        required: false
        private: true
    - on_premises_immutable_id:  
        required: false  
    - onPremisesImmutableId: 
        default: ${get('on_premises_immutable_id', '')}  
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
    - updated_user_principal_name:
        required: false  
    - updatedUserPrincipalName:
        default: ${get('updated_user_principal_name', '')}
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
        default: 'changeit'
        required: false  
        sensitive: true
    - trustPassword: 
        default: ${get('trust_password', '')}  
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
    gav: 'io.cloudslang.content:cs-microsoft-ad:1.0.0-RC19'
    class_name: 'io.cloudslang.content.microsoftAD.actions.userManagement.UpdateUser'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - return_code: ${get('returnCode', '')} 
    - status_code: ${get('statusCode', '')}
    - exception: ${get('exception', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
