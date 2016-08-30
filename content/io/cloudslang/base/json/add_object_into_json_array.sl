#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Insert an object into a JSON array, optionally specifying the position at which to insert the new object.
#! @input json_array: JSON array to insert object into - Example: '[{"a": "0"}, {"c": "2"}]'
#! @input json_object: JSON object to insert into array - Example: '{"b": "1"}'
#! @input index: optional - position at which to insert the new object - Example: 1
#! @output json_output: JSON array with object inserted
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: "0" if inserting was successful, "-1" otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: inserting was successful (return_code == '0')
#! @result FAILURE: otherwise
#!!#
####################################################

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
        import json
        decoded_json_array = json.loads(json_array)
        decoded_json_object = json.loads (json_object)
        index = locals().get('index')
        if index is None:
         decoded_json_array.append(decoded_json_object)
        else:
         index=int(index)
         decoded_json_array.insert(index,decoded_json_object)
        encoded_json_array = json.dumps(decoded_json_array)
        return_code = '0'
        return_result = 'Inserting successful.'
      except Exception as ex:
        return_result = ex
        return_code = '-1'
  outputs:
    - json_output: ${ encoded_json_array if return_code == '0' else '' }
    - return_result: ${ str(return_result) }
    - return_code
    - error_message: ${ return_result if return_code == '-1' else '' }
  results:
    - SUCCESS: ${ return_code == '0' }
    - FAILURE
