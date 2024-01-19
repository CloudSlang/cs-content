#   Copyright 2024 Open Text
#   This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an 'AS IS' BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: Uses Secure FTP (SFTP) to retrieve a single file from a remote host.
#!
#! @input host: IP address/host name.
#! @input port: The port to connect to on host.
#!              Default value: 22
#!              Optional
#! @input username: Remote username.
#! @input password: Password to authenticate. If using a private key file this will be used as the passphrase for the
#!                  file.
#! @input remote_file: The file to be downloaded remotely using SFTP.
#!                     Example: file.txt
#! @input remote_path: The remote directory path from where the file will be downloaded.
#!                     Examples: C:/Users/Administrator, root/test
#! @input local_path: The local directory path where the file will be downloaded.
#!                    Examples: C:/Users/Administrator, root/test
#! @input proxy_host: The proxy server used to access the remote host.
#!                    Optional
#! @input proxy_port: The proxy server port.
#!                    Default value: 8080
#!                    Optional
#! @input proxy_username: The username used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: The password used when connecting to the proxy.
#!                        Optional
#! @input private_key: Absolute path for private key file for public/private key authentication.
#!                     Optional
#! @input character_set: The name of the control encoding to use.
#!                       Examples: UTF-8, EUC-JP, SJIS.
#!                       Default: UTF-8
#!                       Optional
#! @input close_session: Close the SSH session at completion of operation. If false the SSH
#!                       session can be reused by other SFTP commands in the same flow.
#!                       Valid values: true, false.
#!                       Default value: true
#!                       Optional
#! @input connection_timeout: Time in seconds to wait for the connection to complete.
#!                            Default value: 60
#!                            Optional
#! @input execution_timeout: Time in seconds to wait for the operation to complete.
#!                           Default value: 60
#!                           Optional
#!
#! @output return_result: Remote file will be copied to local system.
#! @output return_code: 0 if success, -1 otherwise.
#! @output exception: An error message in case there was an error while executing the operation.
#!
#! @result SUCCESS: Command completed successfully.
#! @result FAILURE: Command failed.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.remote_file_transfer.sftp

operation:
  name: sftp_download_file

  inputs:
    - host
    - port:
        default: '22'
        required: false
    - username
    - password:
        sensitive: true
    - remote_file
    - remoteFile:
        default: ${get('remote_file', '')}
        required: false
        private: true
    - remote_path
    - remotePath:
        default: ${get('remote_path', '')}
        required: false
        private: true
    - local_path
    - localPath:
        default: ${get('local_path', '')}
        required: false
        private: true
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get('proxy_host', '')}
        required: false
        private: true
    - proxy_port:
        required: false
        default: '8080'
    - proxyPort:
        default: ${get('proxy_port', '')}
        required: false
        private: true
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get('proxy_username', '')}
        required: false
        private: true
    - proxy_password:
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get('proxy_password', '')}
        required: false
        private: true
        sensitive: true
    - private_key:
        required: false
    - privateKey:
        default: ${get('private_key', '')}
        required: false
        private: true
    - character_set:
        default: 'UTF-8'
        required: false
    - characterSet:
        default: ${get('character_set', '')}
        required: false
        private: true
    - close_session:
        default: 'true'
        required: false
    - closeSession:
        default: ${get('close_session', '')}
        required: false
        private: true
    - connection_timeout:
        required: false
        default: '60'
    - connectionTimeout:
        default: ${get('connection_timeout', '')}
        required: false
        private: true
    - execution_timeout:
        required: false
        default: '60'
    - executionTimeout:
        default: ${get('execution_timeout', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-rft:1.0.10'
    class_name: 'io.cloudslang.content.rft.actions.sftp.SFTPDownloadFile'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE
