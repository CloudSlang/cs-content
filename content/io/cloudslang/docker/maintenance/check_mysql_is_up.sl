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
#   - port - optional - SSH port - Default: 22
#   - username - Docker machine username
#   - password - Docker machine password
#   - privateKeyFile - optional - absolute path to private key file - Default: none
#   - arguments - optional - arguments to pass to the command - Default: none
#   - mysqlUsername - MySQL instance username
#   - mysqlPassword - MySQL instance password
#   - characterSet - optional - character encoding used for input stream encoding from target machine - Valid: SJIS, EUC-JP, UTF-8 - Default: UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false - Default: false
#   - timeout - optional - time in milliseconds to wait for command to complete - Default: 90000
#   - closeSession - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false - Default: false
# Outputs:
#   - error_Message - contains the STDERR of the machine if the SSH action was executed successfully, the cause of the exception otherwise
# Results:
#   - SUCCESS - action was executed successfully and MySQL server state is alive
#   - FAILURE - some problem occurred, more information in errorMessage output
##################################################################################################################################################

namespace: io.cloudslang.docker.maintenance

operation:
  name: check_mysql_is_up
  inputs:
    - container
    - host
    - port:
        default: "'22'"
    - username
    - password
    - privateKeyFile:
        default: "''"
    - arguments:
        default: "''"
    - mysqlUsername
    - mysqlPassword
    - execCmd:
        default: "'mysqladmin -u' + mysqlUsername + ' -p' + mysqlPassword + ' ping'"
        overridable: false
    - command:
        default: "'docker exec ' + container + ' ' + execCmd"
    - characterSet:
        default: "'UTF-8'"
    - pty:
        default: "'false'"
    - timeout:
        default: "'90000'"
    - closeSession:
        default: "'false'"
  action:
    java_action:
      className: io.cloudslang.content.ssh.actions.SSHShellCommandAction
      methodName: runSshShellCommand
  outputs:
    - error_message:  STDERR if returnCode == '0' else returnResult
  results:
    - SUCCESS : returnCode == '0' and returnResult == 'mysqld is alive\n'
    - FAILURE
