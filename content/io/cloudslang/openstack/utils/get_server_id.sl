#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Retrieves the serverID from the response of the get_openstack_servers operation of a given server by name.
#
# Inputs:
#   - server_body - response of get_openstack_servers operation
#   - server_name - server name
# Outputs:
#   - server_ID - ID of the specified server
#   - return_result - was parsing was successful or not
#   - return_code - 0 if parsing was successful, -1 otherwise
#   - error_message - error message
# Results:
#   - SUCCESS - parsing was successful (returnCode == '0')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.openstack.utils

operation:
  name: get_server_id
  inputs:
    - server_body
    - server_name
  action:
    python_script: |
      try:
        import json
        decoded = json.loads(server_body)
        server_list_Json = decoded['servers']
        nr_servers = len(server_list_Json)
        for index in range(nr_servers):
          current_server_name = server_list_Json[index]['name']
          if current_server_name == server_name:
            server_ID = server_list_Json[index]['id']
        return_code = '0'
        return_result = 'Parsing successful.'
      except:
        return_code = '-1'
        return_result = 'Parsing error.'

  outputs:
    - server_ID
    - return_result
    - return_code
    - error_message: return_result if return_code == '-1' else ''
  results:
    - SUCCESS: return_code == '0'
    - FAILURE