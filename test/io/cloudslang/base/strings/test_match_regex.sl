namespace: io.cloudslang.base.strings

imports:
  strings: io.cloudslang.base.strings

flow:
  name: test_match_regex
  inputs:
    - regex
    - text
    - expected_output
  workflow:
    - test_match_regex_operation:
        do:
          strings.match_regex:
            - regex
            - text
        publish:
          - match_text
        navigate:
          MATCH: verify_returned_output
          NO_MATCH: verify_output_is_empty
    - verify_returned_output:
        do:
          strings.string_equals:
            - first_string: expected_output
            - second_string: match_text
        navigate:
          SUCCESS: MATCH
          FAILURE: DIFFERENT_OUTPUTS
    - verify_output_is_empty:
        do:
          strings.string_equals:
            - first_string: expected_output
            - second_string: match_text
        navigate:
          SUCCESS: NO_MATCH
          FAILURE: DIFFERENT_OUTPUTS

  results:
    - MATCH
    - NO_MATCH
    - DIFFERENT_OUTPUTS


