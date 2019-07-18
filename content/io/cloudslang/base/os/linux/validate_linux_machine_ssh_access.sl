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
#! @description: Executes a no-op SSH command.
#!
#! @input host: Docker machine host.
#! @input port: Optional - SSH port
#!              Default: '22'
#! @input username: Docker machine username.
#! @input password: Optional - Docker machine password.
#! @input private_key_file: Optional - absolute path to private key file.
#! @input private_key_data: Optional - A string representing the private key (OpenSSH type) used to authenticate the user.
#!                          This string is usually the content of a private key file. The 'privateKeyData' and the
#!                          'privateKeyFile' inputs are mutually exclusive. For security reasons it is recommend
#!                          that the private key be protected by a passphrase that should be provided through the
#!                          'password' input.
#!                          Default: ''
#! @input arguments: Optional - arguments to pass to the command
#! @input character_set: Optional - character encoding used for input stream encoding from target machine
#!                       Valid: 'SJIS', 'EUC-JP', 'UTF-8' - Default: 'UTF-8'
#! @input known_hosts_policy: Optional - The policy used for managing known_hosts file.
#!                            Valid values: 'allow', 'strict', 'add'.
#!                            Default value: 'allow'
#! @input known_hosts_path: Optional - The path to the known hosts file.
#!                          Default: '{user.home}/.ssh/known_hosts'
#! @input allowed_ciphers: Optional - A comma separated list of ciphers that will be used in the client-server handshake
#!                         mechanism when the connection is created. Check the notes section for security concerns
#!                         regarding your choice of ciphers. The default value will be used even if the input is not
#!                         added to the operation.
#!                         Default value: 'aes128-ctr,aes128-cbc,3des-ctr,3des-cbc,blowfish-cbc,aes192-ctr,
#!                                        aes192-cbc,aes256-ctr,aes256-cbc'
#! @input pty: Optional - whether to use PTY.
#!             Valid: 'true', 'false'
#!             Default: 'false'
#! @input timeout: Time in milliseconds to wait for command to complete.
#!                 Default: '30000000'
#! @input connect_timeout: Optional - Time in milliseconds to wait for the connection to be made.
#!                         Default: '10000'
#! @input close_session: Optional - if 'false' the SSH session will be cached for future calls of this operation during
#!                       the life of the flow, if 'true' the SSH session used by this operation will be closed
#!                       Valid: 'true', 'false'
#!                       Default: 'false'
#! @input agent_forwarding: Optional - the sessionObject that holds the connection if the close session is false.
#! @input proxy_host: Optional - The proxy server used to access the remote machine.
#! @input proxy_port: Optional - The proxy server port.
#!                    Valid values: -1 and numbers greater than 0.
#!                    Default: '8080'
#! @input proxy_username: Optional - The user name used when connecting to the proxy.
#! @input proxy_password: Optional - The proxy server password associated with the proxy_username input value.
#! @input use_shell: Specifies whether to use shell mode to run the commands. This will start a shell
#!                   session and run the command, after which it will issue an 'exit' command, to close
#!                   the shell.
#!                   Note: If the output does not show the whole expected output, increase the <timeout> value.
#!                   Valid values: 'true', 'false'
#!                   Default: 'false'
#!                   Optional
#!
#! @output return_result: Contains the exception in case of failure, success message otherwise
#! @output return_code: "0" if successful, "-1" otherwise
#! @output standard_out: STDOUT of the machine in case of successful request, null otherwise
#! @output standard_err: STDERR of the machine in case of successful request, null otherwise
#! @output exception: Exception in case of failure
#! @output exit_status: Return code of the remote command
#!
#! @result SUCCESS: Command execution finished successfully
#! @result FAILURE: Otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.base.os.linux

operation:
  name: validate_linux_machine_ssh_access

  inputs:
    - host
    - port:
        default: '22'
        required: false
    - username
    - password:
        required: false
        sensitive: true
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
    - command:
        default: ':'
        private: true
    - arguments:
        required: false
    - character_set:
        required: false
    - characterSet:
        default: ${get("character_set", "UTF-8")}
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
    - connect_timeout:
        default: '10000'
        required: false
    - connectTimeout:
        default: ${get("connect_timeout", "")}
        required: false
        private: true
    - pty:
        default: 'false'
        private: true
    - timeout:
        default: '30000000'
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
        required: false
        default: '8080'
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
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get("proxy_password", "")}
        required: false
        private: true
        sensitive: true
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
    - standard_out: ${ get('STDOUT', '') }
    - standard_err: ${ get('STDERR', '') }
    - exception: ${ get('exception', '') }
    - exit_status: ${ get('exitStatus', '') }

  results:
    - SUCCESS: ${ returnCode == '0' and (STDERR is None or (not 'Error' in STDERR)) }
    - FAILURE
