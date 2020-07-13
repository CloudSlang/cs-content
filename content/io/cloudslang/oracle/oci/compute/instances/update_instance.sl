#   (c) Copyright 2020 Micro Focus, L.P.
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
#! @description: Updates certain fields on the specified instance. Fields that are not provided in the request will not
#!               be updated.
#!
#! @input tenancy_ocid: Oracle creates a tenancy for your company, which is a secure and isolated partition where you
#!                      can create, organize, and administer your cloud resources. This is ID of the tenancy.
#! @input user_ocid: ID of an individual employee or system that needs to manage or use your company’s Oracle Cloud
#!                   Infrastructure resources.
#! @input finger_print: Finger print of the public key generated for OCI account.
#! @input private_key_data: A string representing the private key for the OCI. This string is usually the content of a
#!                          private key file.
#!                          Optional
#! @input private_key_file: The path to the private key file on the machine where is the worker. 
#!                          Optional
#! @input api_version: Version of the API of OCI.
#!                     Default: '20160918'
#!                     Optional
#! @input region: The region's name.
#! @input instance_id: The OCID of the instance.
#! @input shape: The shape of an instance. The shape determines the number of CPUs, amount of memory, and other
#!               resources allocated to the instance.
#!               Optional
#! @input display_name: A user-friendly name. Does not have to be unique, and it's changeableEx: My bare metal instance
#!                      Optional
#! @input defined_tags: Defined tags for this resource. Each key is predefined and scoped to a namespace.Ex:
#!                      {"Operations": {"CostCenter": "42"}}
#!                      Optional
#! @input freeform_tags: Free-form tags for this resource. Each tag is a simple key-value pair with no predefined name,
#!                       type, or namespace.Ex: {"Department": "Finance"}
#!                       Optional
#! @input ocpus: The total number of OCPUs available to the instance.
#!               Optional
#! @input is_management_disabled: Whether the agent running on the instance can run all the available management
#!                                plugins.
#!                                Default: 'false'
#!                                Optional
#! @input is_monitoring_disabled: Whether the agent running on the instance can gather performance metrics and monitor
#!                                the instance.required
#!                                Default: 'false'
#!                                Optional
#! @input proxy_host: Proxy server used to access the OCI.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the OCI.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.
#!                         Default: '10000'
#!                         Optional
#! @input socket_timeout: The timeout for waiting for data (a maximum period inactivity between two consecutive data
#!                        packets), in seconds. A socketTimeout value of '0' represents an infinite timeout.
#!                        Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls. If
#!                    keepAlive is false, the already open connection will be used and after execution it will close
#!                    it.
#!                    Default: 'true'
#!                    Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.
#!                                   Default: '2'
#!                                   Optional
#! @input connections_max_total: The maximum limit of connections in total.
#!                               Default: '20'
#!                               Optional
#!
#! @output return_result: If successful, returns the complete API response. In case of an error this output will contain
#!                        the error message.
#! @output exception: An error message in case there was an error while executing the request.
#! @output instance_name: The instance name.
#! @output status_code: The HTTP status code for OCI API request.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.oracle.oci.compute.instances

operation: 
  name: update_instance
  
  inputs: 
    - tenancy_ocid    
    - tenancyOcid: 
        default: ${get('tenancy_ocid', '')}  
        required: false 
        private: true 
    - user_ocid    
    - userOcid: 
        default: ${get('user_ocid', '')}  
        required: false 
        private: true 
    - finger_print:    
        sensitive: true
    - fingerPrint: 
        default: ${get('finger_print', '')}  
        required: false 
        private: true 
        sensitive: true
    - private_key_data:  
        required: false  
        sensitive: true
    - privateKeyData: 
        default: ${get('private_key_data', '')}  
        required: false 
        private: true 
        sensitive: true
    - private_key_file:  
        required: false  
    - privateKeyFile: 
        default: ${get('private_key_file', '')}  
        required: false 
        private: true
    - api_version:  
        required: false  
    - apiVersion: 
        default: ${get('api_version', '')}  
        required: false 
        private: true 
    - region    
    - instance_id    
    - instanceId: 
        default: ${get('instance_id', '')}  
        required: false 
        private: true 
    - shape:  
        required: false  
    - display_name:  
        required: false  
    - displayName: 
        default: ${get('display_name', '')}  
        required: false 
        private: true 
    - defined_tags:  
        required: false  
    - definedTags: 
        default: ${get('defined_tags', '')}  
        required: false 
        private: true 
    - freeform_tags:  
        required: false  
    - freeformTags: 
        default: ${get('freeform_tags', '')}  
        required: false 
        private: true 
    - ocpus:  
        required: false  
    - is_management_disabled:  
        required: false  
    - isManagementDisabled: 
        default: ${get('is_management_disabled', '')}  
        required: false 
        private: true 
    - is_monitoring_disabled:  
        required: false  
    - isMonitoringDisabled: 
        default: ${get('is_monitoring_disabled', '')}  
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
    - connect_timeout:  
        required: false  
    - connectTimeout: 
        default: ${get('connect_timeout', '')}  
        required: false 
        private: true 
    - socket_timeout:  
        required: false  
    - socketTimeout: 
        default: ${get('socket_timeout', '')}  
        required: false 
        private: true 
    - keep_alive:  
        required: false  
    - keepAlive: 
        default: ${get('keep_alive', '')}  
        required: false 
        private: true 
    - connections_max_per_route:  
        required: false  
    - connectionsMaxPerRoute: 
        default: ${get('connections_max_per_route', '')}  
        required: false 
        private: true 
    - connections_max_total:  
        required: false  
    - connectionsMaxTotal: 
        default: ${get('connections_max_total', '')}  
        required: false 
        private: true 

  java_action: 
    gav: 'io.cloudslang.content:cs-oracle-cloud:1.0.0-RC18'
    class_name: 'io.cloudslang.content.oracle.oci.actions.instances.UpdateInstance'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - exception: ${get('exception', '')} 
    - instance_name: ${get('instance_name', '')} 
    - status_code: ${get('statusCode', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
