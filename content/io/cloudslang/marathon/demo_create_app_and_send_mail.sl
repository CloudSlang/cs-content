#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
#!!
#! @description: Demo that creates a new Marathon app and sends a status email.
#! @input email_host: email host
#! @input email_port: email port
#! @input email_sender: email sender
#! @input email_recipient: email recipient
#! @input enable_tls: enable TLS
#! @input email_username: email username
#! @input email_password: email password
#! @input marathon_host: Marathon agent host
#! @input marathon_port: optional - Marathon agent port - Default: 8080
#! @input proxy_host: optional - proxy host
#! @input proxy_port: optional - proxy port
#! @input json_file: path to JSON of new app
#! @output return_result: operation response
#! @output status_code: normal status code is 200
#! @output return_code: if return_code == -1 then there was an error
#! @output error_message: return_result if return_code == -1 or status_code != 200
#! @result SUCCESS: operation succeeded (return_code != '-1' and status_code == '200')
#! @result FAILURE: otherwise
#!!#
##################################################################################################################################################

namespace: io.cloudslang.marathon

imports:
  mail: io.cloudslang.base.mail
  marathon: io.cloudslang.marathon

flow:
  name: demo_create_app_and_send_mail
  inputs:
    - email_host
    - email_port
    - email_sender
    - email_recipient
    - enable_tls:
        required: false
    - email_username:
        required: false
    - email_password:
        required: false
        sensitive: true
    - marathon_host
    - marathon_port:
        default: "8080"
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - json_file

  workflow:
    - create_app:
        do:
          marathon.create_app:
            - marathon_host
            - marathon_port
            - json_file
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - status_code
          - return_code
          - error_message

    - send_status_mail:
        do:
          mail.send_mail:
            - hostname: ${email_host}
            - port: ${email_port}
            - html_email: "false"
            - from: ${email_sender}
            - to: ${email_recipient}
            - subject: "New app "
            - body: "App creation succeeded."
            - enable_TLS: ${enable_tls}
            - username: ${email_username}
            - password: ${email_password}

    - on_failure:
        - send_error_mail:
            do:
              mail.send_mail:
                - hostname: ${email_host}
                - port: ${email_port}
                - html_email: "false"
                - from: ${email_sender}
                - to: ${email_recipient}
                - subject: "New app fail"
                - body: ${"App creation failed " + error_message}
                - enable_TLS: ${enable_tls}
                - username: ${email_username}
                - password: ${email_password}

  outputs:
    - return_result
    - status_code
    - return_code
    - error_message
  results:
    - SUCCESS
    - FAILURE
