#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Retrieves the status of the server.
#
# Inputs:
#   - response_body - response of get_openstack_server_details operation
# Outputs:
#   - server_status - status of the server
#   - return_result - was parsing was successful or not
#   - return_code - 0 if parsing was successful, -1 otherwise
#   - error_message - error message
# Results:
#   - SUCCESS - parsing was successful (returnCode == '0')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.openstack.utils

operation:
  name: get_server_status
  inputs:
    - response_body


  action:
    python_script: |
      try:
        import json
        json_list = json.loads(response_body)['server']
        server_status=json_list['status']
        return_code = 0
        return_result = 'Parsing successful.'
      except:
            return_code = '-1'
            return_result = 'Parsing error.'

  outputs:
    - return_result
    - server_status

  results:
    - SUCCESS
    - FAILURE
