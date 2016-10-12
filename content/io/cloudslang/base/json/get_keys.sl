#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Retrieves keys from a JSON object at a given JSON path.
#! @input json_input: JSON from which to retrieve keys - Example: '{"k1": {"k2": {"k3":"v3"}}}'
#! @input json_path: path from which to retrieve key represented as a list of keys and/or indices.
#!                   Passing an empty list ([]) will retrieve top level keys. - Example: ["k1", "k2"]
#! @output return_result: if any keys were found, list of keys found
#!               A JSON object is an unordered set of key/value pairs, therefore the order of the keys returned is arbitrary.
#! @output return_code: "0" if parsing was successful, "-1" otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: parsing was successful (return_code == '0')
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.base.json

operation:
  name: get_keys
  inputs:
    - json_input
    - json_path:
        required: false

  python_action:
    script: |
      try:
        import json,re
        quote = None
        for c in json_input:
          if c in ['\'', '\"']:
            quote = c
            break
        if quote == '\'':
          json_input = str(re.sub(r"(?<!\\)(\')",'"', json_input))
          json_input = str(re.sub(r"(\\')",'\'', json_input))
        decoded = json.loads(json_input)
        for key in json_path.split(","):
          if key in ["", ''] and key not in decoded:
            pass
          else:
            decoded = decoded[key]
        decoded = decoded.keys()
        encoded = json.dumps(decoded, ensure_ascii=False)
        if quote == '\'':
          encoded = encoded.replace('\'','\\\'').replace('\"','\'')
        return_code = '0'
      except Exception as ex:
        error_message = ex
        return_code = '-1'

  outputs:
    - return_result: ${ encoded if return_code == '0' else '' }
    - return_code
    - error_message: ${ str(error_message) if return_code == '-1' else '' }

  results:
    - SUCCESS: ${ return_code == '0' }
    - FAILURE
