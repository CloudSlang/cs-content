#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation build a list with server names from the response of the get_openstack_servers operation.
#
#   Inputs:
#       - server_body - response of the get_openstack_servers operation
#   Outputs:
#       - serverList - list with server names
#       - returnResult - notification string which says if parsing was successful or not
#       - returnCode - 0 if parsing was successful, -1 otherwise
#       - errorMessage - returnResult if there was an error
#   Results:
#       - SUCCESS - parsing was successful (returnCode == '0')
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.openstack.utils

operations:
  - extract_servers:
      inputs:
        - server_body
      action:
        python_script: |
          try:
            import json
            decoded = json.loads(server_body)
            serverListJson = decoded['servers']
            nrServers = len(serverListJson)
            serverList = ''
            for index in range(nrServers):
              serverName = serverListJson[index]['name']
              serverList = serverList + serverName + ','
            serverList = serverList[:-1]
            returnCode = '0'
            returnResult = 'Parsing successful.'
          except:
            returnCode = '-1'
            returnResult = 'Parsing error.'
      outputs:
        - serverList
        - returnResult
        - returnCode
        - errorMessage: returnResult if returnCode == '-1' else ''

      results:
        - SUCCESS: returnCode == '0'
        - FAILURE