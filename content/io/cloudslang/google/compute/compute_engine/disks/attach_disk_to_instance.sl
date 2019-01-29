#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: This operation creates a disk resource in the specified project using the data included as inputs.
#!
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input zone: The name of the zone in which the instance lives.
#!              Examples: 'us-central1-a', 'us-central1-b', 'us-central1-c'
#! @input access_token: The access token from get_access_token.
#! @input instance_name: The name that the new instance will have.
#!                       Example: 'instance-1234'
#! @input source: A valid partial or full URL to an existing Persistent Disk resource.
#! @input mode: The mode in which to attach the disk to the instance.
#!              Valid: 'READ_WRITE', 'READ_ONLY'
#!              Default: 'READ_WRITE'
#!              Optional
#! @input auto_delete: Whether to delete the disk when the instance is deleted.
#!                    Default: 'false'
#!                    Optional
#! @input device_name: Specifies a unique device name of your choice that is reflected into the
#!                     /dev/disk/by-id/google-* tree of a Linux operating system running within the instance.
#!                     This name can be used to reference the device for mounting, resizing, and so on, from
#!                     within the instance.
#!                     Note: If not specified, the server chooses a default device name to apply to this disk,
#!                     in the form persistent-disks-x, where x is a number assigned by Google Compute Engine.
#!                     This field is only applicable for persistent disks.
#!                     Optional
#! @input async: Boolean specifying whether the operation to run sync or async.
#!               Valid: 'true', 'false'
#!               Default: 'true'
#!               Optional
#! @input timeout: The time, in seconds, to wait for a response if the async input is set to "false".
#!                 If the value is 0, the operation will wait until zone operation progress is 100.
#!                 Valid: Any positive number including 0.
#!                 Default: '30'
#!                 Optional
#! @input polling_interval: The time, in seconds, to wait before a new request that verifies if the operation finished
#!                          is executed, if the async input is set to "false".
#!                          Valid values: Any positive number including 0.
#!                          Default: '1'
#!                          Optional
#! @input proxy_host: Proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input pretty_print: Whether to format the resulting JSON.
#!                      Valid: 'true', 'false'
#!                      Default: 'true'
#!                      Optional
#!
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#! @output return_result: Contains the ZoneOperation resource, as a JSON object.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#! @output zone_operation_name: Contains the ZoneOperation name, if the returnCode is '0', otherwise it is empty.
#! @output instance_name_out: The name of the instance.
#! @output instance_details: Details of the instance.
#! @output disks: The disks attached to the instance.
#! @output status: The status of the operation if async is true, otherwise the status of the instance.
#! @output device_name_out: The name of the attached instance.
#!
#! @result SUCCESS: The request to attach the Disk to an Instance was successfully sent.
#! @result FAILURE: An error occurred while trying to send the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.google.compute.compute_engine.disks

operation: 
  name: attach_disk_to_instance
  
  inputs: 
    - access_token:    
        sensitive: true
    - accessToken: 
        default: ${get('access_token', '')}  
        required: false 
        private: true 
        sensitive: true
    - project_id    
    - projectId: 
        default: ${get('project_id', '')}  
        required: false 
        private: true 
    - zone    
    - instance_name    
    - instanceName: 
        default: ${get('instance_name', '')}  
        required: false 
        private: true 
    - source    
    - mode:
        default: 'READ_WRITE'
        required: false  
    - auto_delete:
        default: 'false'
        required: false  
    - autoDelete: 
        default: ${get('auto_delete', '')}  
        required: false 
        private: true 
    - device_name:  
        required: false  
    - deviceName: 
        default: ${get('device_name', '')}  
        required: false 
        private: true
    - async:
        default: 'true'
        required: false
    - timeout:
        default: '30'
        required: false
    - polling_interval:
        default: '1'
        required: false
    - pollingInterval:
        default: ${get('polling_interval', '')}
        required: false
        private: true
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
    - pretty_print:
        default: 'true'
        required: false  
    - prettyPrint: 
        default: ${get('pretty_print', '')}  
        required: false 
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-google:0.4.2'
    class_name: io.cloudslang.content.google.actions.compute.compute_engine.disks.AttachDisk
    method_name: execute
  
  outputs: 
    - return_code: ${returnCode}
    - return_result: ${returnResult}
    - exception: ${get('exception', '')}
    - zone_operation_name: ${zoneOperationName}
    - instance_name_out: ${get('instanceName', '')}
    - instance_details: ${get('instanceDetails', '')}
    - disks
    - status
    - device_name_out: ${get('deviceName', '')}
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
