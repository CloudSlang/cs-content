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
#   - docker_username - Docker machine username
#   - docker_password - Docker machine password
#   - private_key_file - optional - absolute path to private key file - Default: none
#   - mysql_username - MySQL instance username
#   - mysql_password - MySQL instance password
#   - email_host - email server host
#   - email_port - email server port
#   - email_sender - email sender
#   - email_recipient - email recipient
##################################################################################################################################################

namespace: io.cloudslang.docker.monitoring.mysql

imports:
 docker_monitoring_mysql: io.cloudslang.docker.monitoring.mysql
 base_mail: io.cloudslang.base.mail
 print: io.cloudslang.base.print

flow:
  name: report_mysql_status

  inputs:
    - container
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - private_key_file:
        required: false
    - mysql_username
    - mysql_password
    - email_host
    - email_port
    - email_password
    - email_sender
    - email_recipient

  workflow:
    - retrieve_mysql_status:
        do:
          docker_monitoring_mysql.retrieve_mysql_status:
            - host
            - port:
                required: false
            - username
            - password
            - private_key_file:
                required: false
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
              - hostname:
                  default: email_host
                  overridable: false
              - port:
                  default: email_port
                  overridable: false
              - username:
                  default: email_sender
                  overridable: false
              - password:
                  default: email_password
                  overridable: false
              - htmlEmail: "'false'"
              - from: email_sender
              - to: email_recipient
              - subject: "'MySQL Server Status on ' + host"
              - body: >
                   'The MySQL server status on host ' + host + ' is detected as:\nUptime: ' + uptime
                   + '\nThreads: ' + threads + '\nQuestions: ' + questions + '\nSlow queries: ' + slow_queries
                   + '\nOpens: ' + opens + '\nFlush tables: ' + flush_tables + '\nOpen tables: ' + open_tables
                   + '\nQueries per second avg: ' + queries_per_second_AVG
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE

    - on_failure:
      - send_error_mail:
          do:
              base_mail.send_mail:
                  - hostname:
                      default: email_host
                      overridable: false
                  - port:
                      default: email_port
                      overridable: false
                  - username:
                      default: email_sender
                      overridable: false
                  - password:
                      default: email_password
                      overridable: false
                  - from: email_sender
                  - to: email_recipient
                  - subject: "'MySQL Server Status on ' + host"
                  - body: >
                      'The MySQL server status checking on host ' + host
                      + ' ended with the following error message: ' + error_message
          navigate:
            SUCCESS: SUCCESS
            FAILURE: FAILURE
