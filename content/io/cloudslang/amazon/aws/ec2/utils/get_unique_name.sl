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
#! @description: This flow generates a unique instance name from a prefix.
#!
#! @input instance_name_prefix: The name prefix of the instance.
#!                              Default: ''
#!                              Optional
#! @input delimiter: Delimiter used to split instance_tags_key and instance_tags_value.
#!                   Default: ','
#!                   Optional
#! @input instance_tags_key: String that contains one or more key tags separated by delimiter. Constraints: Tag keys are
#!                           case-sensitive and accept a maximum of 127 Unicode characters. May not begin with "aws:";
#!                           Each resource can have a maximum of 50 tags. Note: if you want to overwrite the existing tag
#!                           and replace it with empty value then specify the parameter with "Not relevant" string.
#!                           Example: 'Name,webserver,stack,scope'
#!                           Default: ''
#!                           Optional
#! @input instance_tags_value: String that contains one or more tag values separated by delimiter. The value parameter is
#!                             required, but if you don't want the tag to have a value, specify the parameter with
#!                             "Not relevant" string, and we set the value to an empty string. Constraints: Tag values are
#!                             case-sensitive and accept a maximum of 255 Unicode characters; Each resource can have a
#!                             maximum of 50 tags.
#!                             Example of values string for tagging resources with values corresponding to the keys from
#!                             above example: "Tagged from API call,Not relevant,Testing,For testing purposes"
#!                             Default: ''
#!                             Optional
#!
#! @output return_result: Contains the flow result message.
#! @output return_code: "0" if flow was successfully executed, "-1" otherwise
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

  workflow:
    - check_paired_lists_length:
        do:
          utils.is_true:
            - bool_value: '${str(len(instance_tags_value.split(delimiter)) == len(instance_tags_key.split(delimiter)))}'
        navigate:
          - 'TRUE': find_if_name_provided_in_list
          - 'FALSE': set_failure_message_different_length

    - find_if_name_provided_in_list:
        do:
          lists.find_all:
            - list: '${instance_tags_key if instance_tags_key != "" else "WORKAROUND"}'
            - delimiter: '${delimiter}'
            - element: 'Name'
            - ignore_case: 'false'
        publish:
          - indices
        navigate:
          - SUCCESS: is_name_in_list

    - is_name_in_list:
        do:
          strings.string_equals:
            - first_string: '${indices}'
            - second_string: ''
        navigate:
          - SUCCESS: is_name_in_input_empty
          - FAILURE: count_results

    - is_name_in_input_empty:
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
        do:
          utils.uuid_generator:
            - instance_name_prefix
        publish:
          - random_name: '${instance_name_prefix + new_uuid}'
        navigate:
          - SUCCESS: is_list_empty

    - count_results:
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
        do:
          math.compare_numbers:
            - value1: '${return_result}'
            - value2: '1'
        navigate:
          - GREATER_THAN: FAILURE
          - LESS_THAN: FAILURE
          - EQUALS: is_input_empty

    - get_name_value_from_list:
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
        do:
          lists.add_element:
            - list: '${instance_tags_key}'
            - delimiter: '${delimiter}'
            - element: 'Name'
        publish:
          - instance_tags_key: '${return_result}'
        navigate:
          - SUCCESS: add_value_tag
          - FAILURE: set_failure_message_unknown_error

    - add_value_tag:
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
        do:
          strings.string_equals:
            - first_string: '${instance_tags_key}'
            - second_string: ''
        navigate:
          - SUCCESS: set_success_message
          - FAILURE: add_key_tag

    - set_success_message:
        do:
          math.add_numbers:
            - value1: '1'
            - value2: '1'
            - random_name
        publish:
          - instance_tags_key: 'Name'
          - instance_tags_value: '${random_name}'
          - return_code: '0'
          - return_result: 'Successfully generated a unique name!'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: SUCCESS

    - is_input_empty:
        do:
          strings.string_equals:
            - first_string: '${instance_name_prefix}'
            - second_string: ''
        navigate:
          - SUCCESS: get_name_value_from_list
          - FAILURE: set_failure_message_duplicate_entry

    - set_failure_message_duplicate_entry:
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

  outputs:
    - return_code
    - return_result
    - key_tags_string: ${instance_tags_key}
    - value_tags_string: ${instance_tags_value}

  results:
    - SUCCESS
    - FAILURE
