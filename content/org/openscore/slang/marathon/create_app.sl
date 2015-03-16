#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
# Creates a new app.
#
# Inputs:
#   - marathon_host - marathon agent host
#   - marathon_port - optional - marathon agent port - Defualt: 8080
#   - json_file - path to json of new app
#   - proxyHost - optional - proxy host - Default: none
#   - proxyPort - optional - proxy port - Default: 8080
# Outputs:
#   - return_result - response of the operation
#   - status_code - normal status code is 200
#   - return_code - if returnCode == -1 then there was an error
#   - error_message: returnResult if returnCode == -1 or statusCode != 200
# Results:
#   - SUCCESS - operation succeeded (returnCode != '-1' and statusCode == '200')
#   - FAILURE - otherwise
##################################################################################################################################################

namespace: org.openscore.slang.marathon

imports:
  files: org.openscore.slang.base.files
  marathon: org.openscore.slang.marathon

flow:
  name: create_app
  inputs:
    - marathon_host
    - marathon_port:
        default: "'8080'"
        required: false
    - json_file
    - proxyHost:
        default: "''"
        required: false
    - proxyPort:
        default: "'8080'"
        required: false
  workflow:
    - read_from_file:
        do:
          files.read_from_file:
            - file_path: json_file
        publish:
          - read_text

    - send_create_app_req:
        do:
          marathon.send_create_app_req:
            - marathon_host
            - marathon_port
            - body: read_text
            - proxyHost
            - proxyPort
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