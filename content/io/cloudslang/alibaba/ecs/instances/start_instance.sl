#   (c) Copyright 2022 Micro Focus, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: This operation is used to start a specified instance.
#!
#! @input access_key_id: The Access Key ID associated with your Alibaba cloud account.
#! @input access_key_secret: The Secret ID of the Access Key associated with your Alibaba cloud account.
#! @input proxy_host: Proxy server used to access the Alibaba cloud services.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Alibaba cloud services.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input region_id: Region ID of an instance. You can call DescribeRegions to obtain the latest region list.
#! @input instance_id: The specified instance ID of ECS instance.
#! @input init_local_disk: Recover to the previous normal status of instance local disk when exceptions occurs.
#!                         Valid values: 'true', 'false'
#!                         Optional
#!
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output return_result: The authentication token in case of success, or an error message in case of failure.
#! @output request_id: Request ID. We return a unique RequestId for every API request, whether the request is successful
#!                     or not.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The instance has been successfully started.
#! @result FAILURE: An error has occurred while trying to start the instance.
#!!#
########################################################################################################################

namespace: io.cloudslang.alibaba.ecs.instances

operation: 
  name: start_instance
  
  inputs: 
    - access_key_id    
    - accessKeyId: 
        default: ${get('access_key_id', '')}  
        required: false 
        private: true 
    - access_key_secret:    
        sensitive: true
    - accessKeySecret: 
        default: ${get('access_key_secret', '')}  
        required: false 
        private: true 
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
    - region_id    
    - regionId: 
        default: ${get('region_id', '')}  
        required: false 
        private: true 
    - instance_id    
    - instanceId: 
        default: ${get('instance_id', '')}  
        required: false 
        private: true 
    - init_local_disk:  
        required: false  
    - initLocalDisk: 
        default: ${get('init_local_disk', '')}  
        required: false 
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-alibaba:0.0.2'
    class_name: 'io.cloudslang.content.alibaba.actions.instances.StartInstance'
    method_name: 'execute'
  
  outputs: 
    - return_code: ${get('returnCode', '')} 
    - return_result: ${get('returnResult', '')} 
    - request_id: ${get('requestId', '')} 
    - exception: ${get('exception', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
