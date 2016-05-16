#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Checks if a JSON is valid.
#! @input json_input: JSON to validate
#! @output return_result: message of validity or exception
#! @output return_code: "0" if is a valid json, "-1" otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: JSON is valid (return_code == '0')
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.base.json

operation:
  name: validate_json
  inputs:
    - json_input
  python_action:
    script: |
      try:
        import json
        decoded = json.loads(json_input)
        return_result = 'Valid JSON'
        return_code = '0'
      except Exception as ex:
        return_result = ex
        return_code = '-1'
  outputs:
    - return_result
    - return_code
    - error_message: ${ return_result if return_code == '-1' else '' }
  results:
    - SUCCESS: ${ return_code == '0' }
    - FAILURE
