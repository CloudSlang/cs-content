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
#! @description: Parse a json and retrieves all its keys.
#!
#! @input json: The json from which the keys are extracted.
#!
#! @output attribute_key_list: A comma delimited list of all keys from the json.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.ucmdb.utility
flow:
  name: parse_json_keys
  inputs:
    - json
  workflow:
    - get_keys:
        do:
          io.cloudslang.base.maps.get_keys:
            - map: '${json}'
        publish:
          - result
        navigate:
          - SUCCESS: replace_square_bracket
    - replace_square_bracket:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${result}'
            - text_to_replace: '['
            - replace_with: ''
        publish:
          - replaced_string
        navigate:
          - SUCCESS: replace_square_bracket_2
          - FAILURE: FAILURE
    - replace_square_bracket_2:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${replaced_string}'
            - text_to_replace: ']'
            - replace_with: ''
        publish:
          - attribute_list: '${replaced_string}'
        navigate:
          - SUCCESS: remove_quotes
          - FAILURE: FAILURE
    - remove_quotes:
        do:
          io.cloudslang.base.strings.regex_replace:
            - regex: "'"
            - text: '${attribute_list}'
            - replacement: ''
        publish:
          - attribute_list: '${result_text}'
        navigate:
          - SUCCESS: remove_space
    - remove_space:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${attribute_list}'
            - text_to_replace: ' '
            - replace_with: ''
        publish:
          - attribute_list: '${replaced_string}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - attribute_key_list: '${attribute_list}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_keys:
        x: 156
        y: 125
      replace_square_bracket:
        x: 331
        y: 121
        navigate:
          94ed1400-0d01-0ebd-c6c8-029b0eafb53a:
            targetId: 1b397386-d927-6dc3-44d8-cade9e2663a3
            port: FAILURE
      replace_square_bracket_2:
        x: 507
        y: 122
        navigate:
          86891ff4-d373-cb2f-5065-b829c2f04776:
            targetId: 1b397386-d927-6dc3-44d8-cade9e2663a3
            port: FAILURE
            vertices:
              - x: 542
                y: 201
      remove_quotes:
        x: 679
        y: 126
      remove_space:
        x: 854
        y: 126
        navigate:
          cc3dd103-16d6-67c5-af48-3e41a46af500:
            targetId: 1b397386-d927-6dc3-44d8-cade9e2663a3
            port: FAILURE
          7a120529-eda7-2a2d-df25-cbf01c8374a6:
            targetId: da208c32-0b8c-f9b7-ccd6-b1ddf8004de6
            port: SUCCESS
    results:
      FAILURE:
        1b397386-d927-6dc3-44d8-cade9e2663a3:
          x: 507
          y: 337
      SUCCESS:
        da208c32-0b8c-f9b7-ccd6-b1ddf8004de6:
          x: 1034
          y: 135
