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
#! @description: Modify elements of a given map.
#!
#! Examples:
#!
#! 1. For a JSON like map ---
#!    map = {"A":"1","B":"2","c":"3"}
#!    elements = keys
#!    method = to_lowercase
#!    pair_delimiter = :
#!    entry_delimiter = ,
#!    map_start = {
#!    map_end = }
#!    element_wrapper = "
#!    return_result = {"a":"1","b":"2","c":"3"}.
#!
#! 2. For a JSON like map ---
#!    map = {"A":"1","B":"2","c":"3"}
#!    elements = values
#!    method = add_prefix
#!    value = prefix
#!    pair_delimiter = :
#!    entry_delimiter = ,
#!    map_start = {
#!    map_end = }
#!    element_wrapper = "
#!    return_result = {"a":"prefix1","b":"prefix2","c":"prefix3"}.
#!
#! @input map: Required - The map to modify elements.
#!             Example: {a:1,b:2,c:3,d:4}, {"a": "1","b": "2"}
#!             Valid values: Any string representing a valid map according to specified delimiters
#!             (pair_delimiter, entry_delimiter, map_start, map_end, element_wrapper).
#! @input elements: Required - The elements to modify of the given map.
#!                  Valid values: keys, values, all.
#! @input method: Required - The method for modifying the elements.
#!                Valid values: to_uppercase, to_lowercase, add_prefix, add_suffix, strip_spaces.
#! @input value: Optional - The value for suffix or prefix.
#!               Default value: empty string.
#! @input pair_delimiter: The separator to use for splitting key-value pairs into key, respectively value.
#!                        Valid values: Any value that does not contain entry_delimiter and has no common characters with element_wrapper.
#! @input entry_delimiter: The separator to use for splitting the map into entries.
#!                         Valid values: Any value that does not have common characters with element_wrapper.
#! @input map_start: Optional - A sequence of 0 or more characters that marks the beginning of the map.
#! @input map_end: Optional - A sequence of 0 or more characters that marks the end of the map.
#! @input element_wrapper: Optional - A sequence of 0 or more characters that marks the beginning and the end of a key or value.
#!                         Valid values: Any value that does not have common characters with pair_delimiter or entry_delimiter.
#! @input strip_whitespaces: Optional - True if leading and trailing whitespaces should be removed from the keys and values of the map.
#!                           Default: false.
#!                           Valid values: true, false.
#!
#! @output return_result: The modified if operation succeeded. Otherwise it will contain the message of the exception.
#! @output return_code: 0 if operation succeeded, -1 otherwise.
#! @output exception: The exception"s stack trace if operation failed. Empty otherwise.
#!
#! @result SUCCESS: The map was modified successfully.
#! @result FAILURE: An error occurred.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.maps

operation:
  name: modify_map_elements

  inputs:
    - map:
        required: true
    - elements:
        required: true
    - method:
        required: true
    - value:
        required: false
    - pair_delimiter
    - pairDelimiter:
        default: ${get("pair_delimiter", "")}
        private: true
    - entry_delimiter
    - entryDelimiter:
        default: ${get("entry_delimiter", "")}
        private: true
    - map_start:
        required: false
    - mapStart:
        default: ${get("map_start", "")}
        required: false
        private: true
    - map_end:
        required: false
    - mapEnd:
        default: ${get("map_end", "")}
        required: false
        private: true
    - element_wrapper:
        required: false
    - elementWrapper:
        default: ${get("element_wrapper", "")}
        required: false
        private: true
    - strip_whitespaces:
        default: "false"
        required: false
    - stripWhitespaces:
        default: ${get("strip_whitespaces", "")}
        required: false
        private: true

  java_action:
    gav: "io.cloudslang.content:cs-maps:0.0.2"
    class_name: io.cloudslang.content.maps.actions.ModifyMapElementsAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == "0"}
    - FAILURE
