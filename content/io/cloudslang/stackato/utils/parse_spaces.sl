#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Parses the response of the get_authentication operation to retrieve the token and tenantID.
#
# Inputs:
#   - json_authentication_response - response of get_authentication operation
# Outputs:
#   - token - authentication token ID
#   - tenant - tenant ID
#   - return_result - was parsing was successful or not
#   - return_code - 0 if parsing was successful, -1 otherwise
#   - error_message - returnResult if there was an error
# Results:
#   - SUCCESS - parsing was successful (returnCode == '0')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.stackato.utils

operation:
  name: parse_spaces
  inputs:
    - json_authentication_response
    - spacename
  action:
    python_script: |
      try:
        import json
        decoded = json.loads(json_authentication_response)
        for i in decoded['resources']:
          if i['entity']['name'] == spacename:
            guid = i['metadata']['guid']
        return_code = '0'
        return_result = 'Parsing successful.'
      except:
        return_code = '-1'
        return_result = 'Parsing error.'
  outputs:
    - guid
    - return_code
    - return_result
    - error_message: return_result if return_code == '-1' else ''
  results:
    - SUCCESS: return_code == '0'
    - FAILURE