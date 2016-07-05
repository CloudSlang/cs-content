namespace: io.cloudslang.base.json

imports:
  strings: io.cloudslang.base.strings
  print: io.cloudslang.base.print

flow:
  name: test_get_keys

  inputs:
    - json_input
    - json_path
    - expected_keys

  workflow:
    - getKeys:
        do:
          get_keys:
            - json_input
            - json_path

        publish:
          - json_keys: ${str(keys)}
          - return_code

        navigate:
          - SUCCESS: verify_keys
          - FAILURE: GET_FAILURE

    - verify_keys:
        loop:
          for: current_key in expected_keys
          do:
            strings.string_occurrence_counter:
              - string_in_which_to_search: ${json_keys}
              - string_to_find: ${current_key}

        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: KEY_MISSING_FAILURE

  results:
    - SUCCESS
    - GET_FAILURE
    - KEY_MISSING_FAILURE
    - FAILURE