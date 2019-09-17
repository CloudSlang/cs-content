########################################################################################################################
#!!
#! @description: Uses Secure FTP (SFTP) to retrieve a single file from a remote host to a RAS.
#!
#! @input host: IP address/host name.
#!
#! @input port: The port to connect to on host.
#!
#! @input username: Remote username.
#!
#! @input password: Password to authenticate. If using a private key file this will be used as the passphrase for the  file
#! @input privateKey: Absolute path for private key file for public/private key authentication.
#!                     Optional
#! @input remoteFile: The remote file.
#! @input localLocation: The location where file is to be placed on the RAS.
#! @input agentForwarding: The sessionObject that holds the connection if the close session is false.
#!                          Optional
#! @input characterSet: The name of the control encoding to use. Examples: UTF-8, EUC-JP, SJIS.  Default is UTF-8.
#!                       Optional
#! @input closeSession: Close the SSH session at completion of operation?  Default value is true.  If false the SSH
#!                       session can be reused by other SFTP commands in the same flow.
#!                       Valid values: true, false.
#!                       Optional
#!
#! @output return_result: Remote file will be copied to local system.
#! @output return_code: 0 if success, -1 otherwise.
#! @output exception: An error message in case there was an error while executing the operation.
#!
#! @result SUCCESS: Command completed successfully.
#! @result FAILURE: Command failed.
#!!#
########################################################################################################################

namespace: io.cloudslang.rft.sftp

operation:
  name: sftp_get

  inputs:
    - host
    - port
    - username
    - password:
        sensitive: true
    - privateKey:
        required: false
    - remoteFile
    - localLocation
    - agentForwarding:
        required: false
    - characterSet:
        default: 'UTF-8'
        required: false
    - closeSession:
        default: 'true'
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-rft:0.0.7-SNAPSHOT'
    class_name: 'io.cloudslang.content.rft.actions.sftp.SFTPGet'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE
