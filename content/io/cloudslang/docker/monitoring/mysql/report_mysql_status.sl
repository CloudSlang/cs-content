#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

########################################################################################################################
#!!
#! @description: Retrieves the MySQL server status and notifies the user by sending an email that contains the status or the possible
#!               errors.
#! @input container: name or ID of the Docker container that runs MySQL
#! @input docker_host: Docker machine host
#! @input docker_port: optional - Docker machine port
#! @input docker_username: Docker machine username
#! @input docker_password: optional - Docker machine password
#! @input docker_private_key_file: optional - path to private key file
#! @input mysql_username: MySQL instance username
#! @input mysql_password: MySQL instance password
#! @input email_host: email server host
#! @input email_port: email server port
#! @input email_username: optional - email user name
#! @input email_password: optional - email password
#! @input email_sender: email sender
#! @input email_recipient: email recipient
#! @result SUCCESS: successful
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.monitoring.mysql

imports:
  mysql: io.cloudslang.docker.monitoring.mysql
  mail: io.cloudslang.base.mail

flow:
  name: report_mysql_status

  inputs:
    - container
    - docker_host
    - docker_port:
        required: false
    - docker_username
    - docker_password:
        required: false
        sensitive: true
    - docker_private_key_file:
        required: false
    - mysql_username
    - mysql_password:
        sensitive: true
    - email_host
    - email_port
    - email_username:
        required: false
    - email_password:
        required: false
        sensitive: true
    - email_sender
    - email_recipient

  workflow:
    - retrieve_mysql_status:
        do:
          mysql.retrieve_mysql_status:
            - host: ${ docker_host }
            - port: ${ docker_port }
            - username: ${ docker_username }
            - password: ${ docker_password }
            - private_key_file: ${ docker_private_key_file }
            - container
            - mysql_username
            - mysql_password
        publish:
          - uptime
          - threads
          - questions
          - slow_queries
          - opens
          - flush_tables
          - open_tables
          - queries_per_second_AVG
          - error_message

    - send_status_mail:
        do:
          mail.send_mail:
            - hostname: ${ email_host }
            - port: ${ email_port }
            - username: ${ email_username }
            - password: ${ email_password }
            - html_email: "false"
            - from: ${ email_sender }
            - to: ${ email_recipient }
            - subject: ${ 'MySQL Server Status on ' + docker_host }
            - body: >
                ${ 'The MySQL server status on host ' + docker_host + ' is detected as:\nUptime: ' + uptime
                + '\nThreads: ' + threads + '\nQuestions: ' + questions + '\nSlow queries: ' + slow_queries
                + '\nOpens: ' + opens + '\nFlush tables: ' + flush_tables + '\nOpen tables: ' + open_tables
                + '\nQueries per second avg: ' + queries_per_second_AVG }

    - on_failure:
      - send_error_mail:
          do:
            mail.send_mail:
              - hostname: ${ email_host }
              - port: ${ email_port }
              - username: ${ email_username }
              - password: ${ email_password }
              - from: ${ email_sender }
              - to: ${ email_recipient }
              - subject: ${ 'MySQL Server Status on ' + docker_host }
              - body: >
                  ${ 'The MySQL server status checking on host ' + docker_host
                  + ' ended with the following error message: ' + error_message }
