#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

########################################################################################################################
#!!
#! @description: Retrieves the MySQL server status.
#! @input container: name or ID of the Docker container that runs MySQL
#! @input host: Docker machine host
#! @input port: optional - SSH port
#! @input username: Docker machine username
#! @input password: Docker machine password
#! @input private_key_file: optional - absolute path to the private file
#! @input mysql_username: MySQL instance username
#! @input mysql_password: MySQL instance password
#! @input character_set: optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#! @input pty: optional - whether to use PTY - Valid: true, false
#! @input timeout: optional - time in milliseconds to wait for command to complete
#! @input close_session: optional - if 'false' SSH session will be cached for future calls during the life of the flow,
#!                       if 'true' the SSH session used will be closed; Valid: true, false
#! @output uptime: number of seconds MySQL server has been running
#! @output threads: number of active threads (clients)
#! @output questions: number of questions (queries) from clients since server was started
#! @output slow_queries: number of queries that have taken more than long_query_time (MySQL system variable) seconds
#! @output opens: number of tables server has opened
#! @output flush_tables: number of flush-*, refresh, and reload commands server has executed
#! @output open_tables: number of tables that are currently open
#! @output queries_per_second_AVG: average value of number of queries per second
#! @output error_message: STDERR of the machine if the SSH action was executed successfully, cause of exception otherwise
#! @result SUCCESS: action was executed successfully and STDERR of the machine contains no errors
#! @result FAILURE:
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.monitoring.mysql

imports:
  ssh: io.cloudslang.base.ssh

flow:
  name: get_mysql_status
  inputs:
    - container
    - host
    - port:
        required: false
    - username
    - password:
        sensitive: true
    - private_key_file:
        required: false
    - mysql_username
    - mysql_password:
        sensitive: true
    - exec_cmd:
        default: ${ 'mysqladmin -u' + mysql_username + ' -p' + mysql_password + ' --protocol=tcp status' }
        private: true
    - command:
        default: ${ 'docker exec ' + container + ' ' + exec_cmd }
        private: true
    - character_set:
        required: false
    - pty:
        required: false
    - timeout:
        required: false
    - close_session:
        required: false
  workflow:
    - get_mysql_status:
        do:
          ssh.ssh_flow:
            - host
            - port
            - username
            - password
            - private_key_file
            - command
            - character_set
            - pty
            - timeout
            - close_session
        publish:
          - return_result
          - standard_err
          - return_code
  outputs:
    - uptime: "${ return_result.replace(':', ' ').split('  ')[1] }"
    - threads: "${ return_result.replace(':', ' ').split('  ')[3] }"
    - questions: "${ return_result.replace(':', ' ').split('  ')[5] }"
    - slow_queries: "${ return_result.replace(':', ' ').split('  ')[7] }"
    - opens: "${ return_result.replace(':', ' ').split('  ')[9] }"
    - flush_tables: "${ return_result.replace(':', ' ').split('  ')[11] }"
    - open_tables: "${ return_result.replace(':', ' ').split('  ')[13] }"
    - queries_per_second_AVG: "${ return_result.replace(':', ' ').split('  ')[15] }"
    - error_message: ${ standard_err if return_code == '0' else return_result }
  results:
    - SUCCESS
    - FAILURE
