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
#! @description: This operation converts extra_vars in the JSON format to String.
#!
#! @input extra_vars: Extra variables in JSON format.
#!
#! @output extra_variables: Extra variables with indented format.
#!!#
########################################################################################################################
namespace: test
operation:
  name: convert_json_to_string
  inputs:
    - extra_vars
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      import json
      def execute(extra_vars):
          json_body = {
          "extra_vars": json.dumps(extra_vars) }
          return{"extra_variables":json.dumps(extra_vars, indent=2)}

          # code goes here
      # you can add additional helper methods below.
  outputs:
    - extra_variables
  results:
    - SUCCESS
