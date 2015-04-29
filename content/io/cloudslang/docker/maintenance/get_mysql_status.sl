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
#   - port - optional - SSH port - Default: 22
#   - username - Docker machine username
#   - password - Docker machine password
#   - privateKeyFile - optional - absolute path to the private file - Default: none
#   - arguments - optional - arguments to pass to the command - Default: none
#   - mysqlUsername - MySQL instance username
#   - mysqlPassword - MySQL instance password
#   - characterSet - optional - character encoding used for input stream encoding from target machine - Valid: SJIS, EUC-JP, UTF-8 - Default: UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false - Default: false
#   - timeout - optional - time in milliseconds to wait for command to complete - Default: 90000
#   - closeSession - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false - Default: false
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
#   Results:
#       - SUCCESS - action was executed successfully and STDERR of the machine contains no errors
#       - FAILURE
##################################################################################################################################################

namespace: io.cloudslang.docker.maintenance

operation:
  name: get_mysql_status
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
        default: "'mysqladmin -u' + mysqlUsername + ' -p' + mysqlPassword + ' status'"
        overridable: false
    - command:
        default: "'docker exec ' + container + ' ' + execCmd"
        overridable: false
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
    - uptime: "returnResult.replace(':', ' ').split('  ')[1]"
    - threads: "returnResult.replace(':', ' ').split('  ')[3]"
    - questions: "returnResult.replace(':', ' ').split('  ')[5]"
    - slow_queries: "returnResult.replace(':', ' ').split('  ')[7]"
    - opens: "returnResult.replace(':', ' ').split('  ')[9]"
    - flush_tables: "returnResult.replace(':', ' ').split('  ')[11]"
    - open_tables: "returnResult.replace(':', ' ').split('  ')[13]"
    - queries_per_second_AVG: "returnResult.replace(':', ' ').split('  ')[15]"
    - error_message: STDERR if returnCode == '0' else returnResult
  results:
    - SUCCESS : returnCode == '0' and (not 'Error' in STDERR)
    - FAILURE
