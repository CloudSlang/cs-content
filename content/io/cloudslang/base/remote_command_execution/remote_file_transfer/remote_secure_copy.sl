#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
########################################################################################################################
# Copies a file from the local machine to a remote machine or from a remote machine to a different remote machine using
#   the SCP protocol.
#
# Inputs:
#   - source_host - optional - host of the source machine (only if remote to remote)
#   - source_path - absolute or relative path of the file about to be copied
#   - source_port - optional - port number for the source machine (only if remote to remote) - Default: '22'
#   - source_username - optional - username of the source machine (only if remote to remote)
#   - source_password - optional -  password of the source machine (only if remote to remote)
#   - source_private_key_file - optional - path to the private key file on the source machine (only if remote to remote)
#   - destination_host - host of the destination machine
#   - destination_path - absolute or relative path where the file will be copied
#   - destination_port - optional - port number for the destination machine - Default: '22'
#   - destination_username - username of the destination machine
#   - destination_password - optional - password of the destination machine
#   - destination_private_key_file - optional - path to the private key file on the destination machine
#   - known_hosts_policy - optional - policy used for managing known_hosts file - Valid: 'allow', 'strict', 'add'
#                                   - Default: 'allow'
#   - known_hosts_path - path to the known_hosts file
#   - timeout - optional - time in milliseconds to wait for the command to complete - Default: 90000 ms
# Outputs:
#   - return_result - confirmation message
#   - return_code - '0' if operation finished with SUCCESS, different than '0' otherwise
#   - exception - exception description
# Results:
#   - SUCCESS - file copied successfully
#   - FAILURE - copy failed
########################################################################################################################

namespace: io.cloudslang.base.remote_command_execution.remote_file_transfer

operation:
  name: remote_secure_copy
  inputs:
    - source_host:
        required: false
    - sourceHost:
        default: ${get("source_host", "")}
        overridable: false
    - source_path
    - sourcePath: ${source_path}
    - source_port:
        required: false
    - sourcePort:
        default: ${get("source_port", "22")}
        overridable: false
    - source_username:
        required: false
    - sourceUsername:
        default: ${get("source_username", "")}
        overridable: false
    - source_password:
        required: false
    - sourcePassword:
        default: ${get("source_password", "")}
        overridable: false
    - source_private_key_file:
        required: false
    - sourcePrivateKeyFile:
        default: ${get("source_private_key_file", "")}
        overridable: false
    - destination_host
    - destinationHost: ${destination_host}
    - destination_path
    - destinationPath: ${destination_path}
    - destination_port:
        required: false
    - destinationPort:
        default: ${get("destination_port", "22")}
        overridable: false
    - destination_username
    - destinationUsername: ${destination_username}
    - destination_password:
        required: false
    - destinationPassword:
        default: ${get("destination_password", "")}
        overridable: false
    - destination_private_key_file:
        required: false
    - destinationPrivateKeyFile:
        default: ${get("destination_private_key_file", "")}
        overridable: false
    - known_hosts_policy:
        required: false
    - knownHostsPolicy:
        default: ${get("known_hosts_policy", "allow")}
        overridable: false
    - known_hosts_path:
        required: false
    - knownHostsPath:
        default: ${get("known_hosts_path", "")}
        overridable: false
    - timeout:
        default: '90000'
        required: false
  action:
    java_action:
      className: io.cloudslang.content.rft.actions.RemoteSecureCopyAction
      methodName: copyTo
  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception
  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
