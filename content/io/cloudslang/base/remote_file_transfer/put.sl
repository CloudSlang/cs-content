########################################################################################################################
#!!
#! @description: Provides the FTP PUT Operation.
#!
#! @input hostName: Hostname or ip address of ftp server.
#! @input port: The port the ftp service is listening on.
#! @input localFile: The local file name.
#! @input remoteFile: The remote file.
#! @input user: The user to connect as.
#! @input password: The password for user.
#! @input type: Optional - The type of the file to get.
#!     Default : binary
#!     Valid values: binary,ascii
#! @input passive: Optional - If true, passive connection mode will be enabled.
#!     The default is active connection mode.
#!     Valid values: true,false
#! @input characterSet: Optional - The name of the control encoding to use.
#!     Default: ISO-8859-1 (Latin-1).
#!
#!
#! @output return_result: A message is returned in case of success, an error message is returned in case of failure.
#! @output return_code: 0 if success, -1 otherwise.
#! @output exception: An error message in case there was an error while executing the operation.
#! @output reply_code: The ftp reply code.
#! @output session_log: Log of ftp commands.
#!
#! @result SUCCESS: File has been successfully uploaded.
#! @result FAILURE: There was an error during the execution.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.remote_file_transfer

operation:
  name: put

  inputs:
    - hostName
    - port
    - localFile
    - remoteFile
    - user
    - password:
        sensitive: true
    - type:
        required: false
        default: 'binary'
    - passive:
        required: false
        default: 'false'
    - characterSet:
        required: false


  java_action:
    gav: 'io.cloudslang.content:cs-rft:0.0.7-RC2'
    class_name: io.cloudslang.content.rft.actions.ftp.Put
    method_name: execute

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}
    - reply_code: ${get('ftpReplyCode', '')}
    - session_log: ${get('ftpSessionLog', '')}


  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE
