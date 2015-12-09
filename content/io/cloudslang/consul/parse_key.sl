#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Parses a JSON response holding Consul key information.
#
# Inputs:
#   - json_response - response holding Consul key information
# Outputs:
#   - decoded - parsed response
#   - key - key name
#   - flags - key flags
#   - create_index- key create index
#   - value - key value
#   - modify_index - key modify index
#   - lock_index - key lock index
#   - return_result - response of the operation
#   - error_message - return_result if there was an error
#   - return_code - '0' if parsing was successful, '-1' otherwise
# Results:
#   - SUCCESS - parsing was successful (return_code == '0')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.consul

operation:
  name: parse_key
  inputs:
    - json_response
  action:
    python_script: |
      try:
        import json
        import base64

        decoded = json.loads(json_response)
        decoded = decoded[0]
        key = decoded['Key']
        flags = decoded['Flags']
        create_index = decoded['CreateIndex']
        value = encoded = base64.b64decode(decoded['Value'])
        modify_index = decoded['ModifyIndex']
        lock_index = decoded['LockIndex']
        return_code = '0'
        return_result = 'Parsing successful.'
      except:
        return_code = '-1'
        return_result = 'Parsing error or key does not exist.'
  outputs:
    - decoded
    - key
    - flags
    - create_index
    - value
    - modify_index
    - lock_index
    - return_result
    - error_message: ${return_result if return_code == '-1' else ''}
    - return_code
  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE