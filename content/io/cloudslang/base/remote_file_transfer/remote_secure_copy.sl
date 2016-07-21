#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
########################################################################################################################
#!!
#! @description: Copies a file from the local machine to a remote machine or from a remote machine to a different remote machine using
#!               the SCP protocol.
#! @input source_host: optional - host of the source machine (only if remote to remote)
#! @input source_path: absolute or relative path of the file about to be copied
#! @input source_port: optional - port number for the source machine (only if remote to remote) - Default: '22'
#! @input source_username: optional - username of the source machine (only if remote to remote)
#! @input source_password: optional -  password of the source machine (only if remote to remote)
#! @input source_private_key_file: optional - path to the private key file on the source machine (only if remote to remote)
#! @input destination_host: host of the destination machine
#! @input destination_path: absolute or relative path where the file will be copied
#! @input destination_port: optional - port number for the destination machine - Default: '22'
#! @input destination_username: username of the destination machine
#! @input destination_password: optional - password of the destination machine
#! @input destination_private_key_file: optional - path to the private key file on the destination machine
#! @input known_hosts_policy: optional - policy used for managing known_hosts file - Valid: 'allow', 'strict', 'add'
#!                            Default: 'allow'
#! @input known_hosts_path: path to the known_hosts file
#! @input timeout: optional - time in milliseconds to wait for the command to complete - Default: 90000 ms
#! @output return_result: confirmation message
#! @output return_code: '0' if operation finished with SUCCESS, different than '0' otherwise
#! @output exception: exception description
#! @result SUCCESS: file copied successfully
#! @result FAILURE: copy failed
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
    - source_path
    - sourcePath: ${source_path}
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
    - destinationHost: ${destination_host}
    - destination_path
    - destinationPath: ${destination_path}
    - destination_port:
        required: false
    - destinationPort:
        default: ${get("destination_port", "22")}
        private: true
    - destination_username
    - destinationUsername: ${destination_username}
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
  java_action:
    gav: 'io.cloudslang.content:cs-rft:0.0.3'
    class_name: io.cloudslang.content.rft.actions.RemoteSecureCopyAction
    method_name: copyTo
  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception
  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
