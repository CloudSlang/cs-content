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
#! @description: Authenticates on Helion Development Platform / Stackato machine and retrieves the authentication token.
#!
#! @input host: Helion Development Platform / Stackato host.
#! @input username: Helion Development Platform / Stackato username.
#! @input password: Helion Development Platform / Stackato password.
#! @input proxy_host: Optional - Proxy server used to access Helion Development Platform / Stackato services.
#! @input proxy_port: Optional - Proxy server port used to access Helion Development Platform / Stackato services.
#!                    Default: '8080'
#! @input proxy_username: Optional - User name used when connecting to proxy.
#! @input proxy_password: Optional - Proxy server password associated with <proxy_username> input value.
#!
#! @output return_result: Response of last operation that was executed.
#! @output error_message: Error message of operation that failed.
#! @output token: Authentication token.
#!
#! @result SUCCESS: Authentication on Helion Development Platform / Stackato host was successful.
#! @result GET_AUTHENTICATION_FAILURE: Authentication call failed.
#! @result GET_AUTHENTICATION_TOKEN_FAILURE: Authentication token could not be obtained from authentication call response.
#!!#
########################################################################################################################

namespace: io.cloudslang.stackato

imports:
  rest: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: get_authentication

  inputs:
    - host
    - username
    - password:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true

  workflow:
    - http_client_action_post:
        do:
          rest.http_client_post:
            - url: ${'https://' + host + '/uaa/oauth/token'}
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - headers: 'Authorization: Basic Y2Y6'
            - query_params: ${'username=' + username + '&password=' + password + '&grant_type=password'}
            - content_type: 'application/json'
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: get_authentication_token
          - FAILURE: GET_AUTHENTICATION_FAILURE

    - get_authentication_token:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "access_token"
        publish:
          - token: ${return_result}
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE

  outputs:
    - return_result
    - error_message
    - token:
        value: ${token}
        sensitive: true

  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
