#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Creates JSON for request to register new endpoint.
#
# Inputs:
#   - node - node name
#   - address - node host
#   - datacenter - optional - Default: matched to that of agent
#   - service - optional - if Service key is provided, then service will also be registered
#   - check - optional - if the Check key is provided, then a health check will also be registered
# Outputs:
#   - json_request - JSON request for registering endpoint
#   - returnCode - 0 if parsing was successful, -1 otherwise
#   - returnResult - response of the operation
#   - errorMessage - returnResult if there was an error
# Results:
#   - SUCCESS - parsing was successful (returnCode == '0')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.consul

operation:
  name: parse_register_endpoint_request
  inputs:
    - node
    - address:
        default: "''"
        required: false
    - datacenter:
        default: "''"
        required: false
    - service:
        default: "''"
        required: false
    - check:
        default: "''"
        required: false
  action:
    python_script: |
      try:
        import json
        data= {}
        data['Node'] = node
        if address != '':
          data['Address'] = address
        if datacenter != '':
          data['Datacenter'] = datacenter
        if service != '':
          data['Service'] = json.loads(service)
        if check != '':
          data['Check'] = json.loads(check)
        json_request = json.dumps(data)
        returnCode = '0'
        returnResult = 'Parsing successful.'
      except:
        returnCode = '-1'
        returnResult = 'Parsing error or key does not exist.'
  outputs:
    - json_request
    - returnCode
    - returnResult
    - errorMessage: returnResult if returnCode == '-1' else ''
  results:
    - SUCCESS: returnCode == '0'
    - FAILURE