#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

###############################################################################################################################################################################
# Copies a file from the local machine to a remote machine or from a remote machine to a different remote machine using the SCP protocol.
#
# Inputs:
#   - sourceHost - optional - host of the source machine (only if remote to remote)
#   - sourcePath - absolute or relative path of the file about to be copied
#   - sourcePort - optional - port number for the source machine (only if remote to remote) - Default: 22
#   - sourceUsername - optional - username of the source machine (only if remote to remote)
#   - sourcePassword - optional -  password of the source machine (only if remote to remote)
#   - sourcePrivateKeyFile - optional - path to the private key file on the source machine (only if remote to remote)
#   - destinationHost - host of the destination machine
#   - destinationPath - absolute or relative path where the file will be copied
#   - destinationPort - optional - port number for the destination machine - Default: 22
#   - destinationUsername - username of the destination machine
#   - destinationPassword - optional - password of the destination machine
#   - destinationPrivateKeyFile - optional - path to the private key file on the destination machine
#   - knownHostsPolicy - optional - policy used for managing known_hosts file - Default: allow - Valid: allow, strict, add
#   - knownHostsPath - optional - path to the known_hosts file
#   - timeout - optional - time in milliseconds to wait for the command to complete - Default: 90000
# Outputs:
#   - return_result - confirmation message
#   - return_code - 0 if operation finished with SUCCESS, not 0 otherwise
#   - exception - exception description
# Results:
#   - SUCCESS - file copied successfully
#   - FAILURE - copy failed
###############################################################################################################################################################################

namespace: io.cloudslang.base.remote_command_execution.remote_file_transfer

operation:
    name: remote_secure_copy
    inputs:
      - sourceHost:
          required: false
      - sourcePath
      - sourcePort:
          required: false
          default: '22'
      - sourceUsername:
          required: false
      - sourcePassword:
          required: false
      - sourcePrivateKeyFile:
          required: false
      - destinationHost
      - destinationPath
      - destinationPort:
          required: false
          default: '22'
      - destinationUsername
      - destinationPassword:
          required: false
      - destinationPrivateKeyFile:
          required: false
      - knownHostsPolicy:
          required: false
          default: 'allow'
      - knownHostsPath:
          required: false
      - timeout:
          required: false
          default: '90000'
    action:
          java_action:
            className: io.cloudslang.content.rft.actions.RemoteSecureCopyAction
            methodName: copyTo
    outputs:
      - return_result: returnResult
      - return_code: returnCode
      - exception
    results:
      - SUCCESS: ${ returnCode == '0' }
      - FAILURE
