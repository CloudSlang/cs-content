namespace: io.cloudslang.base.strings

imports:
  strings: io.cloudslang.base.strings

flow:
  name: test_string_occurrence_counter
  inputs:
    - string_in_which_to_search
    - string_to_find
    - ignore_case
    - expected_output
  workflow:
    - test_string_occurrence_counter_operation:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search
            - string_to_find
            - ignore_case
        publish:
          - return_result
        navigate:
          SUCCESS: verify_returned_output
          FAILURE: verify_0_output
    - verify_returned_output:
        do:
          strings.string_equals:
            - first_string: str(expected_output)
            - second_string: str(return_result)
        navigate:
          SUCCESS: SUCCESS
          FAILURE: DIFFERENT_OUTPUTS
    - verify_0_output:
        do:
          strings.string_equals:
            - first_string: str(expected_output)
            - second_string: str(return_result)
        navigate:
          SUCCESS: FAILURE
          FAILURE: DIFFERENT_OUTPUTS

  results:
    - SUCCESS
    - FAILURE
    - DIFFERENT_OUTPUTS