#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Adds or replaces a value to the given JSON at the keys or indices represented by the json_path.
#!               If the last key in the path does not exist, the key is added as well.
#! @input json_input: JSON data input - Example: '{"k1": {"k2": ["v1", "v2"]}}'
#! @input json_path: path at which to add value represented as a list of keys and/or indices - Example: ["k1","k2",1]
#! @input value: value to associate with key - Example: "v3"
#! @output return_result: JSON with key:value added
#! @output return_code: "0" if parsing was successful, "-1" otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: parsing was successful (return_code == '0') and value was added
#! @result FAILURE: parsing was unsuccessful or the path does not exist
#!!#
####################################################

namespace: io.cloudslang.base.json

operation:
  name: add_value
  inputs:
    - json_input
    - json_path
    - value:
        required: false
  python_action:
    script: |
      try:
        import json, re
        quote = None
        quote_value = None
        json_pa = json_path.split(",")
        if len(json_pa) > 0:
          for c in json_input:
            if c in ['\'', '\"']:
              quote = c
              break
          if quote == '\'':
            json_input = str(re.sub(r"(?<!\\)(\')",'"', json_input))
            json_input = str(re.sub(r"(\\')",'\'', json_input))
            for c in value:
              if c in ['\'', '\"']:
                quote_value = c
                break
            if quote_value == '\'':
              value = str(re.sub(r"(?<!\\)(\')",'"', value))
              value = str(re.sub(r"(\\')",'\'', value))

          try:
            decoded_value = json.loads(value)
          except Exception as ex:
            decoded_value = value

          decoded = json.loads(json_input)
          temp = decoded
          for key in json_pa[:-1]:
            temp = temp[key]
          temp[json_pa[-1]] = decoded_value
        elif (json_pa == [] and decoded_value == '' and json_input == '{}'):
          decoded = {}
        else:
          decoded = decoded_value
        encoded = json.dumps(decoded)
        if quote == '\'':
          encoded = encoded.replace('\'','\\\'').replace('\"','\'')
        return_code = '0'
      except Exception as ex:
        error_message = ex
        return_code = '-1'
  outputs:
    - return_result: ${ str(encoded) if return_code == '0' else ''}
    - return_code
    - error_message: ${ str(error_message) if return_code == '-1' else ''}
  results:
    - SUCCESS: ${ return_code == '0' }
    - FAILURE
