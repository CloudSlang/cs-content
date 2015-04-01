# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow restart remote linux service thrue ssh
#
#   Inputs:
#       - service_name - linux service name to be restarted
#       - host - hostname or IP address
#       - port - port number for running the command
#       - command - command to execute
#       - pty - whether to use pty; valid values: true, false; Default: false
#       - username - username to connect as
#       - password - password of user
#       - arguments - arguments to pass to the command
#       - privateKeyFile - the absolute path to the private key file
#       - timeout - time in milliseconds to wait for the command to complete; Default: 90000 ms
#       - characterSet - character encoding used for input stream encoding from the target machine; valid values: SJIS, EUC-JP, UTF-8; Default: UTF-8;
#       - closeSession - if false the ssh session will be cached for future calls of this operation during the life of the flow
#                     if true the ssh session used by this operation will be closed; Valid values: true, false; Default: true
#
#
# Results:
#  SUCCESS: service on Linux host is restarted successfully
#  FAILURE: service cannot be restarted due to an error
# 
####################################################
namespace: io.cloudslang.base.os.linux

operation:
  name: restart_service
  inputs:
    - service_name
    - host
    - port:
        default: "'22'"
    - username
    - password
    - privateKeyFile:
        default: "''"
    - command:
        default: |
            "service " + service_name + " restart"
        overridable: false
    - arguments:
        default: "''"
    - characterSet:
        default: "'UTF-8'"
    - pty:
        default: "'false'"
    - timeout:
        default: "'30000000'"
    - closeSession:
        default: "'false'"
  action:
    java_action:
      className: org.openscore.content.ssh.actions.SSHShellCommandAction
      methodName: runSshShellCommand
  outputs:
    - message: "'' if 'STDOUT' not in locals() else STDOUT"
    - error_message: "'' if 'STDERR' not in locals() else STDERR if returnCode == '0' else returnResult"
  results:
    - SUCCESS: returnCode == '0' and (not 'unrecognized' in STDERR)
    - FAILURE