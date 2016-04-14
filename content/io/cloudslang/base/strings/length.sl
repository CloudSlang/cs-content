#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description: Appends text to string.
#! @input string: string   - Example: "good"
#! @output result: length of string
#! @result SUCCESS: always
#!!#
####################################################

namespace: io.cloudslang.base.strings

operation:
  name: length
  inputs:
    - string
  action:
    python_script: |
      result = len(string)
  outputs:
    - result: ${result}
  results:
    - SUCCESS
