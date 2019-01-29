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
#! @description: Copies a file from the local machine to a remote machine or from a remote machine to a different
#!               remote machine using the SCP protocol.
#!
#! @input source_host: Optional - Host of the source machine (only if remote to remote).
#! @input source_path: Absolute or relative path of the file about to be copied.
#! @input source_port: Optional - Port number for the source machine (only if remote to remote).
#!                     Default: '22'
#! @input source_username: Optional - Username of the source machine (only if remote to remote).
#! @input source_password: Optional - Password of the source machine (only if remote to remote).
#! @input source_private_key_file: Optional - Path to the private key file on the source machine.
#!                                 (only if remote to remote)
#! @input destination_host: Host of the destination machine.
#! @input destination_path: Absolute or relative path where the file will be copied.
#! @input destination_port: Optional - port number for the destination machine.
#!                          Default: '22'
#! @input destination_username: Username of the destination machine.
#! @input destination_password: Optional - Password of the destination machine.
#! @input destination_private_key_file: Optional - path to the private key file on the destination machine.
#! @input known_hosts_policy: Optional - Policy used for managing known_hosts file.
#!                            Valid: 'allow', 'strict', 'add'
#!                            Default: 'allow'
#! @input known_hosts_path: Path to the known_hosts file.
#! @input timeout: Optional - Time in milliseconds to wait for the command to complete.
#!                 Default: '90000'
#! @input proxy_host: Optional - HTTP proxy host to access the server.
#! @input proxy_port: Optional - HTTP proxy port.
#!                   Default: '8080'
#!
#! @output return_result: Confirmation message.
#! @output return_code: '0' if operation finished with SUCCESS, different than '0' otherwise.
#! @output exception: Exception description.
#!
#! @result SUCCESS: File copied successfully.
#! @result FAILURE: Copy failed.
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
    - destination_host:
        required: false
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
    - destination_username:
        required: false
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
    gav: 'io.cloudslang.content:cs-rft:0.0.6'
    class_name: io.cloudslang.content.rft.actions.RemoteSecureCopyAction
    method_name: copyTo

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
