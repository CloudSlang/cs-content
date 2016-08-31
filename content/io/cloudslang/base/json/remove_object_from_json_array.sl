#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Removes an object from a JSON array, specifying the JSON object to remove from array or the position from which to remove the existing object.
#! @input json_array: JSON array to remove object from - Example: '[{"a": "0"}, {"b": "1"}, {"c": "2"}]'
#! @input json_object: optional - JSON object to remove from array - Example: '{"b": "1"}'
#! @input index: optional - position from which to remove the existing object - Example: 1
#! @output json_output: JSON array with object removed
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: "0" if removing was successful, "-1" otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: removing was successful (return_code == '0')
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.base.json

operation:
  name: remove_object_from_json_array
  inputs:
    - json_array
    - json_object:
        required: false
        default: null
    - index:
        required: false
        default: null

  python_action:
    script: |
      try:
        import json
        if (json_object is not None and index is not None) or (json_object is None and index is None):
         return_code = '-1'
         return_result= "Inputs are not valid"
        else:
         decoded_json_array = json.loads(json_array)
         if json_object is not None and index is None:
          decoded_json_object = json.loads(json_object)
          decoded_json_array.remove(decoded_json_object)
         if json_object is None and index is not None:
          index=int(index)
          decoded_json_array.pop(index)
         encoded_json_array = json.dumps(decoded_json_array)
         return_code = '0'
         return_result = 'Remove successful.'
      except ValueError:
        return_result = "Object not found"
        return_code = '-1'
      except Exception as ex:
        return_result = ex
        return_code = '-1'

  outputs:
    - json_output: ${ str(encoded_json_array) if return_code == '0' else '' }
    - return_result: ${ str(return_result) }
    - return_code: ${ str(return_code) }
    - error_message: ${ return_result if return_code == '-1' else '' }
  results:
    - SUCCESS: ${ return_code == '0' }
    - FAILURE
