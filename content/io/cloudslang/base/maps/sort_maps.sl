#   (c) Copyright 2022 Micro Focus, L.P.
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
#! @description: Sorts a map in ascending or descending order by keys or values.
#!
#! @input map: The map that will be sorted.
#!             Example: {a:1,b:2,c:3,d:4}, {"a": "1","b": "2"}, Apples=3;Oranges=2
#!             Valid values: Any string representing a valid map according to specified delimiters
#!             (pair_delimiter, entry_delimiter, map_start, map_end, element_wrapper).
#! @input sort_by: The map entries that will be sorted.
#!                 Valid values: key, value.
#! @input sort_order: Optional - The order in which the selected entries will be sorted.
#!                    Valid values: asc (ascending), desc (descending).
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
#! @output return_result: The sorted map, if the operation succeeded. Otherwise, it will contain the exception message.
#! @output return_code: 0 if operation succeeded, -1 otherwise.
#! @output exception: The exception"s stack trace if operation failed. Empty otherwise.
#!
#! @result SUCCESS: The map has been successfully sorted.
#! @result FAILURE: An error occurred.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.maps

operation:
  name: sort_maps

  inputs:
    - map
    - sort_by
    - sortBy:
        default: ${get("sort_by", "")}
        private: true
    - sort_order:
        required: false
    - sortOrder:
        default: ${get("sort_order", "")}
        required: false
        private: true
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
    gav: "io.cloudslang.content:cs-maps:0.0.1"
    class_name: io.cloudslang.content.maps.actions.SortMapsAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == "0"}
    - FAILURE
