#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Retrieves the server id from the response of the get_openstack_servers operation of a given server by name.
#
# Inputs:
#   - server_body - response of get_openstack_servers operation
#   - server_name - server name
# Outputs:
#   - server_id - ID of the specified server
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
        servers = json.loads(server_body)['servers']
        matched_server = next(server for server in servers if server['name'] == server_name)
        server_id = matched_server['id']
        return_code = '0'
        return_result = 'Parsing successful.'
      except StopIteration:
        return_code = '-1'
        return_result = 'No servers in list'
      except  ValueError:
        return_code = '-1'
        return_result = 'Parsing error., '

  outputs:
    - server_id
    - return_result
    - return_code
    - error_message: return_result if return_code == '-1' else ''
  results:
    - SUCCESS: return_code == '0'
    - FAILURE