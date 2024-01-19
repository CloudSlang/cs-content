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
#
########################################################################################################################
#!!
#! @description: This flow generates a unique instance name from a prefix.
#!
#! @input instance_name_prefix: The name prefix of the instance.
#!                              Default: ''
#!                              Optional
#! @input delimiter: The delimiter used to split instance_tags_key and instance_tags_value.
#!                   Default: ','
#!                   Optional
#! @input instance_tags_key: String that contains one or more key tags separated by delimiter.
#!                           Constraints: Tag keys are case-sensitive and accept a maximum of 127 Unicode characters.
#!                           May not begin with "aws:"; Each resource can have a maximum of 50 tags.
#!                           Note: if you want to overwrite the existing tag and replace it with empty value then specify
#!                           the parameter with "Not relevant" string.
#!                           Example: 'Name,webserver,stack,scope'
#!                           Default: ''
#!                           Optional
#! @input instance_tags_value: String that contains one or more tag values separated by delimiter.
#!                             The value parameter is required, but if you don't want the tag to have a value,
#!                             specify the parameter with "Not relevant" string, and we set the value to an empty string.
#!                             Constraints: Tag values are case-sensitive and accept a maximum of 255 Unicode characters;
#!                             Each resource can have a maximum of 50 tags.Example of values string for tagging resources
#!                             with values corresponding to the keys from above
#!                             example: "Tagged from API call,Not relevant,Testing,For testing purposes"
#!                             Default: ''
#!                             Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#!
#! @output return_code: "0" if flow was successfully executed, "-1" otherwise
#! @output return_result: Contains the flow result message.
#! @output key_tags_string: String that contains one or more key tags separated by delimiter.
#! @output value_tags_string: String that contains one or more tag values separated by delimiter.
#!
#! @result SUCCESS: Successfully generated a unique name (if the prefix was provided).
#! @result FAILURE: Failed to generate a unique name.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.utils

imports:
  lists: io.cloudslang.base.lists
  math: io.cloudslang.base.math
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils

flow:
  name: get_unique_name

  inputs:
    - instance_name_prefix:
        default: ''
        required: false
    - delimiter:
        default: ','
        required: false
    - instance_tags_key:
        default: ''
        required: false
    - instance_tags_value:
        default: ''
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - check_paired_lists_length:
        worker_group: '${worker_group}'
        do:
          utils.is_true:
            - bool_value: '${str(len(instance_tags_value.split(delimiter)) == len(instance_tags_key.split(delimiter)))}'
        navigate:
          - 'TRUE': find_if_name_provided_in_list
          - 'FALSE': set_failure_message_different_length

    - find_if_name_provided_in_list:
        worker_group: '${worker_group}'
        do:
          lists.find_all:
            - list: '${instance_tags_key if instance_tags_key != "" else "WORKAROUND"}'
            - delimiter: '${delimiter}'
            - element: Name
            - ignore_case: 'false'
        publish:
          - indices
        navigate:
          - SUCCESS: is_name_in_list

    - is_name_in_list:
        worker_group: '${worker_group}'
        do:
          strings.string_equals:
            - first_string: '${indices}'
            - second_string: ''
        navigate:
          - SUCCESS: is_name_in_input_empty
          - FAILURE: count_results

    - is_name_in_input_empty:
        worker_group: '${worker_group}'
        do:
          strings.string_equals:
            - first_string: '${instance_name_prefix}'
            - second_string: ''
            - instance_tags_key
            - instance_tags_value
        publish:
          - instance_tags_key
          - instance_tags_value
          - return_code: '0'
          - return_result: 'No unique name generated because no prefix was provided!'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: generate_unique_sufix

    - generate_unique_sufix:
        worker_group: '${worker_group}'
        do:
          utils.uuid_generator:
            - instance_name_prefix
        publish:
          - new_uuid
        navigate:
          - SUCCESS: substring
    - count_results:
        worker_group: '${worker_group}'
        do:
          lists.length:
            - list: '${indices}'
            - delimiter: '${delimiter}'
        publish:
          - return_result: '${return_result}'
        navigate:
          - SUCCESS: check_no_duplicate_keys
          - FAILURE: set_failure_message_unknown_error

    - check_no_duplicate_keys:
        worker_group: '${worker_group}'
        do:
          math.compare_numbers:
            - value1: '${return_result}'
            - value2: '1'
        navigate:
          - GREATER_THAN: FAILURE
          - LESS_THAN: FAILURE
          - EQUALS: is_input_empty

    - get_name_value_from_list:
        worker_group: '${worker_group}'
        do:
          lists.get_by_index:
            - list: '${instance_tags_value}'
            - delimiter: '${delimiter}'
            - index: '${indices}'
        publish:
          - instance_name_prefix: '${return_result}'
        navigate:
          - SUCCESS: format_key_tags
          - FAILURE: set_failure_message_different_length

    - format_key_tags:
        worker_group: '${worker_group}'
        do:
          lists.remove_by_index:
            - list: '${instance_tags_key}'
            - delimiter: '${delimiter}'
            - element: '${indices}'
        publish:
          - instance_tags_key: '${return_result}'
        navigate:
          - SUCCESS: format_value_tags
          - FAILURE: set_failure_message_unknown_error

    - format_value_tags:
        worker_group: '${worker_group}'
        do:
          lists.remove_by_index:
            - list: '${instance_tags_value}'
            - delimiter: '${delimiter}'
            - element: '${indices}'
        publish:
          - instance_tags_value: '${return_result}'
        navigate:
          - SUCCESS: generate_unique_sufix
          - FAILURE: set_failure_message_unknown_error

    - add_key_tag:
        worker_group: '${worker_group}'
        do:
          lists.add_element:
            - list: '${instance_tags_key}'
            - delimiter: '${delimiter}'
            - element: Name
        publish:
          - instance_tags_key: '${return_result}'
        navigate:
          - SUCCESS: add_value_tag
          - FAILURE: set_failure_message_unknown_error

    - add_value_tag:
        worker_group: '${worker_group}'
        do:
          lists.add_element:
            - list: '${instance_tags_value}'
            - delimiter: '${delimiter}'
            - element: '${random_name}'
        publish:
          - return_code: '${return_code}'
          - instance_tags_value: '${return_result}'
          - return_result: 'Successfully generated a unique name!'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: set_failure_message_unknown_error

    - is_list_empty:
        worker_group: '${worker_group}'
        do:
          strings.string_equals:
            - first_string: '${instance_tags_key}'
            - second_string: ''
        navigate:
          - SUCCESS: set_success_message
          - FAILURE: add_key_tag

    - set_success_message:
        worker_group: '${worker_group}'
        do:
          math.add_numbers:
            - value1: '1'
            - value2: '1'
            - random_name
        publish:
          - instance_tags_key: Name
          - instance_tags_value: '${random_name}'
          - return_code: '0'
          - return_result: 'Successfully generated a unique name!'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: SUCCESS

    - is_input_empty:
        worker_group: '${worker_group}'
        do:
          strings.string_equals:
            - first_string: '${instance_name_prefix}'
            - second_string: ''
        navigate:
          - SUCCESS: get_name_value_from_list
          - FAILURE: set_failure_message_duplicate_entry

    - set_failure_message_duplicate_entry:
        worker_group: '${worker_group}'
        do:
          math.add_numbers:
            - value1: '1'
            - value2: '1'
        publish:
          - instance_tags_key: ''
          - instance_tags_value: ''
          - return_result: 'Name tag key provided both as stand-alone input and as list element!'
          - return_code: '-1'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure

    - set_failure_message_unknown_error:
        worker_group: '${worker_group}'
        do:
          math.add_numbers:
            - value1: '1'
            - value2: '1'
        publish:
          - instance_tags_key: ''
          - instance_tags_value: ''
          - return_result: 'Failed to generate a unique name!'
          - return_code: '-1'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure

    - set_failure_message_different_length:
        worker_group: '${worker_group}'
        do:
          math.add_numbers:
            - value1: '1'
            - value2: '1'
        publish:
          - instance_tags_key: ''
          - instance_tags_value: ''
          - return_result: 'The list of keys and values for tags must have the same length!'
          - return_code: '-1'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
    - substring:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.substring:
            - origin_string: '${new_uuid}'
            - begin_index: '0'
            - end_index: '5'
            - instance_name_prefix: '${instance_name_prefix}'
        publish:
          - random_name: '${instance_name_prefix +"_"+ new_string}'
        navigate:
          - SUCCESS: is_list_empty
          - FAILURE: on_failure

  outputs:
    - return_code
    - return_result
    - key_tags_string: '${instance_tags_key}'
    - value_tags_string: '${instance_tags_value}'

  results:
    - SUCCESS
    - FAILURE

extensions:
  graph:
    steps:
      is_list_empty:
        x: 1081
        'y': 251
      format_key_tags:
        x: 678
        'y': 559
      is_input_empty:
        x: 226
        'y': 416
      count_results:
        x: 513
        'y': 244
      set_failure_message_unknown_error:
        x: 877
        'y': 416
        navigate:
          086a1806-5a2f-f0af-8e95-50f57cff8ccc:
            targetId: de334ca2-1afb-32aa-a163-16a6bf314b02
            port: SUCCESS
      add_value_tag:
        x: 1085
        'y': 570
        navigate:
          c4996557-b2e6-df2e-6846-5dac3210ccad:
            targetId: 235abd31-5329-b193-cb15-2b754cd1eb12
            port: SUCCESS
      set_success_message:
        x: 1083
        'y': 90
        navigate:
          dcdfe8fc-dcba-40bb-8f12-30a84e5622fa:
            targetId: 78468e56-95ea-a10d-121c-56c5c955b0c3
            port: SUCCESS
          00eb2d55-a226-e01e-3faa-0935852d0614:
            targetId: 78468e56-95ea-a10d-121c-56c5c955b0c3
            port: FAILURE
      generate_unique_sufix:
        x: 672
        'y': 249
      format_value_tags:
        x: 675
        'y': 412
      check_no_duplicate_keys:
        x: 377
        'y': 234
        navigate:
          7ae28478-623b-379e-254c-2a6a67426532:
            targetId: a01ff4cc-8b14-065e-04d2-d7640e5ad876
            port: GREATER_THAN
          81974384-34ce-1233-1d22-a141b5c80e24:
            targetId: a01ff4cc-8b14-065e-04d2-d7640e5ad876
            port: LESS_THAN
      substring:
        x: 847
        'y': 250
      set_failure_message_duplicate_entry:
        x: 381
        'y': 415
        navigate:
          39af55e7-a7ba-b9cf-a845-e23a51e7cc25:
            targetId: 511d39a6-7e00-ecab-f666-92be07b53965
            port: SUCCESS
      find_if_name_provided_in_list:
        x: 251
        'y': 90
      set_failure_message_different_length:
        x: 59
        'y': 242
        navigate:
          86813c23-5f05-a83b-565e-3cc924c119b2:
            targetId: a01ff4cc-8b14-065e-04d2-d7640e5ad876
            port: SUCCESS
      is_name_in_list:
        x: 457
        'y': 85
      get_name_value_from_list:
        x: 58
        'y': 556
      add_key_tag:
        x: 1081
        'y': 411
      is_name_in_input_empty:
        x: 669
        'y': 92
        navigate:
          060a2931-1dfb-ba18-ff8f-c43c5fa320a2:
            targetId: 78468e56-95ea-a10d-121c-56c5c955b0c3
            port: SUCCESS
      check_paired_lists_length:
        x: 67
        'y': 87
    results:
      SUCCESS:
        78468e56-95ea-a10d-121c-56c5c955b0c3:
          x: 856
          'y': 96
        235abd31-5329-b193-cb15-2b754cd1eb12:
          x: 1279
          'y': 573
      FAILURE:
        511d39a6-7e00-ecab-f666-92be07b53965:
          x: 529
          'y': 416
        a01ff4cc-8b14-065e-04d2-d7640e5ad876:
          x: 224
          'y': 239
        de334ca2-1afb-32aa-a163-16a6bf314b02:
          x: 879
          'y': 579
