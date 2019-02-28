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
#! @description: Retrieves the server ID from the response of the get_openstack_servers
#!               operation of a given server by name.
#!
#! @input server_body: response of get_openstack_servers operation
#! @input server_name: server name
#!
#! @output server_id: ID of specified server
#! @output return_result: was parsing was successful or not
#! @output return_code: 0 if parsing was successful, -1 otherwise
#! @output error_message: error message
#!
#! @result SUCCESS: parsing was successful (returnCode == '0')
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.openstack.utils

operation:
  name: get_server_id

  inputs:
    - server_body
    - server_name

  python_action:
    script: |
      try:
        import json
        servers = json.loads(server_body)['servers']
        matched_server = next(server for server in servers if server['name'] == server_name)
        server_id = matched_server['id']
        return_code = '0'
        return_result = 'Parsing successful.'
      except StopIteration:
        return_code = '-1'
        return_result = 'No servers in list'
      except  ValueError:
        return_code = '-1'
        return_result = 'Parsing error.'

  outputs:
    - server_id
    - return_result
    - return_code
    - error_message: ${return_result if return_code == '-1' else ''}

  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE
