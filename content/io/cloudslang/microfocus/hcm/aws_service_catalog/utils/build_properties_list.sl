#   Copyright 2023 Open Text
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
    - get_parameters_list_length:
        do:
          io.cloudslang.base.lists.length:
            - list: '${list1}'
            - delimiter: '${delimiter}'
        publish:
          - list_length: '${return_result}'
        navigate:
          - SUCCESS: check_if_list_has_more_elements
          - FAILURE: FAILURE
    - check_if_list_has_more_elements:
        do:
          io.cloudslang.base.math.compare_numbers:
            - value1: '${list_length}'
            - value2: '1'
        navigate:
          - GREATER_THAN: get_parameter_name
          - EQUALS: get_parameter_name
          - LESS_THAN: SUCCESS
    - get_parameter_name:
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${list1}'
            - delimiter: '${delimiter}'
            - index: '0'
        publish:
          - element1: '${return_result}'
        navigate:
          - SUCCESS: get_parameter_value
          - FAILURE: FAILURE
    - get_parameter_value:
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${list2}'
            - delimiter: '${delimiter}'
            - index: '0'
        publish:
          - element2: '${return_result}'
        navigate:
          - SUCCESS: add_paramter_to_list
          - FAILURE: FAILURE
    - add_paramter_to_list:
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${final_list}'
            - element: "${element1 + '=' + element2}"
            - delimiter: '${delimiter}'
        publish:
          - final_list: '${return_result}'
        navigate:
          - SUCCESS: remove_parameter_name
          - FAILURE: FAILURE
    - remove_parameter_value:
        do:
          io.cloudslang.base.lists.remove_by_index:
            - list: '${list2}'
            - element: '0'
            - delimiter: '${delimiter}'
        publish:
          - list2: '${return_result}'
        navigate:
          - SUCCESS: retrieve_parameters_list_length
          - FAILURE: FAILURE
    - remove_parameter_name:
        do:
          io.cloudslang.base.lists.remove_by_index:
            - list: '${list1}'
            - element: '0'
            - delimiter: '${delimiter}'
        publish:
          - list1: '${return_result}'
        navigate:
          - SUCCESS: remove_parameter_value
          - FAILURE: FAILURE
    - retrieve_parameters_list_length:
        do:
          io.cloudslang.base.strings.length:
            - origin_string: '${list1}'
        publish:
          - list1_length: '${length}'
        navigate:
          - SUCCESS: check_if_list_has_elements
    - check_if_list_has_elements:
        do:
          io.cloudslang.base.math.compare_numbers:
            - value1: '${list1_length}'
            - value2: '0'
        navigate:
          - GREATER_THAN: get_parameters_list_length
          - EQUALS: remove_first_element_from_parameters_list
          - LESS_THAN: remove_first_element_from_parameters_list
    - remove_first_element_from_parameters_list:
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
      remove_parameter_value:
        x: 546
        y: 398
        navigate:
          8d925016-e4e6-abcc-9438-9469788b15e8:
            targetId: ea5dec1e-fc27-0438-a09b-bc2d2b13273f
            port: FAILURE
      check_if_list_has_more_elements:
        x: 328
        y: 48
        navigate:
          b9826b21-53e4-8c88-de81-e03305382146:
            targetId: d03119da-52b7-25a0-6355-c813f5852392
            port: LESS_THAN
          292bc5ad-16cb-ca40-a9d8-7f6d73447989:
            vertices: []
            targetId: get_by_index
            port: GREATER_THAN
      get_parameter_name:
        x: 539
        y: 45
        navigate:
          e795acd7-65c2-b8f2-8252-fe87863b0af6:
            targetId: ea5dec1e-fc27-0438-a09b-bc2d2b13273f
            port: FAILURE
      remove_first_element_from_parameters_list:
        x: 321
        y: 391
        navigate:
          6da2dbb6-70cc-7223-6c20-9666783f7ee5:
            targetId: 78379e6b-a4b0-c947-5f0f-705ac5657698
            port: FAILURE
          7b19b19d-abfd-b5f3-ca50-28a221937dd5:
            targetId: d03119da-52b7-25a0-6355-c813f5852392
            port: SUCCESS
      get_parameter_value:
        x: 756
        y: 38
        navigate:
          4a0309ce-17de-4afe-bfb9-b4b9a9575a33:
            targetId: ea5dec1e-fc27-0438-a09b-bc2d2b13273f
            port: FAILURE
      check_if_list_has_elements:
        x: 63
        y: 396
        navigate:
          a730ff4d-bd7d-eee5-681e-c7bd7d8abb62:
            vertices: []
            targetId: remove_by_index_2
            port: EQUALS
          af2c1b38-d622-c372-95a4-64e95ff6c4ba:
            vertices: []
            targetId: remove_by_index_2
            port: LESS_THAN
      retrieve_parameters_list_length:
        x: 316
        y: 581
      add_paramter_to_list:
        x: 927
        y: 40
        navigate:
          d7b98652-c07a-b2d2-a80b-48861eddf73d:
            targetId: ea5dec1e-fc27-0438-a09b-bc2d2b13273f
            port: FAILURE
      get_parameters_list_length:
        x: 55
        y: 50
        navigate:
          ca3861ff-30e0-be3d-e915-e123ffac3e95:
            targetId: 78379e6b-a4b0-c947-5f0f-705ac5657698
            port: FAILURE
      remove_parameter_name:
        x: 926
        y: 399
        navigate:
          4b906bf5-17aa-15bb-cd00-2866788be7bb:
            targetId: ea5dec1e-fc27-0438-a09b-bc2d2b13273f
            port: FAILURE
    results:
      SUCCESS:
        d03119da-52b7-25a0-6355-c813f5852392:
          x: 546
          y: 210
      FAILURE:
        78379e6b-a4b0-c947-5f0f-705ac5657698:
          x: 317
          y: 208
        ea5dec1e-fc27-0438-a09b-bc2d2b13273f:
          x: 751
          y: 210
