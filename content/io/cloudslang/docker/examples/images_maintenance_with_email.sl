#   (c) Copyright 2014-2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Wrapper over `images_maintenance`. Calls the flow and sends an email.
#!
#! @input docker_host: Docker machine host
#! @input docker_username: Docker machine username
#! @input docker_password: optional - Docker machine password
#! @input private_key_file: optional - absolute path to private key file
#! @input percentage: if disk space is greater than this value then unused images will be deleted - Example: 50%
#! @input timeout: optional - time in milliseconds to wait for the command to complete - Default: 6000000
#! @input email_hostname: email host
#! @input email_port: email port
#! @input email_from: email sender
#! @input email_to: email recipient
#! @input email_username: optional
#! @input email_password: optional
#! @input enable_TLS: optional - enable startTLS
#!
#! @output total_amount_of_images_deleted: number of deleted images
#!
#! @result SUCCESS: successful
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.examples

imports:
  maintenance: io.cloudslang.docker.maintenance
  mail: io.cloudslang.base.mail

flow:
  name: images_maintenance_with_email

  inputs:
    - docker_host
    - docker_username
    - docker_password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - percentage: ${ get_sp('io.cloudslang.docker.examples.percentage') }
    - timeout:
        required: false
    - email_hostname
    - email_port
    - email_from
    - email_to
    - email_username:
        required: false
    - email_password:
        required: false
        sensitive: true
    - enable_TLS:
        required: false

  workflow:
    - run_maintenance_task:
        do:
          maintenance.images_maintenance:
            - docker_host
            - docker_username
            - docker_password
            - private_key_file
            - percentage
            - timeout
        publish:
          - total_amount_of_images_deleted

    - send_success_mail:
        do:
          mail.send_mail:
            - hostname: ${email_hostname}
            - port: ${email_port}
            - from: ${email_from}
            - to: ${email_to}
            - subject: >
                ${"Machine '" + docker_host + "' cleanup: SUCCESS"}
            - body: >
                ${'Total number of images deleted: ' + total_amount_of_images_deleted}
            - username: ${email_username}
            - password: ${email_password}
            - enable_TLS

    - on_failure:
      - send_failure_mail:
          do:
            mail.send_mail:
              - hostname: ${email_hostname}
              - port: ${email_port}
              - from: ${email_from}
              - to: ${email_to}
              - subject: >
                  ${"Machine '" + docker_host + "' cleanup: FAILURE"}
              - body: 'Please check logs on CS machine'
              - username: ${email_username}
              - password: ${email_password}
              - enable_TLS

  outputs:
    - total_amount_of_images_deleted
