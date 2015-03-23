#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
# Demo that creates a new app and sends a status email.
#
# Inputs:
#   - email_host - email host
#   - email_port - email port
#   - email_sender - email sender
#   - email_recipient - email recipient
#   - marathon_host - Marathon agent host
#   - marathon_port - optional - marathon agent port - Defualt: 8080
#   - proxyHost - optional - proxy host - Default: none
#   - proxyPort - optional - proxy port - Default: 8080
#   - json_file - path to JSON of new app
# Outputs:
#   - return_result - operation response
#   - status_code - normal status code is 200
#   - return_code - if returnCode == -1 then there was an error
#   - error_message: returnResult if returnCode == -1 or statusCode != 200
# Results:
#   - SUCCESS - operation succeeded (returnCode != '-1' and statusCode == '200')
#   - FAILURE - otherwise
##################################################################################################################################################

namespace: io.cloudslang.marathon

imports:
  files: io.cloudslang.base.files
  marathon: io.cloudslang.marathon
  base_mail: io.cloudslang.base.mail
flow:
  name: demo_create_app_and_send_mail
  inputs:
    - email_host
    - email_port
    - email_sender
    - email_recipient
    - marathon_host
    - marathon_port:
        default: "'8080'"
        required: false
    - proxyHost:
        required: false
    - proxyPort:
        default: "'8080'"
        required: false
    - json_file
  workflow:
    - create_app:
        do:
          marathon.create_app:
            - marathon_host
            - marathon_port
            - json_file
            - proxyHost
            - proxyPort
        publish:
          - returnResult
          - statusCode
          - returnCode
          - errorMessage

    - send_status_mail:
        do:
          base_mail.send_mail:
            - hostname: email_host
            - port: email_port
            - htmlEmail: "'false'"
            - from: email_sender
            - to: email_recipient
            - subject: "'New app '"
            - body: "'App creation succeeded.'"
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE

    - on_failure:
        - send_error_mail:
            do:
              base_mail.send_mail:
                - hostname: email_host
                - port: email_port
                - htmlEmail: "'false'"
                - from: email_sender
                - to: email_recipient
                - subject: "'New app fail'"
                - body: "'App creation failed '+errorMessage"
  outputs:
    - returnResult
    - statusCode
    - returnCode
    - errorMessage
  results:
    - SUCCESS
    - FAILURE