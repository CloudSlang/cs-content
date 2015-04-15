namespace: io.cloudslang.base.os

imports:
  strings: io.cloudslang.base.strings
  os: io.cloudslang.base.os
flow:
  name: test_get_os
  inputs:
    - expected_output
  workflow:
    - test_get_os_operation:
        do:
          os.get_os:
        publish:
          - message
        navigate:
          LINUX: verify_returned_output
          WINDOWS: verify_returned_output
    - verify_returned_output:
        do:
          strings.string_equals:
            - first_string: expected_output
            - second_string: "'' if message == None else message"
        navigate:
          SUCCESS: SUCCESS
          FAILURE: DIFFERENT_OUTPUTS

  results:
    - SUCCESS
    - DIFFERENT_OUTPUTS
