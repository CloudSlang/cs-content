#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: rounds a float by converting it to integer and saving it as a string.
#! @input value1: string which represents a float, with or without a percentage - Example: "58.44%"
#! @output error_message: error message if error occurred
#! @result SUCCESS: the value was rounded successfully
#! @result FAILURE: input was not in correct format
#!!#
####################################################

namespace: io.cloudslang.base.math

operation:
  name: round
  inputs:
    - value1
  python_action:
    script: |
      error_message = ""
      result = ""
      value1 = value1.replace("%", "")
      try:
             rounded = str(int(float(value1)))
      except ValueError:
          error_message = "input cannot be rounded"
  outputs:
    - error_message
    - rounded
  results:
    - SUCCESS: ${error_message == ""}
    - FAILURE
