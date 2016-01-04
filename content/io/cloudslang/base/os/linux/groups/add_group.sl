# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow performs a linux command to add a specified group named <group_name>
#
# Inputs:
#   - host - hostname or IP address
#   - root_password - the root password
#   - group_name - the group name where to be added
#
# Outputs:
#   - return_result - STDOUT of the remote machine in case of success or the cause of the error in case of exception
#   - standard_out - STDOUT of the machine in case of successful request, null otherwise
#   - standard_err - STDERR of the machine in case of successful request, null otherwise
#   - exception - contains the stack trace in case of an exception
#   - command_return_code - The return code of the remote command corresponding to the SSH channel. The return code is
#                           only available for certain types of channels, and only after the channel was closed
#                           (more exactly, just before the channel is closed).
#	                        Examples: 0 for a successful command, -1 if the command was not yet terminated (or this
#                                     channel type has no command), 126 if the command cannot execute.
# Results:
#    - SUCCESS - add group SSH command was successfully executed
#    - FAILURE - otherwise
####################################################
namespace: io.cloudslang.base.os.linux.groups

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: add_group

  inputs:
    - host
    - root_password
    - group_name

  workflow:
    - add_group:
        do:
          ssh.ssh_flow:
            - host
            - port: '22'
            - username: 'root'
            - password: ${root_password}
            - command: ${'addgroup ' + group_name}
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code

  outputs:
    - return_result
    - standard_err
    - standard_out
    - return_code
    - command_return_code

  results:
    - SUCCESS: ${return_code == '0' and command_return_code == '0'}
    - FAILURE