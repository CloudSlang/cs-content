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
#! @output return_result: The result of the execution. If successful: 'The operation was successful' else: 'Could not parse attribute_list'.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result FAILURE: The operation completed unsuccessfully.
#! @result SUCCESS: The operation completed as stated in the description.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.ucmdb.utility
flow:
  name: parse_attribute_list
  inputs:
    - attribute_list:
        required: false
    - json
    - attributes:
        default: ' '
        required: false
  workflow:
  - default_if_attribute_list_empty:
      do:
        io.cloudslang.base.utils.default_if_empty:
        - initial_value: '${attribute_list}'
        - default_value: all
        - message: 'The operation was successful, Could not parse attribute_list'
      publish:
      - get_all: '${default_value}'
      - return_result
      - return_code
      - exception
      - message
      navigate:
      - SUCCESS: string_equals
      - FAILURE: get_failure_message_by_index_1
  - string_equals:
      do:
        io.cloudslang.base.strings.string_equals:
        - first_string: '${return_result}'
        - second_string: all
      publish: []
      navigate:
      - SUCCESS: parse_json_keys
      - FAILURE: list_iterator
  - parse_json_keys:
      do:
        io.cloudslang.microfocus.ucmdb.utility.parse_json_keys:
        - json: '${json}'
      publish:
      - attribute_list: '${attribute_key_list}'
      navigate:
      - FAILURE: get_failure_message_by_index_1
      - SUCCESS: list_iterator
  - list_iterator:
      do:
        io.cloudslang.base.lists.list_iterator:
        - list: '${attribute_list}'
      publish:
      - attribute: '${result_string}'
      navigate:
      - HAS_MORE: json_path_query
      - NO_MORE: remove_by_index
      - FAILURE: get_failure_message_by_index
  - json_path_query:
      do:
        io.cloudslang.base.json.json_path_query:
        - json_object: '${json}'
        - json_path: "${'$.' + attribute}"
      publish:
      - attribute_value: '${return_result}'
      - return_result
      - return_code
      - exception
      navigate:
      - SUCCESS: add_element
      - FAILURE: get_failure_message_by_index
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
      - FAILURE: get_failure_message_by_index
  - remove_by_index:
      do:
        io.cloudslang.base.lists.remove_by_index:
        - list: '${attributes}'
        - element: '0'
        - delimiter: ','
      publish:
      - attributes: '${return_result}'
      navigate:
      - SUCCESS: get_successful_message_by_index
      - FAILURE: get_failure_message_by_index
  - get_successful_message_by_index:
      do:
        io.cloudslang.base.lists.get_by_index:
        - list: '${message}'
        - delimiter: ','
        - index: '0'
      publish:
      - return_result
      navigate:
      - SUCCESS: SUCCESS
      - FAILURE: get_failure_message_by_index
  - get_failure_message_by_index:
      do:
        io.cloudslang.base.lists.get_by_index:
        - list: '${message}'
        - delimiter: ','
        - index: '1'
      publish:
      - return_result
      navigate:
      - SUCCESS: FAILURE
      - FAILURE: FAILURE
  - get_failure_message_by_index_1:
      do:
        io.cloudslang.base.lists.get_by_index:
        - list: '${message}'
        - delimiter: ','
        - index: '1'
      publish:
      - return_result
      navigate:
      - SUCCESS: FAILURE
      - FAILURE: FAILURE
  outputs:
  - attributes_list: "${get('attributes', ' ')}"
  - return_result: '${return_result}'
  - return_code: '${return_code}'
  - exception: '${exception}'
  results:
  - SUCCESS
  - FAILURE
extensions:
  graph:
    steps:
      get_failure_message_by_index:
        x: 769
        y: 329
        navigate:
          6b29b7fa-9a25-aa20-3792-7922ed516f52:
            targetId: faa3d0c8-969a-2d6e-c102-e15dcccc6d93
            port: SUCCESS
            vertices:
            - x: 878
              y: 386
            - x: 879
              y: 482
          5cdaf41a-4b41-4a1f-d3f2-c5ee85d87927:
            targetId: faa3d0c8-969a-2d6e-c102-e15dcccc6d93
            port: FAILURE
      remove_by_index:
        x: 590
        y: 328
      json_path_query:
        x: 954
        y: 37
      string_equals:
        x: 246
        y: 33
        navigate:
          ba04c249-4673-0bea-bc01-8cf104163217:
            vertices:
            - x: 354
              y: 13
            - x: 534
              y: 12
            targetId: list_iterator
            port: FAILURE
      list_iterator:
        x: 593
        y: 43
      get_failure_message_by_index_1:
        x: 212
        y: 322
        navigate:
          dc1dba00-15ef-c33e-d9ca-bcad2ed6e118:
            targetId: 99867827-fb62-d823-f101-efbc673c87eb
            port: SUCCESS
            vertices:
            - x: 316
              y: 372
            - x: 314
              y: 466
          4ba6ae8e-4e35-dd28-122d-c6b53ed7c1c8:
            targetId: 99867827-fb62-d823-f101-efbc673c87eb
            port: FAILURE
      default_if_attribute_list_empty:
        x: 27
        y: 47
      add_element:
        x: 776
        y: 129
      get_successful_message_by_index:
        x: 584
        y: 606
        navigate:
          3ed74454-c9f3-b49e-0e76-eb640d3ba47f:
            targetId: 8f96a361-cb9e-cdcd-7929-34037cf3d7c6
            port: SUCCESS
      parse_json_keys:
        x: 401
        y: 51
    results:
      SUCCESS:
        8f96a361-cb9e-cdcd-7929-34037cf3d7c6:
          x: 973
          y: 607
      FAILURE:
        faa3d0c8-969a-2d6e-c102-e15dcccc6d93:
          x: 770
          y: 523
        99867827-fb62-d823-f101-efbc673c87eb:
          x: 215
          y: 554
