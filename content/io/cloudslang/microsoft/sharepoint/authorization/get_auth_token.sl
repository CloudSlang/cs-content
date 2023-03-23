#!!
#! @description: This operation retrieves the authorization token for Sharepoint using OAuth2.
#!
#! @input login_authority: The login authority input which can be found in the Azure portal, under the "OAuth 2.0 token
#!                         endpoint (v2)" section of the Endpoints menu of the desired application. The format accepted
#!                         by the input is "https://login.microsoftonline.com/TENANT_NAME/oauth2/v2.0/token"
#!                         where TENANT_NAME is your application tenant.
#! @input login_type: The Login method according to Microsoft application type. Chose "API" for applications with application permissions and "Native" for applications with delegated permissions.
#!                    Valid values: 'API', 'Native'
#!                    Default: 'Native'
#! @input scope: Resource URl for which the Authentication Token is intended.
#!                  Default: 'https://graph.microsoft.com/.default'
#!                  Optional
#! @input client_id: The Application ID assigned to your app when you registered it with Azure AD.
#! @input client_secret: Service Client Secret. This input is mutually exclusive with the "username" and "password"
#!                       inputs, depending on the value from "loginType". When "loginType" is set to "API", "clientId"
#!                       and "clientSecret" will be used. Otherwise, when "loginType" is set to "Native", "clientId",
#!                       "username" and "password" will be used.
#! @input proxy_host: Proxy server used to access the Sharepoint.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Sharepoint.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#!
#! @output return_result: This will contain the authorization token for Microsoft 365 Sharepoint.
#! @output auth_token: The authorization token.
#! @output return_code: 0 if success, -1 if failure.
#! @output exception: An error message in case there was an error while executing the request.
#!
#! @result SUCCESS: The token was generated with success.
#! @result FAILURE: There was an error while trying to retrieve the token.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.sharepoint.authorization

operation:
  name: get_auth_token

  inputs:
    - login_authority
    - loginAuthority:
        default: ${get('login_authority', '')}
        private: true
    - scope:
        required: false
        default: 'https://graph.microsoft.com/.default'
    - login_type:
        required: false
        default: 'Native'
    - loginType:
        default: ${get('login_type', '')}
        required: false
        private: true
    - client_id
    - clientId:
        default: ${get('client_id', '')}
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
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get('proxy_host', '')}
        required: false
        private: true
    - proxy_port:
        required: false
        default: '8080'
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
    gav: 'io.cloudslang.content:cs-sharepoint:0.0.1-RC14'
    class_name: 'io.cloudslang.content.sharepoint.actions.authorization.GetAuthorizationToken'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - exception: ${get('exception', '')}
    - return_code: ${get('returnCode', '')}
    - auth_token: ${get('authToken', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE
