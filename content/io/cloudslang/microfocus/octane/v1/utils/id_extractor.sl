########################################################################################################################
#!!
#!   (c) Copyright 2022 Micro Focus, L.P.
#!   All rights reserved. This program and the accompanying materials
#!   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#!
#!   The Apache License is available at
#!   http://www.apache.org/licenses/LICENSE-2.0
#!
#!   Unless required by applicable law or agreed to in writing, software
#!   distributed under the License is distributed on an "AS IS" BASIS,
#!   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#!   See the License for the specific language governing permissions and
#!   limitations under the License.
#!!#
########################################################################################################################
########################################################################################################################
#!!
#! @input return_result: The result in JSON format returned by the REST API call.
#!
#! @output entity_id: The id of the entity that's been modified in the current flow.
#! @output id_list: The list of id's for the entities within the current flow, in case of multiple entries.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.octane.v1.utils
operation:
  name: id_extractor
  inputs:
    - return_result
  python_action:
    use_jython: false
    script: |-
      import json
      # do not remove the execute function
      def execute(return_result):
          # code goes here
          try:
              id_list = []
              data = json.loads(return_result)
              if len(data["data"]) > 1:
                  for i in range(len(data["data"])):
                      id_list.append(data["data"][i]["id"])
              entity_id = data["data"][0]["id"]
          except Exception as e:
              return_code = 1
              error_message = str(e)

          return locals()
      # you can add additional helper methods below.
  outputs:
    - entity_id
    - id_list
  results:
    - SUCCESS
