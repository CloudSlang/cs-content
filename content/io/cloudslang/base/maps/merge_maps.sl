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
#! @description: Merges two maps into one map.
#!
#! The maps can have different structures, but the resulted map will keep the map1's structure.
#! If a key exists in both maps, the result map will contain it only once, with the value found in map2.
#!
#! Examples:
#! map1=|A|1|\n|B|2| map1_pair_delimiter=| map1_entry_delimiter=|\n| map1_start=| map1_end=|
#! map2={"A":"1","B":"5","C":"6"} map2_pair_delimiter=: map2_entry_delimiter=, map2_start={ map2_end=} map2_element_wrapper="
#! return_result = |A|1|\n|B|5|\n|C|6|
#!
#! Notes:
#! 1. CRLF will be replaced with LF for proper handling.
#! 2. Map keys and values must NOT contain any character from pair_delimiter, entry_delimiter, map_start, map_end or element_wrapper.
#!
#! @input map1: Optional - The first map to merge.
#!              Example: {a:1,b:2,c:3,d:4}, {"a": "1","b": "2"}, Apples=3;Oranges=2
#!              Valid values: Any string representing a valid map according to specified delimiters
#!              (map1_pair_delimiter, map1_entry_delimiter, map1_start, map1_end, map1_element_wrapper).
#! @input map1_pair_delimiter: The separator to use for splitting map1's key-value pairs into key, respectively value.
#!                             Valid values: Any value that does not contain map1_entry_delimiter and has no common characters with map1_element_wrapper.
#! @input map1_entry_delimiter: The separator to use for splitting map1 into entries.
#!                              Valid values: Any value that does not have common characters with map1_element_wrapper.
#! @input map1_start: Optional - A sequence of 0 or more characters that marks the beginning of map1.
#! @input map1_end: Optional - A sequence of 0 or more characters that marks the end of map1.
#! @input map1_element_wrapper: Optional - A sequence of 0 or more characters that marks the beginning and the end of a key or value from map1.
#!                              Valid values: Any value that does not have common characters with map1_pair_delimiter or map1_entry_delimiter.
#! @input map2: Optional - The first map to merge.
#!              Example: {a:1,b:2,c:3,d:4}, {"a": "1","b": "2"}, Apples=3;Oranges=2
#!              Valid values: Any string representing a valid map according to specified delimiters
#!              (map2_pair_delimiter, map2_entry_delimiter, map2_start, map2_end, map2_element_wrapper).
#! @input map2_pair_delimiter: The separator to use for splitting map2's key-value pairs into key, respectively value.
#!                             Valid values: Any value that does not contain map2_entry_delimiter and has no common characters with map2_element_wrapper.
#! @input map2_entry_delimiter: The separator to use for splitting map2 into entries.
#!                              Valid values: Any value that does not have common characters with map2_element_wrapper.
#! @input map2_start: Optional - A sequence of 0 or more characters that marks the beginning of map2.
#! @input map2_end: Optional - A sequence of 0 or more characters that marks the end of map2.
#! @input map2_element_wrapper: Optional - A sequence of 0 or more characters that marks the beginning and the end of a key or value from map2.
#!                              Valid values: Any value that does not have common characters with map2_pair_delimiter or map2_entry_delimiter.
#! @input strip_whitespaces: Optional - True if leading and trailing whitespaces should be removed from the keys and values of map1 and map2.
#!                           Default: false.
#!                           Valid values: true, false.
#! @input handle_empty_value: Optional - If the value is empty and this input is true it will fill the value with NULL.
#!                            Default value: false.
#!                            Valid values: true, false.
#!
#! @output return_result: The map resulted from the merge of map1 and map2. Otherwise, it will contain the message of the exception.
#! @output return_code: 0 if operation succeeded, -1 otherwise.
#! @output exception: The exception's stack trace if operation failed. Empty otherwise.
#!
#! @result SUCCESS: The maps were successfully merged.
#! @result FAILURE: An error occurred.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.maps

operation:
  name: merge_maps

  inputs:
    - map1:
        required: false
    - map1_pair_delimiter
    - map1PairDelimiter:
        default: ${get("map1_pair_delimiter", "")}
        private: true
    - map1_entry_delimiter
    - map1EntryDelimiter:
        default: ${get("map1_entry_delimiter", "")}
        private: true
    - map1_start:
        required: false
    - map1Start:
        default: ${get("map1_start", "")}
        required: false
        private: true
    - map1_end:
        required: false
    - map1End:
        default: ${get("map1_end", "")}
        required: false
        private: true
    - map1_element_wrapper:
        required: false
    - map1ElementWrapper:
        default: ${get("map1_element_wrapper", "")}
        required: false
        private: true
    - map2:
        required: false
    - map2_pair_delimiter
    - map2PairDelimiter:
        default: ${get("map2_pair_delimiter", "")}
        private: true
    - map2_entry_delimiter
    - map2EntryDelimiter:
        default: ${get("map2_entry_delimiter", "")}
        private: true
    - map2_start:
        required: false
    - map2Start:
        default: ${get("map2_start", "")}
        required: false
        private: true
    - map2_end:
        required: false
    - map2End:
        default: ${get("map2_end", "")}
        required: false
        private: true
    - map2_element_wrapper:
        required: false
    - map2ElementWrapper:
        default: ${get("map2_element_wrapper", "")}
        required: false
        private: true
    - strip_whitespaces:
        default: "false"
        required: false
    - stripWhitespaces:
        default: ${get("strip_whitespaces", "")}
        required: false
        private: true
    - handle_empty_value:
        default: "false"
        required: false
    - handleEmptyValue:
        default: ${get("handle_empty_value", "")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-maps:0.0.1-RC13'
    class_name: io.cloudslang.content.maps.actions.MergeMapsAction
    method_name: execute


  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
