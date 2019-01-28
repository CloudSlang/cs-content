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
#! @description: Parses a JSON input and retrieves a list of user names.
#!
#! @input json_input: Response of get_users flow.
#!
#! @output return_result: The parsing was successful or not.
#! @output error_message: An error message in case there was an error or return_code is different than '0'
#! @output return_code: '0' if parsing was successful, '-1' otherwise.
#! @output usernames_list: List with all user names.
#!
#! @result SUCCESS: The operation executed successfully and the 'return_code' is 0.
#! @result FAILURE: The operation could not be executed or the value of the 'return_code' is different than 0.
#!!#
########################################################################################################################

namespace: io.cloudslang.stackato.utils

operation:
  name: get_usernames_list

  inputs:
    - json_input

  python_action:
    script: |
      try:
        import json
        decoded = json.loads(json_input)
        usernames_list = []
        for i in decoded['resources']:
          if i['entity']['username']:
            username = i['entity']['username']
            usernames_list.append(username)
        return_code = '0'
        return_result = 'Parsing successful.'
      except Exception as ex:
        return_code = '-1'
        return_result = ex

  outputs:
    - return_result
    - error_message: ${return_result if return_code == '-1' else ''}
    - return_code
    - usernames_list

  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE
