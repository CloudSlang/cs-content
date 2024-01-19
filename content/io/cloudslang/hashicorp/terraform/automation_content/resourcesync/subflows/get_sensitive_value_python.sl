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
#! @description: This operation is used to get the sensitive variable value from the list of key names and values.
#!
#! @input input_results_keyname: The list of key names.
#! @input input_keyname_keyvalue_list: The list of key names and key values.
#! @input original_keyname: The list of desired key names.
#!
#! @output retrieved_keyname: Key name.
#! @output retrieved_keyvalue: Key value.
#!
#! @result SUCCESS: The request was successfully executed.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows
operation:
  name: get_sensitive_value_python
  inputs:
    - input_results_keyname
    - input_keyname_keyvalue_list
    - original_keyname
  python_action:
    use_jython: false
    script: |-
      import ast
      def execute(input_results_keyname, input_keyname_keyvalue_list, original_keyname):
          output = ' '
          input_results_keyname = ast.literal_eval(input_results_keyname)
          input_keyname_keyvalue_list = ast.literal_eval(input_keyname_keyvalue_list)
          for retrieved_keyname in input_results_keyname:
              if retrieved_keyname == original_keyname:
                  output = retrieved_keyname
                  value = input_keyname_keyvalue_list[retrieved_keyname]
          return {"retrieved_keyname": output, "retrieved_keyvalue": value}
  outputs:
    - retrieved_keyname
    - retrieved_keyvalue
  results:
    - SUCCESS
