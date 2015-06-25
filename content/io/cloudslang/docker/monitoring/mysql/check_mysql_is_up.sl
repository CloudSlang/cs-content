#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
# Checks if the MySQL server is up, meaning its state is alive.
#
# Inputs:
#   - container - name or ID of the Docker container that runs MySQL
#   - host - Docker machine host
#   - port - optional - SSH port
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - private_key_file - optional - absolute path to private key file
#   - mysql_username - MySQL instance username
#   - mysql_password - MySQL instance password
#   - character_set - optional - character encoding used for input stream encoding from target machine - Valid: SJIS, EUC-JP, UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false
#   - timeout - optional - time in milliseconds to wait for command to complete
#   - close_session - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false
# Outputs:
#   - error_message - contains the STDERR of the machine if the SSH action was executed successfully, the cause of the exception otherwise
# Results:
#   - SUCCESS - action was executed successfully and MySQL server state is alive
#   - FAILURE - some problem occurred, more information in errorMessage output
##################################################################################################################################################

namespace: io.cloudslang.docker.monitoring.mysql

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh
  strings: io.cloudslang.base.strings

flow:
  name: check_mysql_is_up
  inputs:
    - container
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - arguments:
        required: false
    - mysql_username
    - mysql_password
    - private_key_file:
        required: false
    - exec_cmd:
        default: "'mysqladmin -u' + mysql_username + ' -p' + mysql_password + ' ping'"
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
    - check_mysql_is_up:
        do:
          ssh.ssh_flow:
            - host
            - port:
                required: false
            - username
            - password:
                required: false
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
          - error_message:  standard_err if return_code == '0' else returnResult

    - verify:
        do:
          strings.string_equals:
            - first_string: returnResult.replace("\n","")
            - second_string: "'mysqld is alive'"
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE

  outputs:
      - error_message

  results:
    - SUCCESS
    - FAILURE
