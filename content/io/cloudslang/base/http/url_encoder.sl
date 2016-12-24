#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Encodes data for usage in a url.
#!
#! @input data: data to encode
#! @input safe: Optional - characters that should not be encoded
#! @input quote_plus: Optional - if true, will replace spaces with plus signs
#!
#! @output result: encoded string
#!
#! @result SUCCESS: data was encoded successfully
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.base.http

operation:
  name: url_encoder
  inputs:
    - data
    - safe:
        required: false
        default: ""
    - quote_plus:
        required: false
        default: "false"

  python_action:
    script: |
      import urllib
      if quote_plus.lower() == 'true':
        encoded = urllib.quote_plus(data, safe)
      else:
        encoded = urllib.quote(data, safe)

  outputs:
    - result: ${encoded}

  results:
    - SUCCESS: ${ encoded != None }
    - FAILURE
