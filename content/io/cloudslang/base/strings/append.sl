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
#! @input text: text witch need to be appended - Example: " morning"
#! @output result: string after appending - Example: "good morning"
#! @result SUCCESS: always
#!!#
####################################################

namespace: io.cloudslang.base.strings

operation:
  name: append
  inputs:
    - string
    - text
  action:
    python_script: |
      string+=text
  outputs:
    - result: ${string}
  results:
    - SUCCESS
