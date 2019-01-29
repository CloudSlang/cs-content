#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
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
#
########################################################################################################################
#!!
#! @description: Retrieves a list of document references from a JSON.
#!
#! @input json_input: JSON containing references
#! @input key: references key
#! @input reference_list: references list
#!
#! @output references: list of references
#! @output error_message: error message if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: document list retrieved successfully
#! @result FAILURE: There was an error while trying to retrieve the document list
#!!#
########################################################################################################################

namespace: io.cloudslang.haven_on_demand.utils

imports:
  json: io.cloudslang.base.json
  lists: io.cloudslang.base.lists

flow:
  name: get_docs_references

  inputs:
     - json_input
     - key
     - reference_list:
        default: ""
        required: false
        private: true

  workflow:
    - get_files_list:
        do:
          json.get_value:
            - json_input
            - json_path: ${[key]}
        publish:
          - value: ${return_result}
          - error_message

    - get_list_size:
        do:
          lists.length:
            - list: ${value}
        publish:
          - list_size: ${result}

    - get_references:
        loop:
          for: index in range(list_size)
          do:
            json.get_value:
              - json_input
              - json_path: ${[key, index, 'reference']}
              - list: ${reference_list}
          publish:
            - reference_list: ${list + return_result + " "}
            - error_message

  outputs:
    - references: ${reference_list.split()}
    - error_message
