########################################################################################################################
#!!
#! @description: Uses Secure FTP (SFTP) to send a file on a RAS to a remote host.
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
#! @input remote_location: The remote location where the file is to be placed.
#! @input local_file: The path to the file on the RAS to be copied remotely using SFTP
#! @input character_set: The name of the control encoding to use. Examples: UTF-8, EUC-JP, SJIS.  Default is UTF-8.
#!                       Optional
#! @input close_session: Close the SSH session at completion of operation?  Default value is true.  If false the SSH
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
  name: sftp_put

  inputs:
    - host
    - port
    - username
    - password:
        sensitive: true
    - private_key:
        required: false
    - privateKey:
        default: ${get("private_key","")}
        required: false
    - remote_location:
        required: true
    - remoteLocation:
        default: ${get("remote_location","")}
        required: false
    - local_file:
        required: true
    - localFile:
        default: ${get("local_file","")}
        required: false
    - character_set:
        required: false
    - characterSet:
        default: ${get("character_set", "UTF-8")}
        private: true
    - close_session:
        required: false
    - closeSession:
        default: ${get("close_session", "true")}
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-rft:0.0.7-RC2'
    class_name: io.cloudslang.content.rft.actions.sftp.SFTPPut
    method_name: execute

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE
