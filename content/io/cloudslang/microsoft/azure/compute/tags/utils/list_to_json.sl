#   (c) Copyright 2022 Micro Focus, L.P.
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
#########################################################################################################################
#!!
#! @description: Python operation to map the comma separated values into JSON
#!
#! @input keys: The list of keys separated by commas
#! @input values: The values that have to mapped to the keys
#!
#! @output result: The return result which have the json value (keys and values mapped)
#!
#! @result SUCCESS: The values were successfully returned.
#!!#
########################################################################################################################
namespace: io.cloudslang.microsoft.azure.compute.tags.utils
operation:
  name: list_to_json
  inputs:
    - keys
    - values
  python_action:
    use_jython: false
    script: |-
      def execute(keys,values):
          keys=keys.split(',')
          values=values.split(',')
          result = dict(zip(keys,values))
          return {"result":result}
  outputs:
    - result
  results:
    - SUCCESS

