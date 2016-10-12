#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Parses a JSON input and retrieves the specific details of the resource identified by <key_name>.
#! @input json_input: response of get resources operation (get_applications, get_services, get_spaces, get_users)
#! @input key_name: name of resource to get details on
#! @output return_result: was parsing was successful or not
#! @output error_message: return_result if there was an error
#! @output return_code: '0' if parsing was successful, '-1' otherwise
#! @output resource_guid: GUID of resource identified by <key_name>
#! @output resource_url: URL of resource identified by <key_name>
#! @output resource_created_at: creation date of the resource identified by <key_name>
#! @output resource_updated_at: last updated date of the resource identified by <key_name>
#! @result SUCCESS: parsing was successful (return_code == '0')
#! @result FAILURE: otherwise
#!!#
####################################################
namespace: io.cloudslang.cloud.stackato.utils

operation:
  name: get_resource_details
  inputs:
    - json_input
    - key_name
  python_action:
    script: |
      try:
        import json
        decoded = json.loads(json_input)
        for i in decoded['resources']:
          if i['entity']['name'] == key_name:
            resource_guid = "key_name + '_guid'"
            resource_url = "key_name + '_url"
            resource_created_at = "key_name + '_created_at"
            resource_updated_at = "key_name + '_updated_at"
            resource_guid = i['metadata']['guid']
            resource_url = i['metadata']['url']
            resource_created_at = i['metadata']['created_at']
            resource_updated_at = i['metadata']['updated_at']
        return_code = '0'
        return_result = 'Parsing successful.'
      except Exception as ex:
        return_code = '-1'
        return_result = ex
  outputs:
    - return_result
    - error_message: ${return_result if return_code == '-1' else ''}
    - return_code
    - resource_guid
    - resource_url
    - resource_created_at
    - resource_updated_at
  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE
