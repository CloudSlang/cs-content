# (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Perform a SSH command to verify if a specified <group_name> exist
#! @input host: hostname or IP address
#! @input root_password: the root password
#! @input group_name: the name of the group to verify if exist
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of successful request, null otherwise
#! @output exception: contains the stack trace in case of an exception
#! @output command_return_code: The return code of the remote command corresponding to the SSH channel. The return code is
#!                              only available for certain types of channels, and only after the channel was closed
#!                              (more exactly, just before the channel is closed).
#!                              Examples: 0 for a successful command, -1 if the command was not yet terminated (or this
#!                              channel type has no command), 126 if the command cannot execute.
#! @output message: returns 'The "<group_name>" group exist.' if the group exist or 'The "<group_name>" group does not exist.'
#!                  otherwise
#! @result SUCCESS: verify group exist SSH command was successfully executed
#! @result FAILURE: otherwise
#!!#
####################################################
namespace: io.cloudslang.base.os.linux.groups

imports:
  ssh: io.cloudslang.base.ssh
  utils: io.cloudslang.base.utils

flow:
  name: verify_group_exist

  inputs:
    - host
    - root_password:
        sensitive: true
    - group_name

  workflow:
    - verify_if_group_exist:
        do:
          ssh.ssh_flow:
            - host
            - port: '22'
            - username: 'root'
            - password: ${root_password}
            - command: >
                ${'cat /etc/group | grep ' + group_name +  ' | cut -d \":\" -f1 | grep ' + group_name}
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code

    - evaluate_result:
        do:
          utils.is_true:
            - bool_value: ${return_code == '0' and command_return_code == '0'}
  outputs:
    - return_result
    - standard_err
    - standard_out
    - return_code
    - command_return_code
    - message: >
        ${'The \"' + group_name + '\" group exist.' if (command_return_code == '0' and standard_out.strip() == group_name)
        else 'The \"' + group_name + '\" group does not exist.'}

  results:
    - SUCCESS
    - FAILURE
