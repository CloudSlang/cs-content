#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: Runs an SSH command on the host.
#!
#! @input host: Hostname or IP address.
#! @input port: Port number for running the command.
#!              Default: '22'
#!              Optional
#! @input command: Command to execute.
#! @input pty: whether to use PTY.
#!             Valid: 'true', 'false'
#!             Default: 'false'
#!             When pty is true, the desired command must be appended with an exit command in order to close the channel,
#!             e.g. "echo something\n exit\n", otherwise the operation will time out.
#!             Optional
#! @input username: Username to connect as.
#! @input password: Password of user.
#!                  Optional
#! @input arguments: Arguments to pass to the command.
#!                   Optional
#! @input private_key_file: Absolute path to private key file
#!                          Default: ''
#!                          Optional
#! @input private_key_data: A string representing the private key (OpenSSH type) used for authenticating the user.
#!                          This string is usually the content of a private key file. The 'privateKeyData' and the
#!                          'privateKeyFile' inputs are mutually exclusive. For security reasons it is recommend
#!                          that the private key be protected by a passphrase that should be provided through the
#!                          'password' input.
#!                          Default: ''
#!                          Optional
#! @input known_hosts_policy: The policy used for managing known_hosts file.
#!                            Valid values: 'allow', 'strict', 'add'
#!                            Default value: 'allow'
#!                            Optional
#! @input known_hosts_path: The path to the known hosts file.
#!                          Default: '{user.home}/.ssh/known_hosts'
#!                          Optional
#! @input allowed_ciphers: A comma separated list of ciphers that will be used in the client-server handshake
#!                         mechanism when the connection is created. Check the notes section for security concerns
#!                         regarding your choice of ciphers. The default value will be used even if the input is not
#!                         added to the operation.
#!                         Default value: 'aes128-ctr,aes128-cbc,3des-ctr,3des-cbc,blowfish-cbc,
#!                                        aes192-ctr,aes192-cbc,aes256-ctr,aes256-cbc'
#!                         Optional
#! @input timeout: Time in milliseconds to wait for the command to complete
#!                 Default: '90000'
#!                 Optional
#! @input connect_timeout: Time in milliseconds to wait for the connection to be made.
#!                         Default value: '10000'
#!                         Optional
#! @input character_set: character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8' - Default: 'UTF-8'
#!                       Optional
#! @input close_session: if 'false' the SSH session will be cached for future calls of this operation during the
#!                       life of the flow, if 'true' the SSH session used by this operation will be closed
#!                       Valid: 'true', 'false'
#!                       Default: 'false'
#!                       Optional
#! @input agent_forwarding: The sessionObject that holds the connection if the close session is false.
#!                          Optional
#! @input proxy_host: The proxy server used to access the remote machine.
#!                    Optional
#! @input proxy_port: The proxy server port.
#!                    Valid values: -1 and numbers greater than 0.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: The user name used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
#!                   Optional
#! @input use_shell: Specifies whether to use shell mode to run the commands. This will start a shell
#!                   session and run the command, after which it will issue an 'exit' command, to close
#!                   the shell.
#!                   Note: If the output does not show the whole expected output, increase the <timeout> value.
#!                   Valid values: 'true', 'false'
#!                   Default: 'false'
#!                   Optional
#!
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output return_code: Return code of the command
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of successful request, null otherwise
#! @output exception: Contains the stack trace in case of an exception
#! @output command_return_code: The return code of the remote command corresponding to the SSH channel. The return code is
#!                              only available for certain types of channels, and only after the channel was closed
#!                              (more exactly, just before the channel is closed).
#!                              Examples: '0' for a successful command, '-1' if the command was not yet terminated (or this
#!                              channel type has no command), '126' if the command cannot execute.
#!
#! @result SUCCESS: SSH access was successful and returned with code '0'.
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.ssh

operation:
    name: ssh_command

    inputs:
      - host
      - port:
          default: '22'
          required: false
      - command
      - pty:
          default: 'false'
          required: false
      - username
      - password:
          required: false
          sensitive: true
      - arguments:
          required: false
      - private_key_file:
          required: false
      - privateKeyFile:
          default: ${get("private_key_file", "")}
          required: false
          private: true
      - private_key_data:
          required: false
      - privateKeyData:
          default: ${get("private_key_data", "")}
          required: false
          private: true
      - known_hosts_policy:
          default: 'allow'
          required: false
      - knownHostsPolicy:
          default: ${get("known_hosts_policy", "")}
          required: false
          private: true
      - known_hosts_path:
          required: false
      - knownHostsPath:
          default: ${get("known_hosts_path", "")}
          required: false
          private: true
      - allowed_ciphers:
          default: 'aes128-ctr,aes128-cbc,3des-ctr,3des-cbc,blowfish-cbc,aes192-ctr,aes192-cbc,aes256-ctr,aes256-cbc'
          required: false
      - allowedCiphers:
          default: ${get("allowed_ciphers", "")}
          required: false
          private: true
      - timeout:
          default: '90000'
          required: false
      - connect_timeout:
          default: '10000'
          required: false
      - connectTimeout:
          default: ${get("connect_timeout", "")}
          required: false
          private: true
      - character_set:
          required: false
      - characterSet:
          default: ${get("character_set", "UTF-8")}
          private: true
      - close_session:
          required: false
      - closeSession:
          default: ${get("close_session", "false")}
          private: true
      - agent_forwarding:
          required: false
      - agentForwarding:
          default: ${get("agent_forwarding", "")}
          required: false
          private: true
      - proxy_host:
          required: false
      - proxyHost:
          default: ${get("proxy_host", "")}
          required: false
          private: true
      - proxy_port:
          default: '8080'
          required: false
      - proxyPort:
          default: ${get("proxy_port", "")}
          required: false
          private: true
      - proxy_username:
          required: false
      - proxyUsername:
          default: ${get("proxy_username", "")}
          required: false
          private: true
      - proxy_password:
          sensitive: true
          required: false
      - proxyPassword:
          default: ${get("proxy_password", "")}
          sensitive: true
          required: false
          private: true
      - use_shell:
          default: 'false'
          required: false
      - useShell:
          default: ${get('use_shell', '')}
          required: false
          private: true

    java_action:
      gav: 'io.cloudslang.content:cs-ssh:0.0.37'
      class_name: io.cloudslang.content.ssh.actions.SSHShellCommandAction
      method_name: runSshShellCommand

    outputs:
      - return_result: ${ get('returnResult', '') }
      - return_code: ${ returnCode }
      - standard_out: ${ '' if 'STDOUT' not in locals() else STDOUT }
      - standard_err: ${ '' if 'STDERR' not in locals() else STDERR }
      - exception: ${ '' if 'exception' not in locals() else exception }
      - command_return_code: ${ '' if 'exitStatus' not in locals() else exitStatus }

    results:
      - SUCCESS: ${ returnCode == '0' and (STDERR is None or (not 'Error' in STDERR)) }
      - FAILURE
