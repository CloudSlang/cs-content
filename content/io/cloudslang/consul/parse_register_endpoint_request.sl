#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Creates a JSON for request to register a new endpoint.
#! @input node: node name
#! @input address: node host - Default: ''
#! @input datacenter: optional - Default: ''; matched to that of agent
#! @input service: optional - if Service key is provided, then service will also be registered - Default: ''
#! @input check: optional - if the Check key is provided, then a health check will also be registered - Default: ''
#! @output return_result: response of the operation
#! @output error_message: return_result if there was an error
#! @output return_code: '0' if parsing was successful, '-1' otherwise
#! @output json_request: JSON request for registering endpoint
#! @result SUCCESS: parsing was successful (return_code == '0')
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.consul

operation:
  name: parse_register_endpoint_request
  inputs:
    - node
    - address:
        default: ''
        required: false
    - datacenter:
        default: ''
        required: false
    - service:
        default: ''
        required: false
    - check:
        default: ''
        required: false
  python_action:
    script: |
      try:
        import json
        data = {}
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
        return_code = '0'
        return_result = 'Parsing successful.'
      except:
        return_code = '-1'
        return_result = 'Parsing error or key does not exist.'
  outputs:
    - return_result
    - error_message: ${return_result if return_code == '-1' else ''}
    - return_code
    - json_request
  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE
