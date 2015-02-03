#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
#   This operation retrieves the MySQL server status.
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
#       - uptime - number of seconds the MySQL server has been running
#       - threads - number of active threads (clients)
#       - questions - number of questions (queries) from clients since the server was started
#       - slow_queries - number of queries that have taken more than long_query_time(MySQL system variable) seconds
#       - opens - number of tables the server has opened
#       - flush_tables - number of flush-*, refresh, and reload commands the server has executed
#       - open_tables - number of tables that currently are open
#       - queries_per_second_AVG - an average value of the number of queries per second
#       - error_message - contains the STDERR of the machine if the shh action was executed successfully, the cause of the exception otherwise
#   Results:
#       - SUCCESS - the action was executed successfully and STDERR of the machine contains no errors
#       - FAILURE
##################################################################################################################################################

namespace: org.openscore.slang.docker.maintenance

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
        override: true
    - command:
        default: "'docker exec ' + container + ' ' + execCmd"
        override: true
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
