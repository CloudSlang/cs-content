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
#! @description: Based on the value provided in the matchType input, the operation checks either if the maps have the
#!               same entries when "equals"  is used, or checks if map1 contains map2 when "contains" is provided as a
#!               value for the matchType input.
#!               The maps can have different structures, the operation compares only the values of the entries of the
#!               maps and not the delimiters of the maps.
#!
#! Examples:
#! 1. map1
#!    map = {one:whatever2, 1:whatever1, 3:Whatever1}
#!    pair_delimiter = :
#!    entry_delimiter = ,
#!    map_start = {
#!    map_end = }
#!    map2
#!    map = {one=whatever2, 1=whatever1}
#!    pair_delimiter = =
#!    entry_delimiter = ,
#!    map_start = {
#!    map_end = }
#!    matchType = contains
#!    ignoreCase = true
#!
#!    return_result = true
#!
#! Notes:
#! 1. CRLF will be replaced with LF for proper handling.
#! 2. Map keys and values must NOT contain any character from pair_delimiter, entry_delimiter, map_start, map_end or element_wrapper.
#!
#! @input map_1: The map where the entries from map 2 are searched.
#!               Example: {a:1,b:2,c:3,d:4}, Apples=3;Oranges=2
#!               Valid values: Any string representing a valid map according to specified delimiters
#!               (map1_pair_delimiter, map1_entry_delimiter, map1_start, map1_end, map1_element_wrapper).
#! @input map_1_pair_delimiter: The separator to use for splitting map1's key-value pairs into key, respectively value.
#!                              Valid values: Any value that does not contain map1_entry_delimiter and has no common
#!                              characters with map1_element_wrapper.
#! @input map_1_entry_delimiter: The separator to use for splitting map1 into entries.
#!                              Valid values: Any value that does not have common characters with map1_element_wrapper.
#! @input map_1_start: Optional - A sequence of 0 or more characters that marks the beginning of map1.
#! @input map_1_end: Optional - A sequence of 0 or more characters that marks the end of map1.
#! @input map_1_element_wrapper: Optional - A sequence of 0 or more characters that marks the beginning and the end of
#!                               a key or value from map1.
#!                               Valid values: Any value that does not have common characters with map1_pair_delimiter
#!                               or map1_entry_delimiter.
#! @input map_2: The map that is compared with map1.
#!               Example: {a:1,b:2,c:3,d:4}, {"a": "1","b": "2"}, Apples=3;Oranges=2
#!               Valid values: Any string representing a valid map according to specified delimiters
#!               (map2_pair_delimiter, map2_entry_delimiter, map2_start, map2_end, map2_element_wrapper).
#! @input map_2_pair_delimiter: The separator to use for splitting map2's key-value pairs into key, respectively value.
#!                              Valid values: Any value that does not contain map2_entry_delimiter and has no common
#!                              characters with map2_element_wrapper.
#! @input map_2_entry_delimiter: The separator to use for splitting map2 into entries.
#!                               Valid values: Any value that does not have common characters with map2_element_wrapper.
#! @input map_2_start: Optional - A sequence of 0 or more characters that marks the beginning of map2.
#! @input map_2_end: Optional - A sequence of 0 or more characters that marks the end of map2.
#! @input map_2_element_wrapper: Optional - A sequence of 0 or more characters that marks the beginning and the end of a
#!                               key or value from map2.
#!                               Valid values: Any value that does not have common characters with map2_pair_delimiter
#!                               or map2_entry_delimiter.
#! @input match_type: 
#! @input strip_whitespaces: Optional - True if leading and trailing whitespaces should be removed from the keys and
#!                           values of map1 and map2.
#!                           Default: false.
#!                           Valid values: true, false.
#! @input ignore_case: The matching options which should be used on the maps.
#!                     When "equals" is used the operation validates if the provided maps have the same entries.
#!                     When "contains" is used the operation checks if map1 contains map2.
#!                     Valid values: "equals"  or "contains"
#!
#! @output return_result: True if the map are equal or if map1 contains map2(based on the provided value for the matchType
#!                        input). False if the map1 is not equal or if it doesn't contain map2. Otherwise, it will
#!                        contain the message of the exception.
#! @output return_code: 0 if operation succeeded, -1 otherwise.
#! @output exception: The exception's stack trace if operation failed. Empty otherwise.
#!
#! @result SUCCESS: The maps were compared successfully.
#! @result FAILURE: An error occurred.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.maps

operation: 
  name: map_comparator
  
  inputs: 
    - map_1    
    - map1: 
        default: ${get('map_1', '')}  
        required: false 
        private: true 
    - map_1_pair_delimiter    
    - map1PairDelimiter: 
        default: ${get('map_1_pair_delimiter', '')}  
        required: false 
        private: true 
    - map_1_entry_delimiter    
    - map1EntryDelimiter: 
        default: ${get('map_1_entry_delimiter', '')}  
        required: false 
        private: true 
    - map_1_start:  
        required: false  
    - map1Start: 
        default: ${get('map_1_start', '')}  
        required: false 
        private: true 
    - map_1_end:  
        required: false  
    - map1End: 
        default: ${get('map_1_end', '')}  
        required: false 
        private: true 
    - map_1_element_wrapper:  
        required: false  
    - map1ElementWrapper: 
        default: ${get('map_1_element_wrapper', '')}  
        required: false 
        private: true 
    - map_2    
    - map2: 
        default: ${get('map_2', '')}  
        required: false 
        private: true 
    - map_2_pair_delimiter    
    - map2PairDelimiter: 
        default: ${get('map_2_pair_delimiter', '')}  
        required: false 
        private: true 
    - map_2_entry_delimiter    
    - map2EntryDelimiter: 
        default: ${get('map_2_entry_delimiter', '')}  
        required: false 
        private: true 
    - map_2_start:  
        required: false  
    - map2Start: 
        default: ${get('map_2_start', '')}  
        required: false 
        private: true 
    - map_2_end:  
        required: false  
    - map2End: 
        default: ${get('map_2_end', '')}  
        required: false 
        private: true 
    - map_2_element_wrapper:  
        required: false  
    - map2ElementWrapper: 
        default: ${get('map_2_element_wrapper', '')}  
        required: false 
        private: true 
    - match_type    
    - matchType: 
        default: ${get('match_type', '')}  
        required: true
        private: true 
    - strip_whitespaces:  
        required: false  
    - stripWhitespaces: 
        default: ${get('strip_whitespaces', '')}  
        required: false 
        private: true 
    - ignore_case:  
        required: false  
    - ignoreCase: 
        default: ${get('ignore_case', '')}  
        required: false 
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-maps:0.0.1-RC13'
    class_name: io.cloudslang.content.maps.actions.MapComparatorAction
    method_name: execute
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - return_code: ${get('returnCode', '')} 
    - exception: ${get('exception', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
