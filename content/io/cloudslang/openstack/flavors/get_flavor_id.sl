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
#! @description: Retrieves the flavor ID from the response of the list_flavors operation of a given flavor by name.
#!
#! @input flavor_body: response of list_flavors operation
#! @input flavor_name: flavor name
#!
#! @output flavor_id: ID of specified flavor
#! @output return_result: was parsing was successful or not
#! @output return_code: '0' if parsing was successful, '-1' otherwise
#! @output error_message: error message
#!
#! @result SUCCESS: parsing was successful (return_code == '0')
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.openstack.flavors

operation:
  name: get_flavor_id

  inputs:
    - flavor_body
    - flavor_name

  python_action:
    script: |
      try:
        import json
        flavors = json.loads(flavor_body)['flavors']
        matched_flavor = next(flavor for flavor in flavors if flavor['name'] == flavor_name)
        flavor_id = matched_flavor['id']
        return_code = '0'
        return_result = 'Parsing successful.'
      except StopIteration:
        return_code = '-1'
        return_result = 'No flavors in list'
      except  ValueError:
        return_code = '-1'
        return_result = 'Parsing error.'

  outputs:
    - flavor_id
    - return_result
    - return_code
    - error_message: ${return_result if return_code == '-1' else ''}

  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE
