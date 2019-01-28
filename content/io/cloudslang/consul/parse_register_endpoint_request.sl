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
#! @description: Creates a JSON for request to register a new endpoint.
#!
#! @input node: Node name.
#! @input address: Node host.
#!                 Default: ''
#! @input datacenter: Optional - Matched to that of agent.
#!                    Default: ''
#! @input service: Optional - If Service key is provided, then service will also be registered.
#!                 Default: ''
#! @input check: Optional - If the Check key is provided, then a health check will also be registered.
#!               Default: ''
#!
#! @output return_result: Response of the operation.
#! @output error_message: Return_result if there was an error.
#! @output return_code: '0' if parsing was successful, '-1' otherwise.
#! @output json_request: JSON request for registering endpoint.
#!
#! @result SUCCESS: Parsing was successful (return_code == '0').
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.consul

operation:
  name: parse_register_endpoint_request

  inputs:
    - node
    - address:
        default: ''
        required: false
    - datacenter:
        default: ''
        required: false
    - service:
        default: ''
        required: false
    - check:
        default: ''
        required: false

  python_action:
    script: |
      try:
        import json
        data = {}
        data['Node'] = node
        if address != '':
          data['Address'] = address
        if datacenter != '':
          data['Datacenter'] = datacenter
        if service != '':
          data['Service'] = json.loads(service)
        if check != '':
          data['Check'] = json.loads(check)
        json_request = json.dumps(data)
        return_code = '0'
        return_result = 'Parsing successful.'
      except:
        return_code = '-1'
        return_result = 'Parsing error or key does not exist.'

  outputs:
    - return_result
    - error_message: ${return_result if return_code == '-1' else ''}
    - return_code
    - json_request

  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE
