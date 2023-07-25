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
#! @description: Checks if number of comma separated values in label keys is equal to that of label values.
#!
#! @input label_keys: The list of label_keys.
#! @input label_values: The list of label_values.
#!
#! @output return_result: If successful, returns a message
#! @output error_message: If there is an exception or error message.
#!
#! @result SUCCESS: Label keys and label values matched
#! @result FAILURE: Something went wrong.
#!!#
########################################################################################################################

namespace: io.cloudslang.google.compute_v2.utils
operation:
  name: check_label_keys_values_equal
  inputs:
    - label_keys:
        required: false
    - label_values:
        required: false
  python_action:
    script: |-
      try:
          error_message = ""
          return_result = ""
          if(label_keys):
              if(len(label_keys.split(','))==len(label_values.split(','))):
                  return_result = "label_keys and label_values matched"
              else:
                  error_message = "Invalid input value. Number of comma separated values in label_keys should be equal to that of label_values"
      except:
          error_message = "Invalid input value. Number of comma separated values in label_keys should be equal to that of label_values"
  outputs:
    - return_result
    - error_message
  results:
    - SUCCESS: '${error_message==""}'
    - FAILURE

