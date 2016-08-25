#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Gets parent from the response of inspect_image.sl.
#! @input json_response: response of inspect_container operation
#! @output parent_image: parent image parsed from the response
#! @output return_result: was parsing was successful or not
#! @output return_code: '0' if parsing was successful, '-1' otherwise
#! @output error_message: returnResult if there was an error
#! @result SUCCESS: parsing was successful (return_code == '0')
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.docker.utils

operation:
  name: parse_inspect_for_parent
  inputs:
    - json_response
  python_action:
    script: |
      try:
        import json
        decoded = json.loads(json_response)
        parent_image = decoded[0]['Parent']
        parent_image = parent_image[:-1]
        return_code = '0'
        return_result = 'Parsing successful.'
      except:
        return_code = '-1'
        return_result = 'Parsing error.'
  outputs:
    - parent_image
    - return_result
    - return_code
    - error_message: ${return_result if return_code == '-1' else ''}
  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE
