#   (c) Copyright 2021 Micro Focus
#   All rights reserved. This program and the accompanying materials
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
#! @description: This operation copies files between two remote machines using different protocols: local, SCP, SFTP, SMB3.
#!
#! @input source_host: The host where the source file is located.
#! @input source_port: The port for connecting to the source host.
#!                     Optional
#! @input source_username: The username for connecting to the host of the source file.
#!                         Optional
#! @input source_password: The password for connecting to the host of the source file.
#!                         Optional
#! @input source_private_key_file: Absolute path of the private key file for public/private key authentication
#!                                 on the source host.
#!                                 Optional
#! @input source_path: The absolute path to the source file. For the SFTP protocol please use a relative path to the SFTP
#!                     server root directory.
#! @input source_protocol: The protocol used to copy from the source file.
#!                         Valid values: local, SCP, SFTP, SMB3.
#! @input source_character_set: The name of the control encoding to use with source host for SFTP protocol.
#!                              Valid value: UTF-8, EUC-JP, SJIS.
#!                              Default: UTF-8
#!                              Optional
#! @input destination_host: The destination host of the file to be transferred.
#! @input destination_port: The port for connecting to the destination host.
#!                          Optional
#! @input destination_username: The username for connecting to the destination host.
#!                              Optional
#! @input destination_password: The password for connecting to the destination host.
#!                              Optional
#! @input destination_private_key_file: Absolute path of the private key file for public/private key authentication
#!                                      on the destination host.
#!                                      Optional
#! @input destination_path: The absolute path to the destination file.
#!                          When using the protocol SMB33 the destination path should start with the samba shared folder.
#!                          Example: sambaSharedFolder\folder1\folder2\file.
#! @input destination_protocol: The protocol used to copy to the destination file.
#!                              Valid value: local, SCP, SFTP, SMB3.
#! @input destination_character_set: The name of the control encoding to use with destination host for SFTP protocol.
#!                                   Valid values: UTF-8, EUC-JP, SJIS.
#!                                   Default: UTF-8.
#!                                   Optional
#! @input connection_timeout: Time in seconds to wait for the connection to complete.
#!                            Default: 60
#!                            Optional
#! @input execution_timeout: Time in milliseconds to wait for the operation to complete.
#!                           Default: 60
#!                           Optional
#!
#! @output return_result: The file transfer was successfully completed.
#! @output return_code: '0' if operation finished with SUCCESS, '-1' otherwise.
#! @output exception: An exception which displays the stacktrace in case of failure, empty otherwise.
#!
#! @result SUCCESS: The operation was successfully completed.
#! @result FAILURE: An error has occurred while tyring to transfer the file.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.remote_file_transfer

operation:
  name: remote_copy

  inputs:
    - source_host
    - sourceHost:
        default: ${get('source_host', '')}
        required: false
        private: true
    - source_port:
        required: false
    - sourcePort:
        default: ${get('source_port', '')}
        required: false
        private: true
    - source_username:
        required: false
    - sourceUsername:
        default: ${get('source_username', '')}
        required: false
        private: true
    - source_password:
        required: false
        sensitive: true
    - sourcePassword:
        default: ${get('source_password', '')}
        required: false
        private: true
        sensitive: true
    - source_private_key_file:
        required: false
    - sourcePrivateKeyFile:
        default: ${get('source_private_key_file', '')}
        required: false
        private: true
    - source_path
    - sourcePath:
        default: ${get('source_path', '')}
        required: false
        private: true
    - source_protocol
    - sourceProtocol:
        default: ${get('source_protocol', '')}
        required: false
        private: true
    - source_character_set:
        default: 'UTF-8'
        required: false
    - sourceCharacterSet:
        default: ${get('source_character_set', '')}
        required: false
        private: true
    - destination_host
    - destinationHost:
        default: ${get('destination_host', '')}
        required: false
        private: true
    - destination_port:
        required: false
    - destinationPort:
        default: ${get('destination_port', '')}
        required: false
        private: true
    - destination_username:
        required: false
    - destinationUsername:
        default: ${get('destination_username', '')}
        required: false
        private: true
    - destination_password:
        required: false
        sensitive: true
    - destinationPassword:
        default: ${get('destination_password', '')}
        required: false
        private: true
        sensitive: true
    - destination_private_key_file:
        required: false
    - destinationPrivateKeyFile:
        default: ${get('destination_private_key_file', '')}
        required: false
        private: true
    - destination_path
    - destinationPath:
        default: ${get('destination_path', '')}
        required: false
        private: true
    - destination_protocol
    - destinationProtocol:
        default: ${get('destination_protocol', '')}
        required: false
        private: true
    - destination_character_set:
        default: 'UTF-8'
        required: false
    - destinationCharacterSet:
        default: ${get('destination_character_set', '')}
        required: false
        private: true
    - connection_timeout:
        default: '60'
        required: false
    - connectionTimeout:
        default: ${get('connection_timeout', '')}
        required: false
        private: true
    - execution_timeout:
        default: '60'
        required: false
    - executionTimeout:
        default: ${get('execution_timeout', '')}
        required: false
        private: true
        
  java_action:
    gav: 'io.cloudslang.content:cs-rft:0.0.91-SNAPSHOT'
    class_name: io.cloudslang.content.rft.actions.RemoteCopyAction
    method_name: execute

  outputs:
    - return_code: ${get('returnCode', '')}
    - return_result: ${get('returnResult', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
