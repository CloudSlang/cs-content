#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Builds a list of server names from the response of the get_openstack_servers operation.
#
# Inputs:
#   - server_body - response of get_openstack_servers operation
# Outputs:
#   - server_list - list of server names
#   - return_result - was parsing was successful or not
#   - return_code - 0 if parsing was successful, -1 otherwise
#   - error_message - return_result if there was an error
# Results:
#   - SUCCESS - parsing was successful (return_code == '0')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.openstack.utils

operation:
  name: extract_servers
  inputs:
    - server_body
  action:
    python_script: |
      try:
        import json
        decoded = json.loads(server_body)
        server_list_Json = decoded['servers']
        nr_servers = len(server_list_Json)
        server_list = ''
        for index in range(nr_servers):
          server_name = server_list_Json[index]['name']
          server_list = server_list + server_name + ','
        server_list = server_list[:-1]
        return_code = '0'
        return_result = 'Parsing successful.'
      except:
        return_code = '-1'
        return_result = 'Parsing error.'
  outputs:
    - server_list
    - return_result
    - return_code
    - error_message: return_result if return_code == '-1' else ''
  results:
    - SUCCESS: return_code == '0'
    - FAILURE