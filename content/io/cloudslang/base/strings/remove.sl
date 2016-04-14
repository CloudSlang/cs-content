#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description: Removes text in string.
#! @input string: string   - Example: "SPAMgood morning"
#! @input text: text witch need to be removed - Example: "SPAM"
#! @output result: string after removing - Example: "good morning"
#!!#
####################################################

namespace: io.cloudslang.base.strings

operation:
  name: remove
  inputs:
    - string
    - text
  action:
    python_script: |
      if text in string:
         newString = string.replace(text, "")
      else:
         newString = origin_string
  outputs:
    - result: ${newString}
