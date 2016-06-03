#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

###############################################################################
#!!
#! @description: Updates an app.
#! @input marathon_host: Marathon agent host
#! @input marathon_port: optional - Marathon agent port - Default: 8080
#! @input app_id: app ID to update
#! @input json_file: path to JSON of the app
#! @input proxy_host: optional - proxy host
#! @input proxy_port: optional - proxy port
#! @output return_result: response of the operation
#! @output status_code: normal status code is 200
#! @output return_code: if return_code == -1 then there was an error
#! @output error_message: return_result if return_code == -1 or status_code != 200
#! @result SUCCESS: app updated successfully
#! @result FAILURE: otherwise
#!!#
###############################################################################

namespace: io.cloudslang.marathon

imports:
  files: io.cloudslang.base.files
  marathon: io.cloudslang.marathon

flow:
  name: update_app
  inputs:
    - marathon_host
    - marathon_port:
        default: "8080"
        required: false
    - app_id
    - json_file
    - proxy_host:
        required: false
    - proxy_port:
        required: false
        
  workflow:
    - read_from_file:
        do:
          files.read_from_file:
            - file_path: ${json_file}
        publish:
          - read_text

    - send_update_app_req:
        do:
          marathon.send_update_app_req:
            - marathon_host
            - marathon_port
            - app_id
            - body: ${read_text}
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - status_code
          - return_code
          - error_message

  outputs:
    - return_result
    - status_code
    - return_code
    - error_message
  results:
    - SUCCESS
    - FAILURE
