########################################################################################################################
#!!
#! @description: Uses Secure FTP (SFTP) to send a file from local file system to a remote host.
#!
#! @input host: IP address/host name.
#! @input port: The port to connect to on host.
#!              Default value: 22
#!              Optional
#! @input username: Remote username.
#! @input password: Password to authenticate. If using a private key file this will be used as the passphrase for the
#!                  file.
#! @input proxy_host: The proxy server used to access the remote host.
#!                    Optional
#! @input proxy_port: The proxy server port.
#!                    Default value: 8080
#!                    Optional
#! @input proxy_username: The username used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: The password used when connecting to the proxy.
#!                        Optional
#! @input private_key: Absolute path for private key file for public/private key authentication.
#!                     Optional
#! @input remote_location: The remote location where the file is to be placed.
#! @input local_file: The local file path to be copied remotely using SFTP.
#! @input global_session_object: The sessionObject that holds the connection if the close session is false.
#! @input character_set: The name of the control encoding to use.
#!                       Examples: UTF-8, EUC-JP, SJIS.
#!                       Default value: UTF-8
#!                       Optional
#! @input close_session: Close the SSH session at completion of operation. If false the SSH
#!                       session can be reused by other SFTP commands in the same flow.
#!                       Valid values: true, false.
#!                       Default value: true
#!                       Optional
#! @input connection_timeout: Time in seconds to wait for the connection to complete.
#!                            Default value: 60
#!                            Optional
#! @input execution_timeout: Time in seconds to wait for the operation to complete.
#!                           Default value: 60
#!                           Optional
#!
#! @output return_result: A suggestive message saying whether the operation was successful or an error message.
#! @output return_code: 0 if success, -1 otherwise.
#! @output exception: An error message in case there was an error while executing the operation.
#!
#! @result SUCCESS: Command completed successfully.
#! @result FAILURE: Command failed.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.remote_file_transfer.sftp

operation: 
  name: sftp_upload_file
  
  inputs: 
    - host
    - port:
        default: '22'
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
        default: '8080'
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
    - remote_location:  
        required: true
    - remoteLocation: 
        default: ${get('remote_location', '')}  
        required: false 
        private: true 
    - local_file:  
        required: true
    - localFile: 
        default: ${get('local_file', '')}  
        required: false 
        private: true
    - global_session_object:
        required: false
    - globalSessionObject:
        default: ${get('global_session_object', '')}
        required: false
        private: true
    - character_set:  
        required: false  
    - characterSet: 
        default: ${get('character_set', '')}  
        required: false 
        private: true 
    - close_session:
        default: 'true'
        required: false  
    - closeSession: 
        default: ${get('close_session', '')}  
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
    gav: 'io.cloudslang.content:cs-rft:0.0.9-RC4'
    class_name: 'io.cloudslang.content.rft.actions.sftp.SFTPUploadFile'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - return_code: ${get('returnCode', '')} 
    - exception: ${get('exception', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
