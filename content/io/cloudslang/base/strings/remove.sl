#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description: Removes text in string.
#! @input string: string   - Example: "SPAMgood morning"
#! @input text: text which need to be removed - Example: "SPAM"
#! @output new_string: string after removing - Example: "good morning"
#!!#
####################################################

namespace: io.cloudslang.base.strings

operation:
  name: remove
  inputs:
    - origin_string
    - text
  python_action:
    script: |
      if text in string:
         newString = string.replace(text, "")
      else:
         new_string = origin_string
  outputs:
    - new_string
