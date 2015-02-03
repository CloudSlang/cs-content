#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

namespace: org.openscore.slang.base.remote_command_execution.ssh

imports:
 ssh: org.openscore.slang.base.remote_command_execution.ssh

flow:
  name: ssh_private_key_flow

  inputs:
    - host
    - port
    - username
    - password
    - privateKeyFile

  workflow:
    test_private_key_file:
          do:
            ssh.ssh_command:
              - host
              - port
              - command: "'ls'"
              - username
              - password
              - privateKeyFile
          publish:
            - returnResult
            - STDOUT
            - STDERR
            - exception

  outputs:
    - returnResult
    - STDOUT
    - STDERR
    - exception