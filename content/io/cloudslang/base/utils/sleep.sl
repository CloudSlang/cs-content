#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Sleeps for a given number of seconds.
#!
#! @input seconds: Time to sleep.
#!
#! @output message: Sleep completed successfully.
#! @output error_message: If there is an exception or error message.
#!
#! @result SUCCESS: Sleep successful.
#! @result FAILURE: Something went wrong.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.utils

operation:
  name: sleep

  inputs:
    - seconds

  python_action:
    script: |
      try:
        import time
        error_message = ""
        message = ""
        x = float(seconds)
        if(x < 0):
          error_message = "timeout value is negative"
        else:
          time.sleep(x)
          message = "sleep completed successfully"
      except ValueError:
        error_message = "invalid input value"

  outputs:
      - message
      - error_message

  results:
    - SUCCESS: ${error_message==""}
    - FAILURE
