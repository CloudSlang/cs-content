#   (c) Copyright 2018 Micro Focus, L.P.
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
#! @description: Copies a file from the local machine to a remote machine or from a remote machine to a different
#!               remote machine using the SCP protocol.
#!
#! @input source_host: Host of the source machine (only if remote to remote).
#!                     Optional
#! @input source_path: Absolute or relative path of the file about to be copied.
#! @input source_port: Port number for the source machine (only if remote to remote).
#!                     Optional
#!                     Default: '22'
#! @input source_username: Username of the source machine (only if remote to remote).
#!                         Optional
#! @input source_password: Password of the source machine (only if remote to remote).
#!                         Optional
#! @input source_private_key_file: Path to the private key file on the source machine.
#!                                 (only if remote to remote)
#!                                 Optional
#! @input destination_host: Host of the destination machine.
#! @input destination_path: Absolute or relative path where the file will be copied.
#! @input destination_port: Port number for the destination machine.
#!                          Default: '22'
#!                          Optional
#! @input destination_username: Username of the destination machine.
#! @input destination_password: Password of the destination machine.
#!                              Optional
#! @input destination_private_key_file: Path to the private key file on the destination machine.
#!                                      Optional
#! @input known_hosts_policy: Policy used for managing known_hosts file.
#!                            Valid: 'allow', 'strict', 'add'
#!                            Default: 'allow'
#!                            Optional
#! @input known_hosts_path: Path to the known_hosts file.
#! @input timeout: Time in milliseconds to wait for the command to complete.
#!                 Default: '90000'
#!                 Optional
#! @input proxy_host: HTTP proxy host to access the server.
#!                    Optional
#! @input proxy_port: HTTP proxy port.
#!                    Default: '8080'
#!                    Optional
#!
#! @output return_result: Confirmation message.
#! @output return_code: '0' if operation finished with SUCCESS, different than '0' otherwise.
#! @output exception: An exception which displays the stacktrace in case of failure, otherwise empty.
#!
#! @result SUCCESS: File copied successfully.
#! @result FAILURE: An error has occurred while tyring to transfer the file.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.remote_file_transfer

operation:
  name: remote_secure_copy

  inputs:
    - source_host:
        required: false
    - sourceHost:
        default: ${get("source_host", "")}
        required: false
        private: true
    - source_path:
        required: false
    - sourcePath:
        default: ${get("source_path", "")}
        required: false
        private: true
    - source_port:
        required: false
    - sourcePort:
        default: ${get("source_port", "22")}
        private: true
    - source_username:
        required: false
    - sourceUsername:
        default: ${get("source_username", "")}
        required: false
        private: true
    - source_password:
        required: false
        sensitive: true
    - sourcePassword:
        default: ${get("source_password", "")}
        required: false
        private: true
        sensitive: true
    - source_private_key_file:
        required: false
    - sourcePrivateKeyFile:
        default: ${get("source_private_key_file", "")}
        required: false
        private: true
    - destination_host
    - destinationHost:
        default: ${get("destination_host", "")}
        required: false
        private: true
    - destination_path
    - destinationPath:
        default: ${get("destination_path", "")}
        required: false
        private: true
    - destination_port:
        required: false
    - destinationPort:
        default: ${get("destination_port", "22")}
        private: true
    - destination_username
    - destinationUsername:
        default: ${get("destination_username", "")}
        required: false
        private: true
    - destination_password:
        required: false
        sensitive: true
    - destinationPassword:
        default: ${get("destination_password", "")}
        required: false
        private: true
        sensitive: true
    - destination_private_key_file:
        required: false
    - destinationPrivateKeyFile:
        default: ${get("destination_private_key_file", "")}
        required: false
        private: true
    - known_hosts_policy:
        required: false
    - knownHostsPolicy:
        default: ${get("known_hosts_policy", "allow")}
        private: true
    - known_hosts_path:
        required: false
    - knownHostsPath:
        default: ${get("known_hosts_path", "")}
        required: false
        private: true
    - timeout:
        default: '90000'
        required: false
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
        default: ${get("proxy_port", "8080")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-rft:0.0.5'
    class_name: 'io.cloudslang.content.rft.actions.RemoteSecureCopyAction'
    method_name: 'copyTo'

  outputs:
    - return_code: ${get('returnCode', '')}
    - return_result: ${get('returnResult', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
