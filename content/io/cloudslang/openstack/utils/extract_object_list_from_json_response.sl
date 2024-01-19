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
#! @description: Builds a list of object names from the response of the OpenStack GET operations.
#!
#! @input response_body: response of a GET operation
#! @input object_name: name of object contained in the list
#!
#! @output object_list: comma separated list of object names
#! @output return_result: was parsing was successful or not
#! @output return_code: 0 if parsing was successful, -1 otherwise
#! @output error_message: return_result if there was an error
#!
#! @result SUCCESS: parsing was successful (return_code == '0')
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.openstack.utils

operation:
  name: extract_object_list_from_json_response

  inputs:
    - response_body
    - object_name

  python_action:
    script: |
      try:
        import json
        json_list = json.loads(response_body)[object_name]

        if object_name == 'keypairs':
            object_names = [object['keypair']['name'] for object in json_list]
        else:
            object_names = [object['name'] for object in json_list]

        object_list = ",".join(object_names)
        return_code = '0'
        return_result = 'Parsing successful.'
      except:
        return_code = '-1'
        return_result = 'Parsing error.'

  outputs:
    - object_list
    - return_result
    - return_code
    - error_message: ${return_result if return_code == '-1' else ''}

  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE
