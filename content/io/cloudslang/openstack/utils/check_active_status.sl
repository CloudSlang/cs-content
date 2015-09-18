#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Checks whether the status of server is in ACTIVE state.
#
# Inputs:
#   - server_status - response of a GET operation
# Outputs:
#   - return_result - was parsing was successful or not
#   - return_code - 0 if parsing was successful, -1 otherwise
#   - error_message - return_result if there was an error
# Results:
#   - SUCCESS - parsing was successful (return_code == '0')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.openstack.utils

operation:
  name: check_active_status
  inputs:
    - server_status

  action:
    python_script: |

        if server_status == 'ACTIVE':
          return_code = '0'
          return_result = 'Parsing successful.'
        else:
          return_code = '-1'
          return_result = 'Not in ACTIVE state.'
  outputs:

    - return_result
    - return_code
    - error_message: return_result if return_code == '-1' else ''
  results:
    - SUCCESS: return_code == '0'
    - FAILURE