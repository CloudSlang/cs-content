#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Parses a JSON input and retrieves a list of usernames.
#! @input json_input: response of get_users flow
#! @output return_result: was parsing was successful or not
#! @output error_message: return_result if there was an error
#! @output return_code: '0' if parsing was successful, '-1' otherwise
#! @output usernames_list: list with all usernames
#! @result SUCCESS: parsing was successful (return_code == '0')
#! @result FAILURE: otherwise
#!!#
####################################################
namespace: io.cloudslang.cloud.stackato.utils

operation:
  name: get_usernames_list
  inputs:
    - json_input
  python_action:
    script: |
      try:
        import json
        decoded = json.loads(json_input)
        usernames_list = []
        for i in decoded['resources']:
          if i['entity']['username']:
            username = i['entity']['username']
            usernames_list.append(username)
        return_code = '0'
        return_result = 'Parsing successful.'
      except Exception as ex:
        return_code = '-1'
        return_result = ex
  outputs:
    - return_result
    - error_message: ${return_result if return_code == '-1' else ''}
    - return_code
    - usernames_list
  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE
