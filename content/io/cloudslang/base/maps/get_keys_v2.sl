#   (c) Copyright 2020 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: Gets keys from a map.
#!
#! Examples:
#! 1. For an SQL like map ---
#!    map = |A|1|\n|B|2|
#!    pair_delimiter = |
#!    entry_delimiter = |\n|
#!    map_start = |
#!    map_end = |
#!    return_result = A,B
#!
#! 2. For a JSON like map ---
#!    map = {"A":"1","B":"2"}
#!    pair_delimiter = :
#!    entry_delimiter = ,
#!    map_start = {
#!    map_end = }
#!    element_wrapper = "
#!    return_result = A,B.
#!
#! Notes:
#! 1. CRLF will be replaced with LF for proper handling.
#!
#! @input map: The map from where the keys will be retrieved.
#!             Example: {a:1,b:2,c:3,d:4}, {"a": "1","b": "2"}, Apples=3;Oranges=2
#!             Valid values: Any string representing a valid map according to specified delimiters
#!             (pair_delimiter, entry_delimiter, map_start, map_end, element_wrapper).
#! @input pair_delimiter: The separator to use for splitting key-value pairs into key, respectively value.
#!                        Default: ":"
#!                        Valid values: Any value that does not contain entry_delimiter and has no common characters with element_wrapper.
#! @input entry_delimiter: The separator to use for splitting the map into entries.
#!                         Valid values: Any value that does not have common characters with element_wrapper.
#! @input map_start: Optional - A sequence of 0 or more characters that marks the beginning of the map.
#!                   Default: "{"
#! @input map_end: Optional - A sequence of 0 or more characters that marks the end of the map.
#!                 Default: "}"
#! @input element_wrapper: Optional - A sequence of 0 or more characters that marks the beginning and the end of a key or value.
#!                         Valid values: Any value that does not have common characters with pair_delimiter or entry_delimiter.
#! @input strip_whitespaces: Optional - True if leading and trailing whitespaces should be removed from the keys and values of the map.
#!                           Default: false.
#!                           Valid values: true, false.
#!
#! @output return_result: A list containing the keys from the map if the operation succeeded. Otherwise, it will contain the exception message.
#! @output return_code: 0 if operation succeeded, -1 otherwise.
#! @output exception: The exception"s stack trace if operation failed. Empty otherwise.
#!
#! @result SUCCESS: The keys were successfully retrieved from the map.
#! @result FAILURE: An error occurred.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.maps

operation:
  name: get_keys_v2

  inputs:
    - map
    - pair_delimiter:
        default: ":"
    - pairDelimiter:
        default: ${get("pair_delimiter", "")}
        private: true
    - entry_delimiter:
        default: ","
    - entryDelimiter:
        default: ${get("entry_delimiter", "")}
        private: true
    - map_start:
        default: "{"
        required: false
    - mapStart:
        default: ${get("map_start", "")}
        required: false
        private: true
    - map_end:
        default: "}"
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
    gav: "io.cloudslang.content:cs-maps:0.0.1-RC10"
    class_name: io.cloudslang.content.maps.actions.GetKeysAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == "0"}
    - FAILURE
