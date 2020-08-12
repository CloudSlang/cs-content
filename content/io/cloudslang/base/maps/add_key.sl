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
#! @description: Adds a key to a map. If the given key already exists in the map then its value will be overwritten.
#!
#! Notes: CRLF will be replaced with LF for proper handling.
#!
#! Examples:
#! 1. For an SQL like map ---
#!    map=|A|1||B|2|, key=B, value=3, pair_delimiter=|, entry_delimiter=||, map_start=|, map_end=| => |A|1||B|3|
#! 2. For a JSON like map ---
#!    map={'A':'1','B':'2'}, key=B, value=3, pair_delimiter=':', entry_delimiter=',', map_start={', map_end='} => {'A':'1','B':'3'}.
#!    This is the default format.
#!
#! @input map: Optional - The map to add a key to.
#!             Example: {a:1,b:2,c:3,d:4}, <John|1||George|2>, Apples=3;Oranges=2
#!             Default: {''}.
#!             Valid values: Any string representing a valid map according to specified delimiters
#!             (pair_delimiter, entry_delimiter, map_start, map_end).
#! @input key: Optional - The key to add.
#!             Default value: NULL.
#!             Valid values: Any string that does not contain or is equal to value of pair_delimiter or entry_delimiter.
#! @input value: Optional - The value to map to the added key.
#!               Default value: NULL
#!               Valid values: Any string that does not contain or is equal to value of pair_delimiter or entry_delimiter.
#! @input pair_delimiter: Optional - The separator to use for splitting key-value pairs into key, respectively value.
#!                        Default value: ':'.
#!                        Valid values: Any value that does not contain or is equal to entry_delimiter.
#! @input entry_delimiter: Optional - The separator to use for splitting the map into entries.
#!                         Default value: ','.
#!                         Valid values: Any value.
#! @input map_start: Optional - A sequence of 0 or more characters that marks the beginning of the map.
#!                   Default value: {'.
#!                   Valid values: Any value.
#! @input map_end: Optional - A sequence of 0 or more characters that marks the end of the map.
#!                 Default value: '}.
#!                 Valid values: Any value.
#!
#! @output return_result: The map with the added key if operation succeeded. Otherwise it will contain the message of the exception.
#! @output return_code: 0 if operation succeeded, -1 otherwise.
#! @output exception: The exception's stack trace if operation failed. Empty otherwise.
#!
#! @result SUCCESS: The key was successfully added to the map.
#! @result FAILURE: An error occurred.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.maps

operation:
  name: add_key

  inputs:
    - map:
        default: "{''}"
        required: false
    - key:
        default: 'NULL'
        required: false
    - value:
        default: 'NULL'
        required: false
    - pair_delimiter:
        default: "':'"
        required: false
    - pairDelimiter:
        default: ${pair_delimiter}
        private: true
    - entry_delimiter:
        default: "','"
        required: false
    - entryDelimiter:
        default: ${entry_delimiter}
        private: true
    - map_start:
        default: "{'"
        required: false
    - mapStart:
        default: ${map_start}
        private: true
    - map_end:
        default: "'}"
        required: false
    - mapEnd:
        default: ${map_end}
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-maps:0.0.1-RC2'
    class_name: io.cloudslang.content.maps.actions.AddKeyAction
    method_name: execute


  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
