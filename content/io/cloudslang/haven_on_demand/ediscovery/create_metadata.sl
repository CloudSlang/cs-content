#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Creates JSON with additional information for metadata
#! @input value: list with additional value  - Example ["20/02/2017", "additional information of document"] 
#! @output json_data: JSON with metadata
#! @output error_message: error message if there was an error when executing, empty otherwise
#!!#
####################################################
namespace: io.cloudslang.haven_on_demand.ediscovery

operation:
  name: create_metadata
  inputs:
    - value
  python_action:
    script: |
        import json
        data = {}
        error_message=""
        is_error = False
        try:
          data['date'] = value[0]
          data['additional_info'] = value[1]
          json_data = json.dumps(data)
        except Exception as e:
            error_message = "Error while executing json extraction: " + str(e)
            is_error = True
  outputs:
     - error_message
     - json_data
  results:
     - FAILURE: ${is_error}
     - SUCCESS
