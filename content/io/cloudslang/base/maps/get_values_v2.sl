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
#! @description: Get all values or a specific value from a map.
#!
#! Examples:
#! 1. map = |A|1|\n|B|2|
#!    pair_delimiter = |
#!    entry_delimiter = |\n|
#!    map_start = |
#!    map_end = |
#!    return_result = 1,2
#!
#! 2. map = {"A":"1","B":"2"}
#!    key = B
#!    pair_delimiter = :
#!    entry_delimiter = ,
#!    map_start = {
#!    map_end = }
#!    element_wrapper = "
#!    return_result = 2
#!
#! Notes:
#! 1. CRLF will be replaced with LF for proper handling.
#! 2. Map keys and values must NOT contain any character from pair_delimiter, entry_delimiter, map_start, map_end or element_wrapper.
#!
#! @input map: The map from where the values will be retrieved.
#!             Example: {a:1,b:2,c:3,d:4}, {"a": "1","b": "2"}, Apples=3;Oranges=2
#!             Valid values: Any string representing a valid map according to specified delimiters
#!             (pair_delimiter, entry_delimiter, map_start, map_end, element_wrapper).
#! @input key: Optional - A key or a list of keys from which the value will be retrieved. If a list of keys is used
#!                        the delimiter should be provided in the key_delimiter input.
#!             Default value: NULL.
#! @input key_delimiter: Optional - A delimiter to separate the keys from the key input. Only populate this input when
#!                                  a list of keys is provided in the key input.
#! @input pair_delimiter: The separator to use for splitting key-value pairs into key, respectively value.
#!                        Valid values: Any value that does not contain entry_delimiter and has no common characters with element_wrapper.
#! @input entry_delimiter: The separator to use for splitting the map into entries.
#!                         Valid values: Any value that does not have common characters with element_wrapper.
#! @input map_start: Optional - A sequence of 0 or more characters that marks the beginning of the map.
#! @input map_end: Optional - A sequence of 0 or more characters that marks the end of the map.
#! @input element_wrapper: Optional - A sequence of 0 or more characters that marks the beginning and the end of a key or value.
#!                         Valid values: Any value that does not have common characters with pair_delimiter or entry_delimiter.
#! @input strip_whitespaces: Optional - True if leading and trailing whitespaces should be removed from the keys and
#!                           values of the map, as well as from the key input.
#!                           Default: false.
#!                           Valid values: true, false.
#!
#! @output return_result: List of the values from the map or the value of the key in case of success or error message in case
#!                        of failure.
#! @output return_code: 0 if operation succeeded, -1 otherwise.
#! @output exception: The exception"s stack trace if operation failed. Empty otherwise.
#!
#! @result SUCCESS: Operation run successfully.
#! @result FAILURE: An error occurred.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.maps

operation:
  name: get_values_v2

  inputs:
  - map
  - key:
      required: false
  - key_delimiter:
      required: false
  - keyDelimiter:
      default: ${get("key_delimiter", "")}
      required: false
      private: true
  - pair_delimiter
  - pairDelimiter:
      default: ${get("pair_delimiter", "")}
      required: false
      private: true
  - entry_delimiter
  - entryDelimiter:
      default: ${get("entry_delimiter", "")}
      required: false
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
    gav: "io.cloudslang.content:cs-maps:0.0.4"
    class_name: io.cloudslang.content.maps.actions.GetValuesAction
    method_name: execute

  outputs:
  - return_result: ${get("returnResult", "")}
  - return_code: ${get("returnCode", "")}
  - exception: ${get("exception", "")}

  results:
  - SUCCESS: ${returnCode == "0"}
  - FAILURE
