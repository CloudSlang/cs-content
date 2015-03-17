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
#       - host - hostname or IP address
#       - port - port number for running the command
#       - command - command to execute
#       - pty - whether to use pty; valid values: true, false; Default: false
#       - username - username to connect as
#       - password - password of user
#       - arguments - arguments to pass to the command
#       - privateKeyFile - the absolute path to the private key file
#       - timeout - time in milliseconds to wait for the command to complete; Default: 90000 ms
#       - characterSet - character encoding used for input stream encoding from the target machine; valid values: SJIS, EUC-JP, UTF-8; Default: UTF-8;
#       - closeSession - if false the ssh session will be cached for future calls of this operation during the life of the flow
#                     if true the ssh session used by this operation will be closed; Valid values: true, false; Default: true
#   Outputs:
#       - returnResult - contains the STDOUT of the remote machine in case of success or the cause of the error in case of exception
#       - STDOUT - contains the standard Output of the machine in case of successful request, null otherwise
#       - STDERR - contains the standard Error of the machine in case of successful request, null otherwise
#       - exception - contains the stack trace in case of an exception
#   Results:
#       - SUCCESS - the SSH access was successful and returned with code 0
#       - FAILURE
###############################################################################################################################################################################

namespace: org.openscore.slang.base.remote_command_execution.remote_file_transfer

operation:
    name: RemoteSecureCopy
    inputs:
      - sourcePath
      - destinationHost
      - destinationPath
      - username
      - password
    action:
          java_action:
            className: org.openscore.content.rft.actions.RemoteSecureCopyAction
            methodName: copyTo
    outputs:
      - return_result: returnResult
      - return_code: returnCode
      - exception
    results:
      - SUCCESS: returnCode == '0'
      - FAILURE
