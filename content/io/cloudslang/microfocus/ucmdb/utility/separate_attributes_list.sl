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
#! @description: Iterate through the list of  attributes (name = value) and return a list of elements processed
#!               (“name” : ”value”)
#!
#! @input prop_list: Comma delimited list of attributes to be set (name=value) 
#! @input separator: separator - A delimiter separating the list elements.
#!                   Default: ','
#! @input list_init: Auxiliary input, should not receive a value.
#!                   Default: ' '
#! @input second_list_init: Auxiliary input, should not receive a value.
#!                          Default: ' '
#!
#! @output attribute_list: Attribute list processed.
#! @output return_result: Success message in case of success, failure message in case of failure.
#!
#! @result FAILURE: The operation completed unsuccessfully.
#! @result SUCCESS: The operation completed as stated in the description.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.ucmdb.utility
flow:
  name: separate_attributes_list
  inputs:
    - prop_list:
        required: true
    - separator:
        default: ','
        required: true
    - list_init:
        default: ' '
        required: false
    - second_list_init:
        default: ' '
        required: false
  workflow:
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${prop_list}'
            - message_list: 'success message, failure message'
        publish:
          - attribute: '${result_string}'
          - message_list
        navigate:
          - HAS_MORE: add_pair_attribute
          - NO_MORE: get_by_index
          - FAILURE: get_by_index_1
    - add_pair_attribute:
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${second_list_init}'
            - element: '${attribute}'
            - delimiter: ','
        publish:
          - attribute_pair: '${return_result}'
        navigate:
          - SUCCESS: remove_extra_comma
          - FAILURE: get_by_index_1
    - remove_extra_comma:
        do:
          io.cloudslang.base.lists.remove_by_index:
            - list: '${attribute_pair}'
            - element: '0'
            - delimiter: ','
        publish:
          - attribute_pair_final: '${return_result}'
        navigate:
          - SUCCESS: get_key
          - FAILURE: get_by_index_1
    - get_key:
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${attribute_pair_final}'
            - delimiter: =
            - index: '0'
        publish:
          - key: '${return_result}'
        navigate:
          - SUCCESS: get_value
          - FAILURE: get_by_index_1
    - get_value:
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${attribute_pair_final}'
            - delimiter: =
            - index: '1'
        publish:
          - value: '${return_result}'
        navigate:
          - SUCCESS: put_key_and_value
          - FAILURE: get_by_index_1
    - put_key_and_value:
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${list_init}'
            - element: "${'\"' + key + '\"' + ':' + '\"' + value + '\"'}"
            - delimiter: ','
        publish:
          - list_init: '${return_result}'
        navigate:
          - SUCCESS: remove_extra_space_2
          - FAILURE: get_by_index_1
    - remove_extra_space_2:
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${list_init}'
            - delimiter: ','
            - index: '0'
        publish:
          - index0: '${return_result}'
        navigate:
          - SUCCESS: check_empty_space
          - FAILURE: get_by_index_1
    - check_empty_space:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${index0}'
            - second_string: ' '
            - ignore_case: 'true'
        publish: []
        navigate:
          - SUCCESS: remove_second_extra_space
          - FAILURE: list_iterator
    - remove_second_extra_space:
        do:
          io.cloudslang.base.lists.remove_by_index:
            - list: '${list_init}'
            - element: '0'
            - delimiter: ','
        publish:
          - list_init: '${return_result}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: get_by_index_1
    - get_by_index:
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${message_list}'
            - delimiter: ','
            - index: '0'
        publish:
          - return_result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
    - get_by_index_1:
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${message_list}'
            - delimiter: ','
            - index: '1'
        publish:
          - return_result
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: FAILURE
  outputs:
    - attribute_list: '${list_init}'
    - return_result: '${return_result}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_by_index_1:
        x: 505
        y: 424
        navigate:
          4326244e-2393-8d41-907a-915de4765a60:
            targetId: 4bd95e94-2899-c5ca-438a-3234e9344be8
            port: SUCCESS
            vertices:
            - x: 542
              y: 503
      remove_second_extra_space:
        x: 1084
        y: 117
        navigate:
          483b9363-0ce9-38e4-28d7-b1208170244e:
            vertices:
            - x: 1010
              y: 17
            - x: 196
              y: 10
            - x: 179
              y: 24
            targetId: list_iterator
            port: SUCCESS
      get_value:
        x: 550
        y: 112
      remove_extra_comma:
        x: 303
        y: 111
      remove_extra_space_2:
        x: 820
        y: 112
      list_iterator:
        x: 12
        y: 111
        navigate:
          c09162f0-6b57-ccf2-1b89-4a3ea3f2bb6d:
            vertices:
            - x: 50
              y: 187
            targetId: get_by_index
            port: NO_MORE
      get_by_index:
        x: 13
        y: 422
        navigate:
          be58ed9d-6a44-81f4-a474-6b87e44cb9af:
            targetId: 4bd95e94-2899-c5ca-438a-3234e9344be8
            port: FAILURE
          80e96211-4e7a-4346-17a1-2be6b0862643:
            targetId: e61e32b1-556a-891a-ed1f-d090cb057648
            port: SUCCESS
            vertices:
            - x: 54
              y: 503
      add_pair_attribute:
        x: 161
        y: 110
      get_key:
        x: 428
        y: 112
      put_key_and_value:
        x: 684
        y: 110
      check_empty_space:
        x: 990
        y: 97
        navigate:
          96383a0d-67fd-ea6b-0fd9-9e16c0024306:
            vertices:
            - x: 912
              y: 67
            - x: 598
              y: 63
            - x: 247
              y: 61
            - x: 177
              y: 62
            targetId: list_iterator
            port: FAILURE
    results:
      FAILURE:
        4bd95e94-2899-c5ca-438a-3234e9344be8:
          x: 508
          y: 603
      SUCCESS:
        e61e32b1-556a-891a-ed1f-d090cb057648:
          x: 19
          y: 603