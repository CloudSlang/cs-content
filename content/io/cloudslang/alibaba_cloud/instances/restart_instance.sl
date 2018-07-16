########################################################################################################################
#!!
#! @description: This operation is used to restart an ECS instance.
#!
#! @input region_id: Region ID of an instance. You can call DescribeRegions to obtain the latest region list.
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
#! @input instance_id: The specified instance ID.
#! @input force_stop: Whether to force shutdown upon device restart.  Value range:true: force the instance to shut down
#!                    false: the instance shuts down normallyDefault: false
#!                    Optional
#!
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output return_result: The authentication token in case of success, or an error message in case of failure.
#! @output request_id: Request ID. We return a unique RequestId for every API request, whether the request is successful
#!                     or not.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The instance has been successfully restarted.
#! @result FAILURE: An error has occurred while trying to restart the instance.
#!!#
########################################################################################################################

namespace: io.cloudslang.alibaba_cloud.instances

operation: 
  name: restart_instance
  
  inputs: 
    - region_id    
    - regionId: 
        default: ${get('region_id', '')}  
        required: false 
        private: true 
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
    - instance_id    
    - instanceId: 
        default: ${get('instance_id', '')}  
        required: false 
        private: true 
    - force_stop:  
        required: false  
    - forceStop: 
        default: ${get('force_stop', '')}  
        required: false 
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-alibaba:0.0.1-SNAPSHOT'
    class_name: 'io.cloudslang.content.alibaba.actions.instances.RestartInstance'
    method_name: 'execute'
  
  outputs: 
    - return_code: ${get('returnCode', '')} 
    - return_result: ${get('returnResult', '')} 
    - request_id: ${get('requestId', '')} 
    - exception: ${get('exception', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
