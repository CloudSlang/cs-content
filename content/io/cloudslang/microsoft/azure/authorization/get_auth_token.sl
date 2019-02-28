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
#! @description: This operation retrieves the authentication Bearer token for Azure.
#!
#! @input username: The username to be used to authenticate to the Azure Management Service.
#! @input password: The password to be used to authenticate to the Azure Management Service.
#! @input client_id: Optional - Service Client ID.
#! @input login_authority: Optional - URL of the login authority that should be used when retrieving the Authentication Token.
#!                         Default: 'https://sts.windows.net/common'
#! @input resource: Optional - Resource URl for which the Authentication Token is intended.
#!                  Default: 'https://management.azure.com/'
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - user name used when connecting to the proxy.
#! @input proxy_password: Optional - proxy server password associated with the <proxy_username> input value.
#!
#! @output auth_token: The authorization Bearer token for Azure.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output exception: An error message in case there was an error while generating the Bearer token.
#!
#! @result SUCCESS: Bearer token generated successfully.
#! @result FAILURE: There was an error while trying to retrieve Bearer token.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.authorization

operation:
  name: get_auth_token

  inputs:
    - username
    - password:
        sensitive: true
    - client_id:
        required: false
    - clientId:
        default: ${get("client_id", "")}
        required: false
        private: true
    - login_authority:
        default: 'https://sts.windows.net/common'
        required: false
    - loginAuthority:
        default: ${get("login_authority", "")}
        required: false
        private: true
    - resource:
        default: 'https://management.azure.com/'
        required: false
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        required: false
        private: true
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get("proxy_port", "8080")}
        required: false
        private: true
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get("proxy_username", "")}
        required: false
        private: true
    - proxy_password:
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get("proxy_password", "")}
        required: false
        private: true
        sensitive: true

  java_action:
    gav: 'io.cloudslang.content:cs-azure:0.0.7'
    class_name: io.cloudslang.content.azure.actions.utils.GetAuthorizationToken
    method_name: execute

  outputs:
    - auth_token: ${returnResult}
    - return_code: ${returnCode}
    - exception

  results:
      - SUCCESS: ${returnCode == '0'}
      - FAILURE

