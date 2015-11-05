#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Adds a value to the given JSON at the key represented by the key_list if one doesn't already exist
# or replaces the value at the key represented by the key_list if one already exists
#
# Inputs:
#   - json_input - JSON data input
#   - key_list - list of keys to add - Example: ['tags', 1, 'name']
#   - value - value to associate with key
# Outputs:
#   - json_output - JSON with keys:value added
#   - return_result - parsing was successful or not
#   - return_code - "0" if parsing was successful, "-1" otherwise
#   - error_message - error message if there was an error when executing, empty otherwise
# Results:
#   - SUCCESS - parsing was successful (return_code == '0')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.base.json

operation:
  name: add_value
  inputs:
    - json_input
    - key_list
    - value
  action:
    python_script: |
      try:
        import json
        if len(key_list) > 0:
          decoded = json.loads(json_input)
          temp = decoded
          for key in key_list[:-1]:
            temp = temp[key]
          temp[key_list[-1]] = value
        else:
          decoded = value
        encoded = json.dumps(decoded)
        return_code = '0'
        return_result = 'Parsing successful.'
      except Exception as ex:
        return_result = ex
        return_code = '-1'
  outputs:
    - json_output: encoded if return_code == '0' else ''
    - return_result
    - return_code
    - error_message: return_result if return_code == '-1' else ''
  results:
    - SUCCESS: return_code == '0'
    - FAILURE