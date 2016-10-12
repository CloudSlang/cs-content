#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Updates a specified list within JSON object.
#! @input json_object: JSON object - Example: '{"server": {"security_groups": [{"name": "default"}], "networks": []}}'
#! @input list_label: the key of targeted list to be updated - Example: 'networks'
#! @input value: the value used to update the list - Example: '{"uuid": "b67f9da0-4a89-4588-b0f5-bf4d19401743"}'
#! @output json_output: JSON object with specified list updated
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: "0" if success, "-1" otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: successfully updated the specified list (return_code == '0')
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.cloud.openstack.utils

operation:
  name: update_list
  inputs:
    - json_object
    - list_label
    - value

  python_action:
    script: |
      try:
        import json

        decoded = json.loads(json_object)
        decoded_value = json.loads(value)
        decoded['server'][list_label].append(decoded_value)

        encoded_json = json.dumps(decoded)
        return_code = '0'
        return_result = 'The list is updated.'
      except Exception as ex:
        return_result = ex
        return_code = '-1'

  outputs:
    - json_output: ${ encoded_json if return_code == '0' else '' }
    - return_result
    - return_code
    - error_message: ${ return_result if return_code == '-1' else '' }

  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE
