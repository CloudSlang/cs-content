#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
# Retrieves the MySQL server status.
#
# Inputs:
#   - container - name or ID of the Docker container that runs MySQL
#   - host - Docker machine host
#   - port - optional - SSH port
#   - username - Docker machine username
#   - password - Docker machine password
#   - private_key_file - optional - absolute path to the private file
#   - mysql_username - MySQL instance username
#   - mysql_password - MySQL instance password
#   - character_set - optional - character encoding used for input stream encoding from target machine - Valid: SJIS, EUC-JP, UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false
#   - timeout - optional - time in milliseconds to wait for command to complete
#   - close_session - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false
# Outputs:
#   - uptime - number of seconds MySQL server has been running
#   - threads - number of active threads (clients)
#   - questions - number of questions (queries) from clients since server was started
#   - slow_queries - number of queries that have taken more than long_query_time (MySQL system variable) seconds
#   - opens - number of tables server has opened
#   - flush_tables - number of flush-*, refresh, and reload commands server has executed
#   - open_tables - number of tables that are currently open
#   - queries_per_second_AVG - average value of number of queries per second
#   - error_message - STDERR of the machine if the SSH action was executed successfully, cause of exception otherwise
# Results:
#   - SUCCESS - action was executed successfully and STDERR of the machine contains no errors
#   - FAILURE
##################################################################################################################################################

namespace: io.cloudslang.docker.monitoring.mysql

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: get_mysql_status
  inputs:
    - container
    - host
    - port:
        required: false
    - username
    - password
    - private_key_file:
        required: false
    - mysql_username
    - mysql_password
    - exec_cmd:
        default: "'mysqladmin -u' + mysql_username + ' -p' + mysql_password + ' status'"
        overridable: false
    - command:
        default: "'docker exec ' + container + ' ' + exec_cmd"
        overridable: false
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
            - port:
                required: false
            - username
            - password
            - privateKeyFile:
                default: private_key_file
                required: false
            - command
            - characterSet:
                default: character_set
                required: false
            - pty:
                required: false
            - timeout:
                required: false
            - closeSession:
                default: close_session
                required: false
        publish:
          - returnResult
          - return_code
          - standard_err
  outputs:
    - uptime: "returnResult.replace(':', ' ').split('  ')[1]"
    - threads: "returnResult.replace(':', ' ').split('  ')[3]"
    - questions: "returnResult.replace(':', ' ').split('  ')[5]"
    - slow_queries: "returnResult.replace(':', ' ').split('  ')[7]"
    - opens: "returnResult.replace(':', ' ').split('  ')[9]"
    - flush_tables: "returnResult.replace(':', ' ').split('  ')[11]"
    - open_tables: "returnResult.replace(':', ' ').split('  ')[13]"
    - queries_per_second_AVG: "returnResult.replace(':', ' ').split('  ')[15]"
    - error_message: standard_err if return_code == '0' else returnResult
  results:
    - SUCCESS
    - FAILURE
