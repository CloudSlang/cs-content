#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
# Retrieves the MySQL server status and notifies the user by sending an email that contains the status or the possible errors.
#
# Inputs:
#   - container - name or ID of the Docker container that runs MySQL
#   - docker_host - Docker machine host
#   - docker_port - optional - Dpcker machine port
#   - docker_username - Docker machine username
#   - docker_password - optional - Docker machine password
#   - docker_private_key_file - optional - path to private key file
#   - mysql_username - MySQL instance username
#   - mysql_password - MySQL instance password
#   - email_host - email server host
#   - email_port - email server port
#   - email_username - optional - email user name
#   - email_password - optional - email password
#   - email_sender - email sender
#   - email_recipient - email recipient
# Results:
#   - SUCCESS - successful
#   - FAILURE - otherwise
##################################################################################################################################################

namespace: io.cloudslang.docker.monitoring.mysql

imports:
 base_mail: io.cloudslang.base.mail
 print: io.cloudslang.base.print

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
    - docker_private_key_file:
        required: false
    - mysql_username
    - mysql_password
    - email_host
    - email_port
    - email_username:
        required: false
    - email_password:
        required: false
    - email_sender
    - email_recipient

  workflow:
    - retrieve_mysql_status:
            do:
              retrieve_mysql_status:
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
              base_mail.send_mail:
                  - hostname: ${ email_host }
                  - port: ${ email_port }
                  - username: ${ email_username }
                  - password: ${ email_password }
                  - htmlEmail: "false"
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
              base_mail.send_mail:
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
          navigate:
            SUCCESS: FAILURE
            FAILURE: FAILURE
