#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   Create json for reques to register new endpoint
#
#   Inputs:
#       - node - node name
#       - address -node host
#       - datacenter - optional (can be empty) - defaulted to match that of the agent
#       - service - optional (can be empty) - If the Service key is provided, then the service will also be registered
#       - check - optional (can be empty) - If the Check key is provided, then a health check will also be registered
#   Outputs:
#       - json_request - json request for register endpoint
#       - returnCode - 0 if parsing was successful, -1 otherwise
#       - errorMessage - returnResult if there was an error
#   Results:
#       - SUCCESS - parsing was successful (returnCode == '0')
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.consul

operation:
      name: parse_register_endpoint_request
      inputs:
        - node
        - address
        - datacenter
        - service
        - check
      action:
        python_script: |
          try:
            import json
            data= {}
            data['Node'] = node
            data['Address'] = address
            if datacenter != '':
              data['Datacenter'] = datacenter
            if service != '':
              data['Service'] = service
            if check != '':
              data['Check'] = check
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