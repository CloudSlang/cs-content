#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Performs a Bearer token request.
#!
#! @input command: POC command to generate Bearer token
#! @output auth_token: generated Bearer token
#! @result SUCCESS: Bearer token generated successfully
#! @result FAILURE: There was an error while trying to retrieve Bearer token.
#!!#
####################################################

namespace: io.cloudslang.microsoft_azure.utility

imports:
  cmd: io.cloudslang.base.cmd
  strings: io.cloudslang.base.strings

flow:
  name: get_auth_token

  inputs:
    - command: 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "& "c:\users\moldovas\desktop\azure\get_token.ps1""'

  workflow:
    - get_auth_token:
        do:
          cmd.run_command:
            - command
        publish:
          - return_result
        navigate:
          - SUCCESS: filter_response
          - FAILURE: FAILURE

    - filter_response:
        do:
          strings.match_regex:
            - regex: (?<='Common')(?s)(.*$)
            - text: ${return_result}
        publish:
          - auth_token: ${match_text.strip()}
        navigate:
          - MATCH: SUCCESS
          - NO_MATCH: FAILURE

  outputs:
    - auth_token

  results:
      - SUCCESS
      - FAILURE

