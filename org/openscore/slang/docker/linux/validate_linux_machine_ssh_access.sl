#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will execute an empty SSH command
#   Inputs:
#       - host - Linux machine IP
#       - port - optional - SSH port - Default: 22
#       - username - Username
#       - password - Password
#   Outputs:
#       - response - linux welcome message
#   Results:
#       - SUCCESS
#       - FAILURE
####################################################

namespace: org.openscore.slang.docker.linux

operations:
    - validate_linux_machine_ssh_access:
        inputs:
          - host
          - port:
              default: "'22'"
              required: false
          - username
          - password
          - privateKeyFile:
              default: "''"
              override: true
          - command:
              default: "' '"
              override: true
          - arguments:
              default: "''"
              override: true
          - characterSet:
              default: "'UTF-8'"
              override: true
          - pty:
              default: "'false'"
              override: true
          - timeout:
              default: "'30000000'"
              override: true
          - closeSession:
              default: "'false'"
              override: true
        action:
          java_action:
            className: org.openscore.content.ssh.actions.SSHShellCommandAction
            methodName: runSshShellCommand
        outputs:
          - response: STDOUT
          - errorMessage: STDERR if returnCode == '0' else returnResult
        results:
          - SUCCESS : returnCode == '0' and (not 'Error' in STDERR)
          - FAILURE