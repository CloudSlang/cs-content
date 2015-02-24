#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
#   demo flow for creating new app and then send email 
#
#   Inputs:
#       - email_host - email host
#       - email_port - email port
#       - email_sender - email sender
#       - email_recipient - email recipient
#       - marathon_host - marathon agent host
#       - marathon_port - optional - marathon agent port (defualt 8080)
#       - proxyUsername - optional - user name used when connecting to the proxy
#       - proxyPassword - optional - proxy server password associated with the <proxyUsername> input value
#       - json_file - path to json of the new app
#   Outputs:
#       - return_result - response of the operation
#       - status_code - normal status code is 200
#       - return_code - if returnCode is equal to -1 then there was an error
#       - error_message: returnResult if returnCode is equal to -1 or statusCode different than 200
#       - email_host - email server host
#       - email_port - email server port
#       - email_sender - email sender
#       - email_recipient - email recipient
#   Results:
#       - SUCCESS - operation succeeded (returnCode != '-1' and statusCode == '200')
#       - FAILURE - otherwise
##################################################################################################################################################

namespace: org.openscore.slang.marathon

imports:
  files: org.openscore.slang.base.files
  marathon: org.openscore.slang.marathon
  base_mail: org.openscore.slang.base.mail
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
    create_app:
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
    send_status_mail:
      do:
        base_mail.send_mail:
                - hostname: email_host
                - port: email_port
                - htmlEmail: "'false'"
                - from: email_sender
                - to: email_recipient
                - subject: "'New app '"
                - body: "'app create succeeded'"
      navigate:
        SUCCESS: SUCCESS
        FAILURE: FAILURE
    on_failure:
       send_error_mail:
            do:
              base_mail.send_mail:
                - hostname: email_host
                - port: email_port
                - htmlEmail: "'false'"
                - from: email_sender
                - to: email_recipient
                - subject: "'New app fail'"
                - body: "'app create failed '+errorMessage"
  outputs:
    - returnResult
    - statusCode
    - returnCode
    - errorMessage
  results:
    - SUCCESS
    - FAILURE