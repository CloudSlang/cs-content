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
#! @description: Checks if an OpenStack server exists.
#!
#! @input host: OpenStack machine host.
#! @input identity_port: Optional - Port used for OpenStack authentication.
#!                       Default: '5000'
#! @input compute_port: Optional - Port used for OpenStack computations.
#!                      Default: '8774'
#! @input username: OpenStack username.
#! @input password: OpenStack password.
#! @input tenant_name: name of OpenStack project.
#! @input proxy_host: Optional - Proxy server used to access web site.
#! @input proxy_port: Optional - Proxy server port.
#! @input server_name: Server name to check.
#!
#! @output return_result: Response of last operation executed.
#! @output error_message: Error message of operation that failed.
#!
#! @result SUCCESS: The OpenStack server (instance) exists.
#! @result GET_AUTHENTICATION_TOKEN_FAILURE: Authentication token cannot be obtained from authentication call response.
#! @result GET_TENANT_ID_FAILURE: Tenant_id corresponding to tenant_name
#!                                cannot be obtained from authentication call response.
#! @result GET_AUTHENTICATION_FAILURE: Authentication call fails.
#! @result GET_SERVERS_FAILURE: Call for list OpenStack servers (instances) fails.
#! @result EXTRACT_SERVERS_FAILURE: List of OpenStack servers (instances) could not be retrieved.
#! @result CHECK_SERVER_FAILURE: Check for specified OpenStack server (instance) fails.
#!!#
########################################################################################################################

namespace: io.cloudslang.openstack

imports:
  utils: io.cloudslang.openstack.utils
  servers: io.cloudslang.openstack.servers

flow:
  name: validate_server_exists

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
    - server_name

  workflow:
    - get_server_list:
        do:
          servers.list_servers:
            - host
            - identity_port
            - compute_port
            - username
            - password
            - tenant_name
            - proxy_host
            - proxy_port
        publish:
          - server_list
          - return_result
          - error_message
        navigate:
          - SUCCESS: check_server
          - GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          - GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          - GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          - GET_SERVERS_FAILURE: GET_SERVERS_FAILURE
          - EXTRACT_SERVERS_FAILURE: EXTRACT_SERVERS_FAILURE

    - check_server:
        do:
          utils.check_server:
            - server_to_find: ${server_name}
            - server_list
        publish:
          - return_result
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_SERVER_FAILURE

  outputs:
    - return_result
    - error_message

  results:
    - SUCCESS
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - GET_AUTHENTICATION_FAILURE
    - GET_SERVERS_FAILURE
    - EXTRACT_SERVERS_FAILURE
    - CHECK_SERVER_FAILURE
