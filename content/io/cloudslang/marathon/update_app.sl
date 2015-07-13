#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

###############################################################################
# Updates an app.
#
# Inputs:
#   - marathon_host - Marathon agent host
#   - marathon_port - optional - Marathon agent port - Default: 8080
#   - app_id - app ID to update
#   - json_file - path to JSON of the app
#   - proxyHost - optional - proxy host
#   - proxyPort - optional - proxy port
# Outputs:
#   - returnResult - response of the operation
#   - statusCode - normal status code is 200
#   - returnCode - if returnCode == -1 then there was an error
#   - errorMessage - returnResult if returnCode == -1 or statusCode != 200
# Results:
#   - SUCCESS - app updated successfully
#   - FAILURE - otherwise
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
        default: "'8080'"
        required: false
    - app_id
    - json_file
    - proxyHost:
        required: false
    - proxyPort:
        required: false
  workflow:
    - read_from_file:
        do:
          files.read_from_file:
            - file_path: json_file
        publish:
          - read_text

    - send_update_app_req:
        do:
          marathon.send_update_app_req:
            - marathon_host
            - marathon_port
            - app_id
            - body: read_text
            - proxyHost:
                required: false
            - proxyPort:
                required: false
        publish:
          - returnResult
          - statusCode
          - returnCode
          - errorMessage

  outputs:
    - returnResult
    - statusCode
    - returnCode
    - errorMessage
  results:
    - SUCCESS
    - FAILURE