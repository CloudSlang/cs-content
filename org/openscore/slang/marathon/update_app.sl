#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
#   update app
#
#   Inputs:
#       - marathon_host - marathon agent host
#       - marathon_port - optional - marathon agent port (defualt 8080)
#       - app_id - app ID to update
#       - json_file - path to json of the app
#       - proxyUsername - optional - user name used when connecting to the proxy
#       - proxyPassword - optional - proxy server password associated with the <proxyUsername> input value
#   Outputs:
#       - return_result - response of the operation
#       - status_code - normal status code is 200
#       - return_code - if returnCode is equal to -1 then there was an error
#       - error_message: returnResult if returnCode is equal to -1 or statusCode different than 200
#   Results:
#       - SUCCESS - operation succeeded (returnCode != '-1' and statusCode == '200')
#       - FAILURE - otherwise
##################################################################################################################################################

namespace: org.openscore.slang.marathon

imports:
  files: org.openscore.slang.base.files
  marathon: org.openscore.slang.marathon

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

    - send_update_app_req:
        do:
          marathon.send_update_app_req:
            - marathon_host
            - marathon_port
            - app_id
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