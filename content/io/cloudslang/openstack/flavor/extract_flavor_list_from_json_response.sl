#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Builds a list of flavor names from the response of the list_openstack_flavor operations.
#
# Inputs:
#   - response_body - response of a GET operation
#   - object_name - name of the object that is contained in the list
# Outputs:
#   - object_list - comma seperated list of object names
#   - return_result - was parsing was successful or not
#   - return_code - 0 if parsing was successful, -1 otherwise
#   - error_message - return_result if there was an error
# Results:
#   - SUCCESS - parsing was successful (return_code == '0')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.openstack.flavor

operation:
  name: extract_flavor_list_from_json_response
  inputs:
    - response_body
    - object_name
  action:
    python_script: |
      try:
        import json
        json_list = json.loads(response_body)[object_name]

        if object_name == 'flavors':
            object_names = [object['name'] for object in json_list]

        object_list = ",".join(object_names)
        return_code = '0'
        return_result = 'Parsing successful.'
      except:
        return_code = '-1'
        return_result = 'Parsing error.'
  outputs:
    - object_list
    - return_result
    - return_code
    - error_message: return_result if return_code == '-1' else ''
  results:
    - SUCCESS: return_code == '0'
    - FAILURE