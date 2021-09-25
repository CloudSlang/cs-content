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
#! @description: Get the authorization token for Azure Active Directory.
#!
#! @input login_type: Login method according to application type.
#!                    Valid values: 'API', 'Native'
#!                    Default: 'API'
#!                    Optional
#! @input client_id: Service Client ID.
#! @input client_secret: Service Client Secret.
#!                       Optional
#! @input username: Azure Active Directory username.
#!                  Optional
#! @input password: Azure Active Directory password.
#!                  Optional
#! @input login_authority: The authority URL. Usually, the format for this input
#!                         is:
#!'https://login.windows.net/TENANT_NAME/oauth2/token' where TENANT_NAME is your
#!                         application
#!tenant.
#! @input resource: The resource URL.
#!Default: 'https://graph.microsoft.com'
#!                  Optional
#! @input proxy_host: Proxy server used to access the Azure Active Directory service.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Azure Active Directory service.Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#!
#! @output return_result: The authorization token for Azure Active Directory.
#! @output return_code: 0 if success, -1 if failure.
#! @output auth_token: Generated authentication token.
#! @output auth_token_type: The authentication token type.
#! @output exception: An error message in case there was an error while generating the token.
#!
#! @result SUCCESS: Token generated successfully.
#! @result FAILURE: There was an error while trying to retrieve token.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoftAD.utils

operation: 
  name: get_authorization_token
  
  inputs: 
    - login_type:  
        required: false  
    - loginType: 
        default: ${get('login_type', '')}  
        required: false 
        private: true 
    - client_id    
    - clientId: 
        default: ${get('client_id', '')}  
        required: false 
        private: true 
    - client_secret:  
        required: false  
        sensitive: true
    - clientSecret: 
        default: ${get('client_secret', '')}  
        required: false 
        private: true 
        sensitive: true
    - username:  
        required: false  
    - password:  
        required: false  
        sensitive: true
    - login_authority    
    - loginAuthority: 
        default: ${get('login_authority', '')}  
        required: false 
        private: true 
    - resource:  
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
    
  java_action: 
    gav: 'io.cloudslang.content:cs-microsoft-ad:1.0.0-RC2'
    class_name: 'io.cloudslang.content.microsoftAD.actions.utils.GetAuthorizationToken'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - return_code: ${get('returnCode', '')} 
    - auth_token: ${get('authToken', '')} 
    - auth_token_type: ${get('authTokenType', '')} 
    - exception: ${get('exception', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE