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
#! @description: Builds a list of Marathon app names from the response of the get_apps_list operation.
#!
#! @input operation_response: response of get_apps_list operation
#!
#! @output app_list: list of app names
#! @output return_result: was parsing successful or not
#! @output return_code: 0 if parsing was successful, -1 otherwise
#! @output error_message: return_result if there was an error
#!
#! @result SUCCESS: parsing was successful (return_code == '0')
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.marathon

operation:
  name: parse_get_app_list

  inputs:
    - operation_response

  python_action:
    script: |
      try:
        import sys
        import json
        decoded = json.loads(operation_response)
        apps = decoded['apps']
        app_names = [app['id'] for app in apps]
        app_list = ",".join(app_names)
        return_code = '0'
        return_result = 'Parsing successful.'
      except:
        return_code = '-1'
        return_result = 'Parsing error. error ' + sys.exc_info()[0]

  outputs:
    - app_list
    - return_result
    - return_code
    - error_message: ${return_result if return_code == '-1' else ''}

  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE
