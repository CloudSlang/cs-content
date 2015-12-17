#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Adds or replaces a value to the given JSON at the keys or indices represented by the json_path.
# If the last key in the path does not exist, the key is added as well.
#
# Inputs:
#   - json_input - JSON data input - Example: '{"k1": {"k2": ["v1", "v2"]}}'
#   - json_path - path at which to add value represented as a list of keys and/or indices - Example: ["k1","k2",1]
#   - value - value to associate with key - Example: "v3"
# Outputs:
#   - json_output - JSON with key:value added
#   - return_result - parsing was successful or not
#   - return_code - "0" if parsing was successful, "-1" otherwise
#   - error_message - error message if there was an error when executing, empty otherwise
# Results:
#   - SUCCESS - parsing was successful (return_code == '0') and value was added
#   - FAILURE - parsing was unsuccessful or the path does not exist
####################################################

namespace: io.cloudslang.base.json

operation:
  name: add_value
  inputs:
    - json_input
    - json_path
    - value
  action:
    python_script: |
      try:
        import json
        if len(json_path) > 0:
          decoded = json.loads(json_input)
          temp = decoded
          for key in json_path[:-1]:
            temp = temp[key]
          temp[json_path[-1]] = value
        else:
          decoded = value
        encoded = json.dumps(decoded)
        return_code = '0'
        return_result = 'Parsing successful.'
      except Exception as ex:
        return_result = ex
        return_code = '-1'
  outputs:
    - json_output: ${ encoded if return_code == '0' else '' }
    - return_result
    - return_code
    - error_message: ${ return_result if return_code == '-1' else ''}
  results:
    - SUCCESS: ${ return_code == '0' }
    - FAILURE
