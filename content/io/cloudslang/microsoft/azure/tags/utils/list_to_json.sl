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
########################################################################################################################
#!!
#! @description: Maps comma separated values to JSON
#!
#! @input tag_name_list: The list of tag_names separated by commas
#! @input tag_value_list: The values that have to be mapped to the tag_names
#!
#! @output result: If successful, returns the json (tag_names and tag_values mapped)
#!
#! @result SUCCESS: The values were successfully returned.
#!!#
########################################################################################################################
namespace: io.cloudslang.microsoft.azure.tags.utils
operation:
  name: list_to_json
  inputs:
    - tag_name_list
    - tag_value_list
  python_action:
    use_jython: false
    script: |-
      def execute(tag_name_list,tag_value_list):
          tag_name_list=tag_name_list.split(',')
          tag_value_list=tag_value_list.split(',')
          result = dict(zip(tag_name_list,tag_value_list))
          return {"result":result}
  outputs:
    - result
  results:
    - SUCCESS

