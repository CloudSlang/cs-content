#   Copyright 2024 Open Text
#   This program and the accompanying materials
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
#! @description: Creates a Input for streaming job.
#!
#! @input job_name: The name of the streaming job.
#! @input auth_token: The authorization token for azure.
#! @input stream_job_input_name: The name of the input.
#! @input resource_group_name: The name of the resource group that contains the resource. You can obtain this value from
#!                             the Azure Resource Manager API or the portal.
#! @input subscription_id: GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of
#!                         the URI for every service call.
#! @input account_name: Provide the existing storage account name
#! @input account_key: Access keys to authenticate your applications when making requests to this Azure storage account.
#! @input container_name_stream_input: creates a new container under the specified account if not exists.
#! @input api_version: Client Api Version.
#!                     Default: 2016-03-01
#!                     Optional
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
#! @output input_name: The name of the input.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.streamanalytics.inputs

operation: 
  name: create_streaming_job_input
  
  inputs: 
    - job_name    
    - jobName: 
        default: ${get('job_name', '')}
        private: true 
    - auth_token:    
        sensitive: true
    - authToken: 
        default: ${get('auth_token', '')}
        private: true 
        sensitive: true
    - stream_job_input_name    
    - streamJobInputName: 
        default: ${get('stream_job_input_name', '')}
        private: true 
    - resource_group_name    
    - resourceGroupName: 
        default: ${get('resource_group_name', '')}
        private: true 
    - subscription_id    
    - subscriptionId: 
        default: ${get('subscription_id', '')}
        private: true 
    - account_name    
    - accountName: 
        default: ${get('account_name', '')}
        private: true 
    - account_key    
    - accountKey: 
        default: ${get('account_key', '')}
        private: true
    - container_name_stream_input
    - containerNameStreamInput:
        default: ${get('container_name_stream_input', '')}
        private: true
    - api_version:  
        required: false  
    - apiVersion: 
        default: ${get('api_version', '')}  
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
    gav: 'io.cloudslang.content:cs-azure:0.0.27'
    class_name: 'io.cloudslang.content.azure.actions.streamanalytics.inputs.CreateStreamingJobInput'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - exception: ${get('exception', '')} 
    - status_code: ${get('statusCode', '')} 
    - input_name: ${get('streamJobInputName', '')}
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
