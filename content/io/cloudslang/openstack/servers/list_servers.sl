#   Copyright 2024 Open Text
#   This program and the accompanying materials
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
#! @description: Retrieves a list of servers on an OpenStack machine.
#!
#! @input host: OpenStack machine host
#! @input identity_port: Optional - port used for OpenStack authentication
#!                       Default: 5000
#! @input compute_port: Optional - port used for OpenStack computations
#!                      Default: 8774
#! @input username: OpenStack username
#! @input password: OpenStack password
#! @input tenant_name: name of project on OpenStack
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#!
#! @output server_list: list of server names
#! @output return_result: response of last operation executed
#! @output error_message: error message of operation that failed
#!
#! @result SUCCESS: list of OpenStack servers (instances) was successfully retrieved
#! @result GET_AUTHENTICATION_TOKEN_FAILURE: authentication token cannot be obtained from authentication call response
#! @result GET_TENANT_ID_FAILURE: tenant_id corresponding to tenant_name cannot
#!                                be obtained from authentication call response
#! @result GET_AUTHENTICATION_FAILURE: authentication call failed
#! @result GET_SERVERS_FAILURE: call for list OpenStack servers (instances) failed
#! @result EXTRACT_SERVERS_FAILURE: list of OpenStack servers (instances) could not be retrieved
#!!#
########################################################################################################################

namespace: io.cloudslang.openstack.servers

imports:
  openstack: io.cloudslang.openstack
  utils: io.cloudslang.openstack.utils
  servers: io.cloudslang.openstack.servers

flow:
  name: list_servers

  inputs:
    - host
    - identity_port: '5000'
    - compute_port: '8774'
    - username
    - password:
        sensitive: true
    - tenant_name
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - authentication:
        do:
          openstack.get_authentication_flow:
            - host
            - identity_port
            - username
            - password
            - tenant_name
            - proxy_host
            - proxy_port
        publish:
          - token
          - tenant_id
          - return_result
          - error_message
        navigate:
          - SUCCESS: get_servers
          - GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          - GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          - GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE

    - get_servers:
        do:
          servers.get_servers:
            - host
            - compute_port
            - token
            - tenant_id
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - error_message
          - status_code
        navigate:
          - SUCCESS: extract_servers
          - FAILURE: GET_SERVERS_FAILURE

    - extract_servers:
        do:
          utils.extract_object_list_from_json_response:
            - response_body: ${return_result}
            - object_name: 'servers'
        publish:
          - object_list
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: EXTRACT_SERVERS_FAILURE

  outputs:
    - server_list: ${object_list}
    - return_result
    - error_message

  results:
    - SUCCESS
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - GET_AUTHENTICATION_FAILURE
    - GET_SERVERS_FAILURE
    - EXTRACT_SERVERS_FAILURE
