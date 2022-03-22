########################################################################################################################
#!!
#! @description: This is a sample flow that demonstrates how to add a key-value pair to a JSON formatted map, using the add_key operation from the maps folder.
#!
#! @input map: Optional - The map to add a key to.
#!             Example: {a:1,b:2,c:3,d:4}, {"a": "1","b": "2"}, Apples=3;Oranges=2
#!             Valid values: Any string representing a valid map according to specified delimiters
#!             (pair_delimiter, entry_delimiter, map_start, map_end, element_wrapper).
#! @input key: The key to add.
#! @input value: Optional - The value that will be added to the provided key.
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
#! @input handle_empty_value: Optional - If the value is empty and this input is true it will fill the value with NULL.
#!                            Default value: false.
#!                            Valid values: true, false.
#!
#! @output return_result: The map with the added key if operation succeeded. Otherwise it will contain the message of the exception.
#! @output exception: The exception's stack trace if operation failed. Empty otherwise.
#! @output return_code: 0 if operation succeeded, -1 otherwise.
#!!#
########################################################################################################################
namespace: io.cloudslang.base.samples.maps
flow:
  name: add_key_to_json_map
  inputs:
    - map:
        default: '{"A":"1","B":"2"}'
        required: true
    - key: C
    - value: '123'
    - pair_delimiter: ':'
    - entry_delimiter: ','
    - map_start: '{'
    - map_end: '}'
    - element_wrapper: '"'
    - strip_whitespaces: 'false'
    - handle_empty_value: 'false'
  workflow:
    - add_key:
        do:
          io.cloudslang.base.maps.add_key:
            - map: '${map}'
            - key: '${key}'
            - value: '${value}'
            - pair_delimiter: '${pair_delimiter}'
            - entry_delimiter: '${entry_delimiter}'
            - map_start: '${map_start}'
            - map_end: '${map_end}'
            - element_wrapper: '${element_wrapper}'
            - strip_whitespaces: '${strip_whitespaces}'
            - handle_empty_value: '${handle_empty_value}'
        publish:
          - return_result
          - exception
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result: '${return_result}'
    - exception: '${exception}'
    - return_code: '${return_code}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      add_key:
        x: 100
        'y': 150
        navigate:
          1f7b33f5-b1da-471a-394f-ae1e249654ef:
            targetId: eed382ce-badf-de0c-15d5-e87790826833
            port: SUCCESS
    results:
      SUCCESS:
        eed382ce-badf-de0c-15d5-e87790826833:
          x: 400
          'y': 150
