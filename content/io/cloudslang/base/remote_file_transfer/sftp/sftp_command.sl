########################################################################################################################
#!!
#! @description: Executes one of the following commands: chmod, chgrp, chown, rename.
#!
#! @input host: IP address/host name.
#! @input port: The port to connect to on host.
#!              Optional
#! @input username: Remote username.
#! @input password: Password to authenticate. If using a private key file this will be used as the passphrase for the
#!                  file.
#! @input proxy_host: The proxy server used to access the remote host.
#!                    Optional
#! @input proxy_port: The proxy server port.
#!                    Optional
#! @input proxy_username: The username used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: The password used when connecting to the proxy.
#!                        Optional
#! @input private_key: Absolute path for private key file for public/private key authentication.
#!                     Optional
#! @input command_type: The command type.
#!                      Optional
#! @input remote_path: The full path of the remote file or directory name.
#!                     Optional
#! @input new_remote_path: The new name for the remote file or directory.
#! @input mode: New numeric mode for remote file or directory.  First digit is for everyone, second digit is for group,
#!              third digit is for owner.  Setuid, Setgid, and Sticky bits are not supported via SFTP.
#!              Examples: 765 (rwx,rw-,r-x), 432 (r--,-wx,-w-), 100 (--x,---,---).
#!              Optional
#! @input gid: New numeric group id for remote file or directory.
#!             Optional
#! @input uid: Numeric user id of the new owner for the remote file or directory.
#!             Optional
#! @input character_set: The name of the control encoding to use.
#!                       Examples: UTF-8, EUC-JP, SJIS.
#!                       Default is UTF-8.
#!                       Optional
#! @input close_session: Close the SSH session at completion of operation?  Default value is true.  If false the SSH
#!                       session can be reused by other SFTP commands in the same flow.
#!                       Valid values: true, false.
#!                       Optional
#! @input connection_timeout: Time in seconds to wait for the connection to complete.
#!                            Optional
#! @input execution_timeout: Time in seconds to wait for the operation to complete.
#!                           Optional
#!
#! @output return_result: This is the primary output and it contains the success message if the operation successfully
#!                        completes, or an exception message otherwise.
#! @output return_code: 0 if success, -1 otherwise.
#! @output exception: An error message in case there was an error while executing the operation.
#!
#! @result SUCCESS: Command completed successfully.
#! @result FAILURE: Command failed.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.remote_file_transfer.sftp

operation: 
  name: sftp_command
  
  inputs: 
    - host
    - port:
        required: false  
    - username    
    - password:    
        sensitive: true
    - proxy_host:  
        required: false  
    - proxyHost: 
        default: ${get('proxy_host', '')}  
        required: false 
        private: true 
    - proxy_port:  
        required: false  
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
    - command_type:  
        required: false  
    - commandType: 
        default: ${get('command_type', '')}  
        required: false 
        private: true 
    - remote_path:  
        required: false  
    - remotePath: 
        default: ${get('remote_path', '')}  
        required: false 
        private: true 
    - new_remote_path
    - newRemotePath:
        default: ${get('new_remote_path', '')}  
        required: false 
        private: true 
    - mode:  
        required: false  
    - gid:  
        required: false  
    - uid:  
        required: false  
    - character_set:  
        required: false  
    - characterSet: 
        default: ${get('character_set', '')}  
        required: false 
        private: true 
    - close_session:  
        required: false  
    - closeSession: 
        default: ${get('close_session', '')}  
        required: false 
        private: true 
    - connection_timeout:  
        required: false  
    - connectionTimeout: 
        default: ${get('connection_timeout', '')}  
        required: false 
        private: true 
    - execution_timeout:  
        required: false  
    - executionTimeout: 
        default: ${get('execution_timeout', '')}  
        required: false 
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-rft:1.0.10'
    class_name: 'io.cloudslang.content.rft.actions.sftp.SFTPCommand'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - return_code: ${get('returnCode', '')} 
    - exception: ${get('exception', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
