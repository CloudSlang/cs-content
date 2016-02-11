#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.base.powershell

flow:
  name: test_execute_powershell_script
  inputs:
    - host
    - user_name
    - password
    - script
    - winrm_enable_https:
        required: false
  workflow:
    - execute_script:
        do:
          execute_powershell_script:
            - host
            - user_name
            - password
            - script
            - winrm_enable_https
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE

  results:
    - SUCCESS
    - FAILURE
