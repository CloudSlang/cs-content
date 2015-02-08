#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will parse the response of the cAdviser container information and have the
#   decoded as output.
#
#   Inputs:
#       -jsonResponse - response of the cAdviser container information
#   Outputs:
#       - decoded - parse response
#       - returnResult - notification string which says if parsing was successful or not
#       - returnCode - 0 if parsing was successful, -1 otherwise
#       - errorMessage - returnResult if there was an error
#   Results:
#       - SUCCESS - parsing was successful (returnCode == '0')
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.docker.maintenance

operation:
      name: parse_cadvisor_container
      inputs:
        - jsonResponse
      action:
        python_script: |
          try:
            import json
            decoded = json.loads(jsonResponse)
            for key, value in decoded.items():
              stats= value['stats'][len(value['stats'])-1]
              spec = value['spec']
            cpu=stats['cpu']
            memory=stats['memory']
            network=stats['network']
            timestamp=stats['timestamp']
            returnCode = '0'
            returnResult = 'Parsing successful.'
          except:
            returnCode = '-1'
            returnResult = 'Parsing error.'
      outputs:
        - decoded
        - spec
        - stats
        - timestamp
        - cpu
        - memory
        - network
        - returnCode
        - returnResult
        - errorMessage: returnResult if returnCode == '-1' else ''
      results:
        - SUCCESS: returnCode == '0'
        - FAILURE