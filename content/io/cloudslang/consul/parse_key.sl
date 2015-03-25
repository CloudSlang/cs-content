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
#   - key -key name
#   - flags - key flags
#   - create_index- key create index
#   - value - key value
#   - modify_index - key modify index
#   - lock_index - key lock index
#   - returnCode - 0 if parsing was successful, -1 otherwise
#   - returnResult - response of the operation
#   - errorMessage - returnResult if there was an error
# Results:
#   - SUCCESS - parsing was successful (returnCode == '0')
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
        decoded = json.loads(json_response)
        decoded= decoded[0]
        key=decoded['Key']
        flags=decoded['Flags']
        create_index=decoded['CreateIndex']
        value=decoded['Value']
        modify_index=decoded['ModifyIndex']
        lock_index=decoded['LockIndex']
        returnCode = '0'
        returnResult = 'Parsing successful.'
      except:
        returnCode = '-1'
        returnResult = 'Parsing error or key does not exist.'
  outputs:
    - decoded
    - key
    - flags
    - create_index
    - value
    - modify_index
    - lock_index
    - returnCode
    - returnResult
    - errorMessage: returnResult if returnCode == '-1' else ''
  results:
    - SUCCESS: returnCode == '0'
    - FAILURE