#   Copyright 2018, Micro Focus, L.P.
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
#! @description: Parse a json and retrieves attribute and attribute value pairs
#!
#! @input attribute_list: Comma delimited list of attributes to be retrieved from json.
#! @input json: The json to be parsed.
#! @input attributes: Auxiliary input, should not receive a value.
#!
#! @output attributes_list: A list of attribute and attribute value in comma delimited pairs.
#!
#! @result FAILURE: The operation completed unsuccessfully.
#! @result SUCCESS: The operation completed as stated in the description.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.ucmdb.utility
flow:
  name: parse_attribute_list
  inputs:
    - attribute_list
    - json
    - attributes:
        default: ' '
        required: false
  workflow:
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${attribute_list}'
        publish:
          - attribute: '${result_string}'
        navigate:
          - HAS_MORE: json_path_query
          - NO_MORE: remove_by_index
          - FAILURE: FAILURE
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: "${'$.' + attribute}"
        publish:
          - attribute_value: '${return_result}'
        navigate:
          - SUCCESS: add_element
          - FAILURE: FAILURE
    - add_element:
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${attributes}'
            - element: "${attribute + '=' + attribute_value}"
            - delimiter: ','
        publish:
          - attributes: '${return_result}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: FAILURE
    - remove_by_index:
        do:
          io.cloudslang.base.lists.remove_by_index:
            - list: '${attributes}'
            - element: '0'
            - delimiter: ','
        publish:
          - attributes: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - attributes_list: '${attributes}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      list_iterator:
        x: 65
        y: 113
        navigate:
          3419109b-5f3b-671d-b5d1-868b7fd8eaac:
            targetId: e3d2cca3-20b6-4bb0-1893-ab63cf98140a
            port: FAILURE
      json_path_query:
        x: 599
        y: 105
        navigate:
          514a6683-fc79-8392-56e6-64d70f57ffb4:
            targetId: e3d2cca3-20b6-4bb0-1893-ab63cf98140a
            port: FAILURE
      add_element:
        x: 325
        y: 209
        navigate:
          3143da42-d534-e9ec-8a34-b7b5bc52c2c5:
            targetId: e3d2cca3-20b6-4bb0-1893-ab63cf98140a
            port: FAILURE
            vertices:
            - x: 362
              y: 293
      remove_by_index:
        x: 60
        y: 579
        navigate:
          28f0d129-dfbb-489e-adfb-4bbbdebefca0:
            targetId: e3d2cca3-20b6-4bb0-1893-ab63cf98140a
            port: FAILURE
          063e529d-4ab1-b67b-25f7-ea702af4b4fe:
            targetId: 8f96a361-cb9e-cdcd-7929-34037cf3d7c6
            port: SUCCESS
    results:
      FAILURE:
        e3d2cca3-20b6-4bb0-1893-ab63cf98140a:
          x: 329
          y: 392
      SUCCESS:
        8f96a361-cb9e-cdcd-7929-34037cf3d7c6:
          x: 602
          y: 570
