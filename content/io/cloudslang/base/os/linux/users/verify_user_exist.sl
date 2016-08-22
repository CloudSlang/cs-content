# (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Perform a SSH command to to verify if a specified <user_name> exist
#! @input host: hostname or IP address
#! @input root_password: the root password
#! @input user_name: the name of the user to verify if exist
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of successful request, null otherwise
#! @output exception: contains the stack trace in case of an exception
#! @output command_return_code: The return code of the remote command corresponding to the SSH channel. The return code is
#!                              only available for certain types of channels, and only after the channel was closed
#!                              (more exactly, just before the channel is closed).
#!                              Examples: 0 for a successful command, -1 if the command was not yet terminated (or this
#!                              channel type has no command), 126 if the command cannot execute.
#! @output message: returns 'The "<user_name>" user exist.' if the user exist or 'The "<user_name>" user does not exist.'
#!                  otherwise
#! @result SUCCESS: SSH access was successful
#! @result FAILURE: otherwise
#!!#
####################################################
namespace: io.cloudslang.base.os.linux.users

imports:
  ssh: io.cloudslang.base.ssh

flow:
  name: verify_user_exist

  inputs:
    - host
    - root_password:
        sensitive: true
    - user_name

  workflow:
    - verify_if_user_exist:
        do:
          ssh.ssh_flow:
            - host
            - port: '22'
            - username: 'root'
            - password: ${root_password}
            - command: >
                ${'cut -d\":\" -f1 /etc/passwd | grep ' + user_name}
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
    - message: >
        ${'The \"' + user_name + '\" user exist.' if (command_return_code == '0' and standard_out.strip() == user_name)
        else 'The \"' + user_name + '\" user does not exist.'}
