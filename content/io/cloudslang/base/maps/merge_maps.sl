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
#! @description: Merges 2 maps into one map.
#!
#! The maps can have different structures, but the resulted map will keep the map1's structure.
#! If a key exists in both maps, the result map will contain it only once, with the value found in map2.
#!
#! Examples:
#! map1=|A|1||B|2|, map1_pair_delimiter=|, map1_entry_delimiter=||, map1_start=|, map1_end=|
#! map2={'A':'1','B':'5','C':'6'}, map2_pair_delimiter=':', map2_entry_delimiter=',', map2_start={', map2_end='}
#! return_result = |A|1||B|5||C|6|
#!
#! @input map1: Optional - The first map to merge.
#!              Example: {a:1,b:2,c:3,d:4}, <John|1||George|2>, Apples=3;Oranges=2
#!              Default: {''}.
#!              Valid values: Any string representing a valid map according to specified delimiters
#!              (map1_pair_delimiter, map1_entry_delimiter, map1_start, map1_end).
#! @input map1_pair_delimiter: Optional - The separator to use for splitting map1's key-value pairs into key, respectively value.
#!                             Default value: ':'.
#!                             Valid values: Any value that does not contain or is equal to map1_entry_delimiter.
#! @input map1_entry_delimiter: Optional - The separator to use for splitting map1 into entries.
#!                              Default value: ','.
#!                              Valid values: Any value.
#! @input map1_start: Optional - A sequence of 0 or more characters that marks the beginning of the map1.
#!                    Default value: {'.
#!                    Valid values: Any value.
#! @input map1_end: Optional - A sequence of 0 or more characters that marks the end of the map1.
#!                  Default value: '}.
#!                  Valid values: Any value.
#! @input map2: Optional - The second map to merge.
#!              Example: {a:1,b:2,c:3,d:4}, <John|1||George|2>, Apples=3;Oranges=2
#!              Default: {''}.
#!              Valid values: Any string representing a valid map according to specified delimiters
#!              (map2_pair_delimiter, map2_entry_delimiter, map2_start, map2_end).
#! @input map2_pair_delimiter: Optional - The separator to use for splitting map2's key-value pairs into key, respectively value.
#!                             Default value: ':'.
#!                             Valid values: Any value that does not contain or is equal to map2_entry_delimiter.
#! @input map2_entry_delimiter: Optional - The separator to use for splitting map2 into entries.
#!                              Default value: ','.
#!                              Valid values: Any value.
#! @input map2_start: Optional - A sequence of 0 or more characters that marks the beginning of the map2.
#!                    Default value: {'.
#!                    Valid values: Any value.
#! @input map2_end: Optional - A sequence of 0 or more characters that marks the end of the map2.
#!                  Default value: '}.
#!                  Valid values: Any value.
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
        default: "{''}"
        required: false
    - map1_pair_delimiter:
        default: "':'"
        required: false
    - map1PairDelimiter:
        default: ${map1_pair_delimiter}
        private: true
    - map1_entry_delimiter:
        default: "','"
        required: false
    - map1EntryDelimiter:
        default: ${map1_entry_delimiter}
        private: true
    - map1_start:
        default: "{'"
        required: false
    - map1Start:
        default: ${map1_start}
        private: true
    - map1_end:
        default: "'}"
        required: false
    - map1End:
        default: ${map1_end}
        private: true
    - map2:
        default: "{''}"
        required: false
    - map2_pair_delimiter:
        default: "':'"
        required: false
    - map2PairDelimiter:
        default: ${map2_pair_delimiter}
        private: true
    - map2_entry_delimiter:
        default: "','"
        required: false
    - map2EntryDelimiter:
        default: ${map2_entry_delimiter}
        private: true
    - map2_start:
        default: "{'"
        required: false
    - map2Start:
        default: ${map2_start}
        private: true
    - map2_end:
        default: "'}"
        required: false
    - map2End:
        default: ${map2_end}
        private: true


  java_action:
    gav: 'io.cloudslang.content:cs-maps:0.0.1-RC2'
    class_name: io.cloudslang.content.maps.actions.MergeMapsAction
    method_name: execute


  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
