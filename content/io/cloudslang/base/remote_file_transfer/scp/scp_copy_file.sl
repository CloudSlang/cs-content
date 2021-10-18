#   (c) Copyright 2021 Micro Focus
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an 'AS IS' BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: Copy files to and from remote machine through SSH.
#!
#! @input host: IP address/host name.
#! @input port: The port number to connect to.
#!              Default value: 22
#!              Optional
#! @input username: Remote username.
#! @input password: Password of user. If using a private key file this will be used as the passphrase for the file.
#! @input local_file: Absolute path to the local file. This path is relative to the host that the operation is running
#!                    on.
#! @input copy_action: To/From copy action.
#!                     Valid values: to, from
#! @input remote_file: Absolute path to remote file.
#! @input proxy_host: The proxy server used to access the remote host.
#!                    Optional
#! @input proxy_port: The proxy server port.
#!                    Default value: 8080
#!                    Optional
#! @input proxy_username: The username used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: The password used when connecting to the proxy.
#!                        Optional
#! @input known_hosts_policy: Optional - Policy used for managing known_hosts file. Valid: 'allow', 'strict', 'add'
#!                            Default value: allow
#!                            Optional
#! @input known_hosts_path: Path to the known_hosts file.
#!                          Optional
#! @input private_key: Absolute path for private key file for public/private key authentication.
#!                     Optional
#! @input connection_timeout: Time in seconds to wait for the connection to complete.
#!                            Default value: 60
#!                            Optional
#! @input execution_timeout: Time in seconds to wait for the operation to complete.
#!                           Default value: 60
#!                           Optional
#!
#! @output return_result: This is the primary output and it contains the success message if the operation successfully
#!                        completes, or an exception message otherwise.
#! @output return_code: 0 if success, -1 otherwise.
#! @output exception: An error message in case there was an error while executing the operation.
#!
#! @result SUCCESS: The file was copied successfully.
#! @result FAILURE: The file could not be copied.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.remote_file_transfer.scp

operation: 
  name: scp_copy_file
  
  inputs: 
    - host    
    - port:
        default: '22'
        required: false  
    - username    
    - password:  
        required: false  
        sensitive: true
    - private_key:
        required: false
    - privateKey:
        default: ${get('private_key', '')}
        required: false
        private: true
    - local_file
    - localFile: 
        default: ${get('local_file', '')}  
        required: false 
        private: true 
    - copy_action    
    - copyAction: 
        default: ${get('copy_action', '')}  
        required: false 
        private: true 
    - remote_file    
    - remoteFile: 
        default: ${get('remote_file', '')}  
        required: false 
        private: true 
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
    - known_hosts_policy:
        default: 'allow'
        required: false  
    - known_hosts_path:  
        required: false
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
    gav: 'io.cloudslang.content:cs-rft:0.0.9-RC20'
    class_name: 'io.cloudslang.content.rft.actions.scp.SCPCopyFile'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - return_code: ${get('returnCode', '')} 
    - exception: ${get('exception', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
