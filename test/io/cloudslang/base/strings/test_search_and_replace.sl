namespace: io.cloudslang.base.strings

imports:
  strings: io.cloudslang.base.strings

flow:
  name: test_search_and_replace
  inputs:
    - origin_string
    - text_to_replace
    - replace_with
    - expected_output
  workflow:
    - test_search_and_replace_operation:
        do:
          strings.search_and_replace:
            - origin_string
            - text_to_replace
            - replace_with
        publish:
          - replaced_string
    - verify_returned_output:
        do:
          strings.string_equals:
            - first_string: expected_output
            - second_string: replaced_string
        navigate:
          SUCCESS: SUCCESS
          FAILURE: DIFFERENT_OUTPUTS

  results:
    - SUCCESS
    - FAILURE
    - DIFFERENT_OUTPUTS