#   (c) Copyright 2018 Micro Focus, L.P.
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
#! @description: This flow build a list in format 'key=value' from two lists, one for keys, one for values, delimited by 
#!               value from 'delimiter' input.
#!
#! @input list1: The list of keys.
#! @input list2: The list of values.
#! @input final_list: The final list.
#! @input delimiter: The delimiter used to separate the values from final list.
#!
#! @output properties_list: The final list of parameters.
#!
#! @result SUCCESS: Operation succeeded. The list was build.
#! @result FAILURE: Operation failed. The list was not build.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.hcm.aws_service_catalog.utils
flow:
  name: build_properties_list
  inputs:
    - list1
    - list2
    - final_list:
        default: ' '
        required: false
    - delimiter:
        default: ','
        required: false
  workflow:
    - length:
        do:
          io.cloudslang.base.lists.length:
            - list: '${list1}'
            - delimiter: '${delimiter}'
        publish:
          - list_length: '${return_result}'
        navigate:
          - SUCCESS: compare_numbers
          - FAILURE: FAILURE
    - compare_numbers:
        do:
          io.cloudslang.base.math.compare_numbers:
            - value1: '${list_length}'
            - value2: '1'
        navigate:
          - GREATER_THAN: get_by_index
          - EQUALS: get_by_index
          - LESS_THAN: SUCCESS
    - get_by_index:
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${list1}'
            - delimiter: '${delimiter}'
            - index: '0'
        publish:
          - element1: '${return_result}'
        navigate:
          - SUCCESS: get_by_index_1
          - FAILURE: FAILURE
    - get_by_index_1:
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${list2}'
            - delimiter: '${delimiter}'
            - index: '0'
        publish:
          - element2: '${return_result}'
        navigate:
          - SUCCESS: add_element
          - FAILURE: FAILURE
    - add_element:
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${final_list}'
            - element: "${element1 + '=' + element2}"
            - delimiter: '${delimiter}'
        publish:
          - final_list: '${return_result}'
        navigate:
          - SUCCESS: remove_by_index_1
          - FAILURE: FAILURE
    - remove_by_index:
        do:
          io.cloudslang.base.lists.remove_by_index:
            - list: '${list2}'
            - element: '0'
            - delimiter: '${delimiter}'
        publish:
          - list2: '${return_result}'
        navigate:
          - SUCCESS: length_1
          - FAILURE: FAILURE
    - remove_by_index_1:
        do:
          io.cloudslang.base.lists.remove_by_index:
            - list: '${list1}'
            - element: '0'
            - delimiter: '${delimiter}'
        publish:
          - list1: '${return_result}'
        navigate:
          - SUCCESS: remove_by_index
          - FAILURE: FAILURE
    - length_1:
        do:
          io.cloudslang.base.strings.length:
            - origin_string: '${list1}'
        publish:
          - list1_length: '${length}'
        navigate:
          - SUCCESS: compare_numbers_1
    - compare_numbers_1:
        do:
          io.cloudslang.base.math.compare_numbers:
            - value1: '${list1_length}'
            - value2: '0'
        navigate:
          - GREATER_THAN: length
          - EQUALS: remove_by_index_2
          - LESS_THAN: remove_by_index_2
    - remove_by_index_2:
        do:
          io.cloudslang.base.lists.remove_by_index:
            - list: '${final_list}'
            - element: '0'
            - delimiter: '${delimiter}'
        publish:
          - final_list: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - properties_list: '${final_list}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      compare_numbers_1:
        x: 59
        y: 222
        navigate:
          a730ff4d-bd7d-eee5-681e-c7bd7d8abb62:
            vertices:
              - x: 239
                y: 225
            targetId: remove_by_index_2
            port: EQUALS
          af2c1b38-d622-c372-95a4-64e95ff6c4ba:
            vertices: []
            targetId: remove_by_index_2
            port: LESS_THAN
      remove_by_index:
        x: 297
        y: 425
      get_by_index_1:
        x: 985
        y: 424
        navigate:
          d0632cbd-4d77-2ad7-1bac-e6747707cc05:
            vertices: []
            targetId: add_element
            port: SUCCESS
      length:
        x: 55
        y: 50
      compare_numbers:
        x: 579
        y: 46
        navigate:
          18069dfa-5724-c098-3eb8-893881c277fa:
            vertices:
              - x: 865
                y: 40
              - x: 915
                y: 41
            targetId: get_by_index
            port: GREATER_THAN
          b9826b21-53e4-8c88-de81-e03305382146:
            targetId: d03119da-52b7-25a0-6355-c813f5852392
            port: LESS_THAN
          0fad3aa2-9c31-fc21-946e-c229c690fedc:
            vertices:
              - x: 883
                y: 98
              - x: 898
                y: 133
              - x: 900
                y: 131
              - x: 925
                y: 104
            targetId: get_by_index
            port: EQUALS
      get_by_index:
        x: 986
        y: 28
      remove_by_index_1:
        x: 563
        y: 425
      length_1:
        x: 71
        y: 424
      remove_by_index_2:
        x: 296
        y: 213
        navigate:
          3e659c99-9fa6-bdab-db9e-12743b703dd7:
            targetId: d03119da-52b7-25a0-6355-c813f5852392
            port: SUCCESS
      add_element:
        x: 760
        y: 424
    results:
      SUCCESS:
        d03119da-52b7-25a0-6355-c813f5852392:
          x: 567
          y: 218
