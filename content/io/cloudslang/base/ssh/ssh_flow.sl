#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Validates SSH access to the host and then runs an SSH command on the host.
#! @input host: hostname or IP address
#! @input port: optional - port number for running the command - Default: '22'
#! @input command: command to execute
#! @input pty: optional - whether to use PTY - Valid: true, false - Default: false
#!             When pty is true, the desired command must be appended with an exit command in order to close the channel,
#!             e.g. "echo something\n exit\n", otherwise the operation will time out
#! @input username: username to connect as
#! @input password: optional - password of user
#! @input arguments: optional - arguments to pass to the command
#! @input private_key_file: optional - path to the private key file
#! @input private_key_data: optional - A string representing the private key (OpenSSH type) used for authenticating the user.
#!                          This string is usually the content of a private key file. The 'privateKeyData' and the
#!                          'privateKeyFile' inputs are mutually exclusive. For security reasons it is recommend
#!                          that the private key be protected by a passphrase that should be provided through the
#!                          'password' input. - Default: none
#! @input known_hosts_policy: optional - The policy used for managing known_hosts file.
#!                            - Valid values: allow, strict, add. - Default value: strict
#! @input known_hosts_path: optional - The path to the known hosts file. - Default: {user.home}/.ssh/known_hosts
#! @input allowed_ciphers: optional - A comma separated list of ciphers that will be used in the client-server handshake
#!                         mechanism when the connection is created. Check the notes section for security concerns
#!                         regarding your choice of ciphers. The default value will be used even if the input is not
#!                         added to the operation.
#!                         Default value: aes128-ctr,aes128-cbc,3des-ctr,3des-cbc,blowfish-cbc,aes192-ctr,aes192-cbc,aes256-ctr,aes256-cbc
#! @input connect_timeout: optional - Time in milliseconds to wait for the connection to be made. - Default value: 10000
#! @input timeout: optional - time in milliseconds to wait for the command to complete - Default: 90000
#! @input character_set: optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8'
#! @input close_session: optional - if 'false' the SSH session will be cached for future calls of this operation during the
#!                       life of the flow, if 'true' the SSH session used by this operation will be closed
#!                       Valid: true, false - Default: false
#! @input agent_forwarding: optional - the sessionObject that holds the connection if the close session is false
#! @input smart_recovery: whether the flow should try to recover in case of SSH session failure
#!                        such failure may happen because of unstable ssh connection - e.g. 'Session is down' exception
#!                        Default: true
#! @input retries: limit of reconnect tries - Default: 5
#! @input proxy_host: optional - The proxy server used to access the remote machine.
#! @input proxy_port: optional - The proxy server port. - Default: 8080. - Valid values: -1 and numbers greater than 0.
#! @input proxy_username: optional - The user name used when connecting to the proxy.
#! @input proxy_password: optional - The proxy server password associated with the proxy_username input value.
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of successful request, null otherwise
#! @output exception: contains the stack trace in case of an exception
#! @output command_return_code: The return code of the remote command corresponding to the SSH channel. The return code is
#!                              only available for certain types of channels, and only after the channel was closed
#!                              (more exactly, just before the channel is closed).
#!                              Examples: '0' for a successful command, '-1' if the command was not yet terminated (or this
#!                              channel type has no command), '126' if the command cannot execute.
#! @output return_code: return code of the command
#! @result SUCCESS: SSH access was successful and returned with code '0'
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.base.ssh

imports:
  linux: io.cloudslang.base.os.linux
  utils: io.cloudslang.base.utils
  ssh: io.cloudslang.base.ssh

flow:
    name: ssh_flow
    inputs:
      - host
      - port: '22'
      - command
      - pty: 'false'
      - username
      - password:
          required: false
          sensitive: true
      - arguments:
          required: false
      - private_key_file:
          required: false
      - private_key_data:
          required: false
      - known_hosts_policy:
          default: 'strict'
          required: false
      - known_hosts_path:
          required: false
      - allowed_ciphers:
          default: 'aes128-ctr,aes128-cbc,3des-ctr,3des-cbc,blowfish-cbc,aes192-ctr,aes192-cbc,aes256-ctr,aes256-cbc'
          required: false
      - timeout:
          default: '90000'
          required: false
      - connect_timeout:
          default: '10000'
          required: false
      - character_set:
          required: false
      - close_session:
          required: false
      - agent_forwarding:
          required: false
      - smart_recovery:
          default: 'true'
      - retries:
          default: '5'
      - proxy_host:
          required: false
      - proxy_port:
          default: '8080'
          required: false
      - proxy_username:
          required: false
      - proxy_password:
          sensitive: true
          required: false
    workflow:
      - validate_ssh_access:
          do:
            linux.validate_linux_machine_ssh_access:
              - host
              - port
              - username
              - password
              - private_key_file
              - private_key_data
              - known_hosts_policy
              - known_hosts_path
              - allowed_ciphers
              - arguments
              - character_set
              - pty
              - timeout
              - connect_timeout
              - close_session
              - agent_forwarding
              - proxy_host
              - proxy_port
              - proxy_username
              - proxy_password

          publish:
            - return_result
            - return_code
            - standard_out
            - standard_err
            - exception
            - exit_status
          navigate:
            - SUCCESS: ssh_command
            - FAILURE: handle_ssh_session_recovery

      - ssh_command:
          do:
            ssh.ssh_command:
              - host
              - port
              - username
              - password
              - private_key_file
              - private_key_data
              - known_hosts_policy
              - known_hosts_path
              - allowed_ciphers
              - command
              - arguments
              - character_set
              - pty
              - timeout
              - connect_timeout
              - close_session
              - agent_forwarding
              - proxy_host
              - proxy_port
              - proxy_username
              - proxy_password
          publish:
            - return_result
            - standard_out
            - standard_err
            - return_code
            - exception
            - exit_status: ${ command_return_code }
          navigate:
            - SUCCESS: SUCCESS
            - FAILURE: handle_ssh_session_recovery

      - handle_ssh_session_recovery:
          do:
            utils.handle_session_recovery:
              - enabled: ${ smart_recovery }
              - retries
              - return_result
              - return_code
              - exit_status
          publish:
            - retries: ${updated_retries}
          navigate:
            - RECOVERY_DISABLED: FAILURE
            - TIMEOUT: FAILURE
            - SESSION_IS_DOWN: validate_ssh_access
            - FAILURE_WITH_NO_MESSAGE: validate_ssh_access
            - CUSTOM_FAILURE: validate_ssh_access
            - NO_ISSUE_FOUND: FAILURE
    outputs:
      - return_result
      - standard_out
      - standard_err
      - exception
      - command_return_code: ${ exit_status }
      - return_code
    results:
      - SUCCESS
      - FAILURE
