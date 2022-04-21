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
#! @description: Creates a streaming job.
#!
#! @input auth_token: The authorization token for azure.
#! @input subscription_id: GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of
#!                         the URI for every service call.
#! @input location: Resource location.
#! @input resource_group_name: The name of the resource group that contains the resource. You can obtain this value from
#!                             the Azure Resource Manager API or the portal.
#! @input job_name: The name of the streaming job.
#! @input api_version: Client Api Version.
#!                     Default: 2016-03-01
#!                     Optional
#! @input sku_name: The name of the SKU. Describes the SKU of the streaming job.
#!                  Default: Standard
#!                  Optional
#! @input events_out_of_order_policy: Indicates the policy to apply to events that arrive out of order in the input
#!                                    event stream.Valid Values: Drop,Adjust
#!                                    Default: Adjust
#!                                    Optional
#! @input output_error_policy: Indicates the policy to apply to events that arrive at the output and cannot be written
#!                             to the external storage due to being malformed (missing column values, column values of
#!                             wrong type or size).Valid Values: Drop, Stop
#!                             Default: Stop
#!                             Optional
#! @input events_out_of_order_max_delay_in_seconds: The maximum tolerable delay in seconds where out-of-order events can
#!                                                  be adjusted to be back in order.
#!                                                  Default: 0
#!                                                  Optional
#! @input events_late_arrival_max_delay_in_seconds: The maximum tolerable delay in seconds where events arriving late
#!                                                  could be included. Supported range is -1 to 1814399 (20.23:59:59
#!                                                  days) and -1 is used to specify wait indefinitely. If the property
#!                                                  is absent, it is interpreted to have a value of -1.
#!                                                  Default: 5
#!                                                  Optional
#! @input data_locale: The data locale of the stream analytics job. Value should be the name of a supported.
#!                     Default: en-US
#!                     Optional
#! @input compatibility_level: Controls certain runtime behaviors of the streaming job.
#!                             Default: 1.0
#!                             Optional
#! @input tags: Resource tags.
#!              Example: {"key1": "value1"}
#!              Optional
#! @input proxy_host: Proxy server used to access the Azure service.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Azure service.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no
#!                         trusted certification authority issued it.
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to
#!                                 "allow_all" to skip any checking. For the value "browser_compatible" the hostname
#!                                 verifier works the same way as Curl and Firefox. The hostname must match either the
#!                                 first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of
#!                                 the subject-alts. The only difference between "browser_compatible" and "strict" is
#!                                 that a wildcard (such as "*.foo.com") with "browser_compatible" matches all
#!                                 subdomains, including "a.b.foo.com".
#!                                 Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that
#!                        you expect to communicate with, or from Certificate Authorities that you trust to identify
#!                        other parties.  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is
#!                        'true' this input is ignored. Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystore
#!                        is empty, trustPassword default will be supplied.
#!                        Optional
#!
#! @output return_result: If successful, returns the complete API response. In case of an error this output will contain
#!                        the error message.
#! @output exception: An error message in case there was an error while executing the request.
#! @output status_code: The HTTP status code for Azure API request.
#! @output provisioning_state: Describes the provisioning status of the streaming job.
#! @output job_id: A GUID uniquely identifying the streaming job. This GUID is generated upon creation of the streaming
#!                 job.
#! @output job_state: Describes the state of the streaming job.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.streamanalytics.streamingjobs

operation: 
  name: create_streaming_job
  
  inputs: 
    - auth_token:    
        sensitive: true
    - authToken: 
        default: ${get('auth_token', '')}
        private: true 
        sensitive: true
    - subscription_id    
    - subscriptionId: 
        default: ${get('subscription_id', '')}
        private: true 
    - location    
    - resource_group_name
    - resourceGroupName: 
        default: ${get('resource_group_name', '')}
        private: true
    - job_name    
    - jobName: 
        default: ${get('job_name', '')}
        private: true 
    - api_version:  
        required: false  
    - apiVersion: 
        default: ${get('api_version', '')}  
        required: false 
        private: true 
    - sku_name:  
        required: false  
    - skuName: 
        default: ${get('sku_name', '')}  
        required: false 
        private: true 
    - events_out_of_order_policy:  
        required: false  
    - eventsOutOfOrderPolicy: 
        default: ${get('events_out_of_order_policy', '')}  
        required: false 
        private: true 
    - output_error_policy:  
        required: false  
    - outputErrorPolicy: 
        default: ${get('output_error_policy', '')}  
        required: false 
        private: true 
    - events_out_of_order_max_delay_in_seconds:  
        required: false  
    - eventsOutOfOrderMaxDelayInSeconds: 
        default: ${get('events_out_of_order_max_delay_in_seconds', '')}  
        required: false 
        private: true 
    - events_late_arrival_max_delay_in_seconds:  
        required: false  
    - eventsLateArrivalMaxDelayInSeconds: 
        default: ${get('events_late_arrival_max_delay_in_seconds', '')}  
        required: false 
        private: true 
    - data_locale:  
        required: false  
    - dataLocale: 
        default: ${get('data_locale', '')}  
        required: false 
        private: true 
    - compatibility_level:  
        required: false  
        sensitive: true
    - compatibilityLevel: 
        default: ${get('compatibility_level', '')}  
        required: false 
        private: true 
        sensitive: true
    - tags:  
        required: false  
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
    - trust_all_roots:  
        required: false  
    - trustAllRoots: 
        default: ${get('trust_all_roots', '')}  
        required: false 
        private: true 
    - x_509_hostname_verifier:  
        required: false  
    - x509HostnameVerifier: 
        default: ${get('x_509_hostname_verifier', '')}  
        required: false 
        private: true 
    - trust_keystore:  
        required: false  
    - trustKeystore: 
        default: ${get('trust_keystore', '')}  
        required: false 
        private: true 
    - trust_password:  
        required: false  
        sensitive: true
    - trustPassword: 
        default: ${get('trust_password', '')}  
        required: false 
        private: true 
        sensitive: true
    
  java_action: 
    gav: 'io.cloudslang.content:cs-azure:0.0.17'
    class_name: 'io.cloudslang.content.azure.actions.streamanalytics.streamingjobs.CreateStreamingJob'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - exception: ${get('exception', '')} 
    - status_code: ${get('statusCode', '')} 
    - provisioning_state: ${get('provisioningState', '')} 
    - job_id: ${get('jobId', '')} 
    - job_state: ${get('jobState', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
