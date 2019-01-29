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
#! @description: Parses a JSON input and retrieves the specific details of the resource identified by <key_name>.
#!
#! @input json_input: Response of get resources operation (get_applications, get_services, get_spaces, get_users).
#! @input key_name: Name of resource to get details on.
#!
#! @output return_result: The parsing was successful or not.
#! @output error_message: An error message in case there was an error or return_code is different than '0'.
#! @output return_code: '0' if parsing was successful, '-1' otherwise.
#! @output resource_guid: GUID of resource identified by <key_name>.
#! @output resource_url: URL of resource identified by <key_name>.
#! @output resource_created_at: Creation date of the resource identified by <key_name>.
#! @output resource_updated_at: Last updated date of the resource identified by <key_name>.
#!
#! @result SUCCESS: The operation executed successfully and the 'return_code' is 0.
#! @result FAILURE: The operation could not be executed or the value of the 'return_code' is different than 0.
#!!#
########################################################################################################################

namespace: io.cloudslang.stackato.utils

operation:
  name: get_resource_details

  inputs:
    - json_input
    - key_name

  python_action:
    script: |
      try:
        import json
        decoded = json.loads(json_input)
        for i in decoded['resources']:
          if i['entity']['name'] == key_name:
            resource_guid = "key_name + '_guid'"
            resource_url = "key_name + '_url"
            resource_created_at = "key_name + '_created_at"
            resource_updated_at = "key_name + '_updated_at"
            resource_guid = i['metadata']['guid']
            resource_url = i['metadata']['url']
            resource_created_at = i['metadata']['created_at']
            resource_updated_at = i['metadata']['updated_at']
        return_code = '0'
        return_result = 'Parsing successful.'
      except Exception as ex:
        return_code = '-1'
        return_result = ex

  outputs:
    - return_result
    - error_message: ${return_result if return_code == '-1' else ''}
    - return_code
    - resource_guid
    - resource_url
    - resource_created_at
    - resource_updated_at

  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE
