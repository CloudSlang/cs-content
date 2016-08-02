####################################################
#!!
#! @description: Encodes data for usage in a url.
#!
#! @input data: data to encode
#! @input safe: characters that should not be encoded
#!              optional
#! @input quote_plus: if true, will replace spaces with plus signs
#!                    optional
#! @output result: encoded string
#! @result SUCCESS: data was encoded successfully
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.base.utils

operation:
  name: url_encoder
  inputs:
    - data
    - safe:
        required: false
        default: ""
    - quote_plus:
        required: false
        default: false
  python_action:
    script: |
      import urllib
      if quote_plus:
        encoded = urllib.quote_plus(data, safe)
      else:
        encoded = urllib.quote(data, safe)
  outputs:
    - result: ${encoded}

  results:
    - SUCCESS: ${ encoded != None }
    - FAILURE
