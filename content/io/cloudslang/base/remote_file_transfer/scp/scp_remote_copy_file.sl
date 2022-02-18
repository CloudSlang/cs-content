#   (c) Copyright 2022 Micro Focus, L.P.
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
#! @description: Copies files between two remote machines through secure SSH.
#!
#! @input source_host: The host of the source file.
#! @input source_port: The port used for connecting to the source host.
#!                     Default value: 22
#!                     Optional
#! @input source_username: The username for connecting to the host of the source file.
#! @input source_password: The password for connecting to the host of the source file. If using a private key file this
#!                         will be used as the passphrase for the file.
#! @input source_private_key: Absolute path of the private key file for public/private key authentication on the source
#!                            host.
#!                            Optional
#! @input source_path: The absolute path to the source file.
#! @input destination_host: The host of the destination file.
#! @input destination_port: The port used for connecting to the destination host.
#!                          Default value: 22
#!                          Optional
#! @input destination_username: The username for connecting to the host of the destination file.
#! @input destination_password: The password for connecting to the host of the destination file. If using a private key
#!                              file this will be used as the passphrase for the file.
#!                              Optional
#! @input destination_private_key: Absolute path of the private key file for public/private key authentication on the
#!                                 destination host.
#!                                 Optional
#! @input destination_path: The absolute path to the destination file.
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
#!                            Default value: 'allow'
#!                            Optional
#! @input known_hosts_path: Path to the known_hosts file.
#!                          Optional
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
  name: scp_remote_copy_file
  
  inputs: 
    - source_host    
    - sourceHost: 
        default: ${get('source_host', '')}  
        required: false 
        private: true 
    - source_port:
        default: '22'
        required: false  
    - sourcePort: 
        default: ${get('source_port', '')}  
        required: false 
        private: true 
    - source_username    
    - sourceUsername: 
        default: ${get('source_username', '')}  
        required: false 
        private: true 
    - source_password:  
        required: false  
        sensitive: true
    - sourcePassword: 
        default: ${get('source_password', '')}  
        required: false 
        private: true 
        sensitive: true
    - source_private_key:  
        required: false  
    - sourcePrivateKey: 
        default: ${get('source_private_key', '')}  
        required: false 
        private: true 
    - source_path    
    - sourcePath: 
        default: ${get('source_path', '')}  
        required: false 
        private: true 
    - destination_host    
    - destinationHost: 
        default: ${get('destination_host', '')}  
        required: false 
        private: true 
    - destination_port:
        default: '22'
        required: false  
    - destinationPort: 
        default: ${get('destination_port', '')}  
        required: false 
        private: true 
    - destination_username    
    - destinationUsername: 
        default: ${get('destination_username', '')}  
        required: false 
        private: true 
    - destination_password:  
        required: false  
        sensitive: true
    - destinationPassword: 
        default: ${get('destination_password', '')}  
        required: false 
        private: true 
        sensitive: true
    - destination_private_key:  
        required: false  
    - destinationPrivateKey: 
        default: ${get('destination_private_key', '')}  
        required: false 
        private: true 
    - destination_path    
    - destinationPath: 
        default: ${get('destination_path', '')}  
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
    gav: 'io.cloudslang.content:cs-rft:1.0.0'
    class_name: 'io.cloudslang.content.rft.actions.scp.SCPRemoteCopyFile'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - return_code: ${get('returnCode', '')} 
    - exception: ${get('exception', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
