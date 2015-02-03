#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
#   This operation checks if the MySQL server is up, meaning its state is alive.
#
#   Inputs:
#       - container - name or ID of the Docker container that runs MySQL
#       - host - Docker machine host
#       - username - Docker machine username
#       - password - Docker machine password
#       - mysqlUsername - MySQL instance username
#       - mysqlPassword - MySQL instance password
#       - pty - whether to use pty; valid values: true, false; Default: false
#       - arguments - arguments to pass to the command; Default: none
#       - privateKeyFile - the absolute path to the private key file; Default: none
#       - timeout - time in milliseconds to wait for the command to complete; Default: 90000 ms
#       - characterSet - character encoding used for input stream encoding from the target machine; valid values: SJIS, EUC-JP, UTF-8; Default: UTF-8;
#       - closeSession - if false the ssh session will be cached for future calls of this operation during the life of the flow
#                        if true the ssh session used by this operation will be closed; Valid values: true, false; Default: false
#   Outputs:
#       - error_Message - contains the STDERR of the machine if the SSH action was executed successfully, the cause of the exception otherwise
#   Results:
#       - SUCCESS - the action was executed successfully and the MySQL server state is alive
#       - FAILURE - some problem occurred, more information in the errorMessage output
##################################################################################################################################################

namespace: org.openscore.slang.docker.maintenance

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
        override: true
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
      className: org.openscore.content.ssh.actions.SSHShellCommandAction
      methodName: runSshShellCommand
  outputs:
    - error_message:  STDERR if returnCode == '0' else returnResult
  results:
    - SUCCESS : returnCode == '0' and returnResult == 'mysqld is alive\n'
    - FAILURE
