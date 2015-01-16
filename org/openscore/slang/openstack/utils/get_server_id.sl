#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will get the serverID of a server with its name specified as an input
#   from the response of the get_openstack_servers operation
#
#   Inputs:
#       - server_body - response of the get_openstack_servers operation
#       - server_name - server name
#   Outputs:
#       - serverID
#       - errorMessage
#   Results:
#       - SUCCESS - parsing was successful (returnCode == '0')
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.openstack.utils

operations:
  - get_server_id:
      inputs:
        - server_body
        - server_name
      action:
        python_script: |
          try:
            import json
            decoded = json.loads(server_body)
            serverListJson = decoded['servers']
            nrServers = len(serverListJson)
            for index in range(nrServers):
              currentServerName = serverListJson[index]['name']
              if currentServerName == server_name:
                serverID = serverListJson[index]['id']
            returnCode = '0'
            returnResult = 'Parsing successful.'
          except:
            returnCode = '-1'
            returnResult = 'Parsing error.'

      outputs:
        - serverID
        - returnResult
        - returnCode
        - errorMessage: returnResult if returnCode == '-1' else ''