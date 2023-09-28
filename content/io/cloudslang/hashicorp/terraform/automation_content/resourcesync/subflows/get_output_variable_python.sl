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
#! @description: This operation is used to get the output variable key name list.
#!
#! @input output_variable_list: The list of output variables.
#!
#! @output output_variable_key_list: The list of the output valiable keys.
#!
#! @result SUCCESS: The request was successfully executed.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows
operation:
  name: get_output_variable_python
  inputs:
    - output_variable_list
  python_action:
    use_jython: false
    script: |-
      import json


      def execute(output_variable_list):

          key = ' '
          output_variable_key_list = []
          y = json.loads(output_variable_list)
          for key in y.keys():
              output_variable_key_list.append(key)
          return {'output_variable_key_list': output_variable_key_list}
  outputs:
    - output_variable_key_list
  results:
    - SUCCESS
