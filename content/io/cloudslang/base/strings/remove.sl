#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description: Removes text from a string.
#! @input origin_string: optional - original string - Example: "SPAMgood morning"
#! @input text: optional - text to be removed - Example: "SPAM"
#! @output new_string: string after removing - Example: "good morning"
#! @result SUCCESS: text removed from string successfully
#! @result FAILURE: something went wrong while trying to remote text from the string
#!!#
####################################################

namespace: io.cloudslang.base.strings

operation:
  name: remove
  inputs:
    - origin_string:
        required: false
    - text:
        required: false
  python_action:
    script: |
      if text in origin_string:
         new_string = origin_string.replace(text, "")
      else:
         new_string = origin_string
  outputs:
    - new_string
