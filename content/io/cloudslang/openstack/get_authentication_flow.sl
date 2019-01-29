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
#! @description: Authenticates an OpenStack machine.
#!
#! @input host: OpenStack machine host.
#! @input identity_port: Optional - Port used for OpenStack authentication.
#!                       Default: '5000'
#! @input username: OpenStack username.
#! @input password: OpenStack password.
#! @input tenant_name: name of the project on OpenStack.
#! @input proxy_host: Optional - Proxy server used to access OpenStack services.
#! @input proxy_port: Optional - Proxy server port used to access OpenStack services.
#! @input proxy_username: Optional - Username used when connecting to proxy.
#! @input proxy_password: Optional - Proxy server password associated with <proxy_username> input value.
#!
#! @output return_result: Response of last operation that was executed.
#! @output error_message: Error message of operation that failed.
#! @output token: Authentication token.
#! @output tenant_id: Tenant ID.
#!
#! @result SUCCESS: Authentication on OpenStack host was successful.
#! @result GET_AUTHENTICATION_TOKEN_FAILURE: Authentication token cannot be obtained from authentication call response.
#! @result GET_TENANT_ID_FAILURE: Tenant_id corresponding to tenant_name
#!                                cannot be obtained from authentication call response.
#! @result GET_AUTHENTICATION_FAILURE: Authentication call failed.
#!!#
########################################################################################################################

namespace: io.cloudslang.openstack

imports:
  openstack: io.cloudslang.openstack
  json: io.cloudslang.base.json

flow:
  name: get_authentication_flow

  inputs:
    - host
    - identity_port: '5000'
    - username
    - password:
        sensitive: true
    - tenant_name
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true

  workflow:
    - authentication_call:
        do:
          openstack.get_authentication:
            - host
            - identity_port
            - username
            - password
            - tenant_name
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - return_result
          - return_code
          - error_message
        navigate:
          - SUCCESS: get_authentication_token
          - FAILURE: GET_AUTHENTICATION_FAILURE

    - get_authentication_token:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: 'access,token,id'
        publish:
          - token: ${return_result}
          - error_message
        navigate:
          - SUCCESS: get_tenant_id
          - FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE

    - get_tenant_id:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: 'access,token,tenant,id'
        publish:
          - tenant_id: ${return_result}
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: GET_TENANT_ID_FAILURE

  outputs:
    - return_result
    - error_message
    - token:
        value: ${token}
        sensitive: true
    - tenant_id

  results:
    - SUCCESS
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - GET_AUTHENTICATION_FAILURE
