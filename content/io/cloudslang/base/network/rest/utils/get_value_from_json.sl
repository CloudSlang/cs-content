#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Parses the response of the http_client_action operation to retrieve the corresponding value addressed by the keys_list input.
#
# Inputs:
#   - json_input - response of http_client_action operation
#   - key_list - the keys list to retrieve value for - ex. = ['tags', 1, 'name']
# Outputs:
#   - value - the corresponding value of the key that results from key_list input - ex. = decode['tags'][1]['name']
#   - return_result - parsing was successful or not
#   - return_code - "0" if parsing was successful, "-1" otherwise
#   - error_message - the corresponding error message if there was an error when executing otherwise left blank
# Results:
#   - SUCCESS - parsing was successful (return_code == '0')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.base.network.rest.utils

operation:
  name: get_value_from_json
  inputs:
    - json_input
    - key_list
  action:
    python_script: |
      try:
        import json
        decoded = json.loads(json_input)
        for key in key_list:
          decoded = decoded[key]
        return_code = '0'
        return_result = 'Parsing successful.'
      except Exception as ex:
        return_result = ex
        return_code = '-1'
  outputs:
    - value: decoded
    - return_result
    - return_code
    - error_message: return_result if return_code == '-1' else ''
  results:
    - SUCCESS: return_code == '0'
    - FAILURE