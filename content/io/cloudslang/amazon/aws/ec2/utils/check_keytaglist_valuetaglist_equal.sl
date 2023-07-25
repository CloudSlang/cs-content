#   Copyright 2023 Open Text
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
#! @description: Checks if number of comma separated values in key tag list is equal to that of  value tag list.
#!
#! @input key_tag_list: The key tag list separated by comma(,)The length of the items KeysList must be equal with the length of the items ValuesList.
#!                      Optional
#! @input value_tag_list: The value_tag_list separated by comma(,)The length of the items KeysList must be equal with the length of the items ValuesList.
#!                        Optional
#!
#! @output return_result: If successful, returns a message
#! @output error_message: If there is an exception or error message.
#!
#! @result SUCCESS: volume_type and volume_size list matched
#! @result FAILURE: Something went wrong.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.utils
operation:
  name: check_keytaglist_valuetaglist_equal
  inputs:
    - key_tag_list:
        required: false
    - value_tag_list:
        required: false
  python_action:
    script: |-
      try:
          error_message = ""
          return_result = ""
          if(key_tag_list):
              if(len(key_tag_list.split(','))==len(value_tag_list.split(','))):
                  return_result = "key_tag_list and value_tag_list matched"
              else:
                  error_message = "Invalid input value. Number of comma separated values in key_tag_list should be equal to that of value_tag_list"
      except:
          error_message = "Invalid input value. Number of comma separated values in key_tag_list should be equal to that of value_tag_list"
  outputs:
    - return_result
    - error_message
  results:
    - SUCCESS: '${error_message==""}'
    - FAILURE

