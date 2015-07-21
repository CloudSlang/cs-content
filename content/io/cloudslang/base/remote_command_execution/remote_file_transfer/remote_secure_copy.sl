#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

###############################################################################################################################################################################
#   Copies a file on the remote machine using the SCP protocol.
#
#   Inputs:
#       - sourcePath - path of the file on the local machine
#       - destinationHost - host of the machine where the file will be copied
#       - destinationPath - path where the file will be copied
#       - destinationUsername - username to connect as
#       - destinationPassword - password of user
#   Results:
#       - SUCCESS - file copied successfully
#       - FAILURE - copy failed
###############################################################################################################################################################################

namespace: io.cloudslang.base.remote_command_execution.remote_file_transfer

operation:
    name: remote_secure_copy
    inputs:
      - sourcePath
      - destinationHost
      - destinationPath
      - destinationUsername
      - destinationPassword
    action:
          java_action:
            className: io.cloudslang.content.rft.actions.RemoteSecureCopyAction
            methodName: copyTo
    outputs:
      - return_result: returnResult
      - return_code: returnCode
      - exception
    results:
      - SUCCESS: returnCode == '0'
      - FAILURE
