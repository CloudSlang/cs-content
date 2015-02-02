#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will parse the response of the get_authentication operation and have the
#   token and tenantID as its outputs.
#
#   Inputs:
#       -jsonAuthenticationResponse - response of the get_authentication operation
#   Outputs:
#       - token - authentication token ID
#       - tenant - tenant ID
#       - returnResult - notification string which says if parsing was successful or not
#       - returnCode - 0 if parsing was successful, -1 otherwise
#       - errorMessage - returnResult if there was an error
#   Results:
#       - SUCCESS - parsing was successful (returnCode == '0')
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.openstack.utils

operation:
  name: parse_authentication
  inputs:
    - jsonAuthenticationResponse
  action:
    python_script: |
      try:
        import json
        decoded = json.loads(jsonAuthenticationResponse)
        accessJson = decoded['access']
        tokenJson = accessJson['token']
        token = tokenJson['id']
        tenantJson = tokenJson['tenant']
        tenant = tenantJson['id']
        returnCode = '0'
        returnResult = 'Parsing successful.'
      except:
        returnCode = '-1'
        returnResult = 'Parsing error.'
  outputs:
    - token
    - tenant
    - returnCode
    - returnResult
    - errorMessage: returnResult if returnCode == '-1' else ''
  results:
    - SUCCESS: returnCode == '0'
    - FAILURE