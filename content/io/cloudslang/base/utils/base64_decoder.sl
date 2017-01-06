#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Decodes a Base64-encoded string into a clear string.
#!
#! @input data: String to decode.
#! @input character_set: The character decoding used for the data string. If you do not specify a value for this input,
#!                       it uses the system's default character decoding.
#!                       Examples: UTF-8, ISO-8859-1, US-ASCII or Shift_JIS.
#!
#! @output result: Decoded string.
#!
#! @result SUCCESS: Operation completed successfully.
#! @result FAILURE: Operation failed.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.utils

operation:
  name: base64_decoder

  inputs:
    - data
    - character_set:
        required: false
        default: 'UTF-8'

  python_action:
    script: |
      import base64
      decoded = base64.b64decode(data).decode(character_set)

  outputs:
    - result: ${decoded}

  results:
    - SUCCESS: ${ decoded != None }
    - FAILURE
