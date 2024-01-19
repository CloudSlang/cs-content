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
#! @description: Checks if number of comma separated values in tag name list is equal to that of tag value list.
#!
#! @input tag_name_list: The list of tag_name for the tags.
#! @input tag_value_list: The list of tag_value for the given tag_name.
#!
#! @output return_result: If successful, returns a message
#! @output error_message: If there is an exception or error message.
#!
#! @result SUCCESS: Tag key list and tag value list matched
#! @result FAILURE: Something went wrong.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.utils
operation:
  name: check_tagnames_tagvalues_equal
  inputs:
    - tag_name_list:
        required: false
    - tag_value_list:
        required: false
  python_action:
    script: |-
      try:
          error_message = ""
          return_result = ""
          if(tag_name_list):
              if(len(tag_name_list.split(','))==len(tag_value_list.split(','))):
                  return_result = "tag_name_list and tag_value_list matched"
              else:
                  error_message = "Invalid input value. Number of comma separated values in tag_name_list should be equal to that of tag_value_list"
      except:
          error_message = "Invalid input value. Number of comma separated values in tag_name_list should be equal to that of tag_value_list"
  outputs:
    - return_result
    - error_message
  results:
    - SUCCESS: '${error_message==""}'
    - FAILURE

