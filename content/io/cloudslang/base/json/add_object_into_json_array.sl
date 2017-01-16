#   (c) Copyright 2015-2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Insert an object into a JSON array, Optionally specifying the position at which to insert the new object.
#!
#! @input json_array: JSON array to insert object into - Example: '[{"a": "0"}, {"c": "2"}]'
#! @input json_object: JSON object to insert into array - Example: '{"b": "1"}'
#! @input index: Optional - position at which to insert the new object - Example: 1
#! @output return_result: JSON array with object inserted
#! @output return_code: "0" if inserting was successful, "-1" otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: inserting was successful (return_code == '0')
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.base.json

operation:
  name: add_object_into_json_array

  inputs:
    - json_array
    - json_object
    - index:
        required: false

  python_action:
    script: |
      try:
        import json, re
        array_quote = None
        object_quote = None
        for c in json_array:
          if c in ['\'', '\"']:
            array_quote = c
            break
        for c in json_object:
          if c in ['\'', '\"']:
            object_quote = c
            break
        if array_quote == '\'':
          json_array = str(re.sub(r"(?<!\\)(\')",'"', json_array))
          json_array = str(re.sub(r"(\\')",'\'', json_array))
        if object_quote == '\'':
          json_object = str(re.sub(r"(?<!\\)(\')",'"', json_object))
          json_object = str(re.sub(r"(\\')",'\'', json_object))

        decoded_json_array = json.loads(json_array)
        decoded_json_object = json.loads (json_object)
        index = locals().get('index')
        if index is None:
         decoded_json_array.append(decoded_json_object)
        else:
         index=int(index)
         if index >= len(decoded_json_array)*(-1) and index <= len(decoded_json_array):
          decoded_json_array.insert(index,decoded_json_object)
         else:
          raise Exception('Input "index" is out of range.')
        decoded_json_array = json.dumps(decoded_json_array)
        if array_quote == '\'':
          decoded_json_array = decoded_json_array.replace('\'','\\\'').replace('\"','\'')
        return_code = '0'
      except Exception as ex:
        error_message = ex
        return_code = '-1'

  outputs:
    - return_result: ${ str(decoded_json_array) if return_code == '0' else '' }
    - return_code
    - error_message: ${ str(error_message) if return_code == '-1' else '' }

  results:
    - SUCCESS: ${ return_code == '0' }
    - FAILURE
