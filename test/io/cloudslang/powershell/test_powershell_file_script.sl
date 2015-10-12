#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.powershell

imports:
  strings: io.cloudslang.base.strings

flow:
  name: test_powershell_file_script

  inputs:
    - host
    - username
    - password
    - path_to_script

  workflow:
    - run_powershell_file_script:
        do:
          powershell_file_script:
            - host
            - username
            - password
            - path_to_script

        publish:
          - return_result
          - error_message
          - status_code
        navigate:
          SUCCESS: verify_text
          FAILURE: FAILURE

    - verify_text:
        do:
          strings.string_equals:
            - first_string: str(error_message)
            - second_string: str()
        navigate:
          SUCCESS: SUCCESS
          FAILURE: VERIFY_TEXT_FAILURE

  outputs:
    - return_result
    - error_message
    - status_code

  results:
    - SUCCESS
    - FAILURE
    - VERIFY_TEXT_FAILURE