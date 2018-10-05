#   (c) Copyright 2018 Micro Focus, L.P.
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
#! @description: Terminates the specified provisioned product.
#!
#! @input identity: ID of the secret access key associated with your Amazon AWS or IAM account.
#!                  Example: 'AKIAIOSFODNN7EXAMPLE'
#! @input credential: Secret access key associated with your Amazon AWS or IAM account.
#!                    Example: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
#! @input proxy_host: Proxy server used to connect to Amazon API. If empty no proxy will be used.
#!                    Optional
#! @input proxy_port: Proxy server port. You must either specify values for both proxyHost and proxyPort inputs or leave
#!                    them both empty.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxyUsername input value.
#!                        Optional
#! @input connect_timeout: The amount of time to wait (in milliseconds) when initially establishing a connection before
#!                         giving up and timing out.
#!                         Default: '10000'
#!                         Optional
#! @input execution_timeout: The amount of time (in milliseconds) to allow the client to complete the execution of an
#!                           API call. A value of '0' disables this feature.
#!                           Default: '60000'
#!                           Optional
#! @input async: Whether to run the operation is async mode.
#!               Default: 'false'
#!               Optional
#! @input region: String that contains the Amazon AWS region name.
#!                Default: 'us-east-1'
#!                Optional
#! @input provisioned_product_id: The identifier of the provisioned product. You cannot specify both
#!                                provisioned_product_name and provisioned_product_id.
#!                                Example: 'pp-almi4aq6ylmoa'
#!                                Optional
#! @input provisioned_product_name: A user-friendly name for the provisioned product.This value must be unique for the
#!                                  AWS account and cannot be updated after the product is provisioned. You cannot
#!                                  specify both provisioned_product_name and provisioned_product_id.
#!                                  Optional
#! @input accept_language: String that contains the language code.Example: en (English), jp (Japanese), zh(Chinese).
#!                         Default: 'en'
#!                         Optional
#! @input ignore_errors: If set to true, AWS Service Catalog stops managing the specified provisioned product even if it
#!                       cannot delete the underlying resources.
#!                       Default: 'false'
#!                       Optional
#! @input terminate_token: An idempotency token that uniquely identifies the termination request. This token is only
#!                         valid during the termination process. After the provisioned product is terminated, subsequent
#!                         requests to terminate the same provisioned product always return ResourceNotFound.
#!                         Pattern: [a-zA-Z0-9][a-zA-Z0-9_-]*
#!
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output return_result: The full API response in case of success, or an error message in case of failure.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The product was successfully unprovisioned.
#! @result FAILURE: An error has occurred while trying to unprovision the product.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.servicecatalog.products

operation: 
  name: unprovision_product
  inputs: 
    - identity    
    - credential:    
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
        default: '8080'
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
        default: '10000'
        required: false  
    - connectTimeout: 
        default: ${get('connect_timeout', '')}  
        required: false 
        private: true 
    - execution_timeout:
        default: '600000'
        required: false  
    - executionTimeout: 
        default: ${get('execution_timeout', '')}  
        required: false 
        private: true 
    - async:
        default: 'false'
        required: false  
    - region:
        default: 'us-east-1'
        required: false  
    - provisioned_product_id:  
        required: false  
    - provisionedProductId: 
        default: ${get('provisioned_product_id', '')}  
        required: false 
        private: true 
    - provisioned_product_name:  
        required: false  
    - provisionedProductName: 
        default: ${get('provisioned_product_name', '')}  
        required: false 
        private: true 
    - accept_language:
        default: 'en'
        required: false  
    - acceptLanguage: 
        default: ${get('accept_language', '')}  
        required: false 
        private: true 
    - ignore_errors:
        default: 'false'
        required: false  
    - ignoreErrors: 
        default: ${get('ignore_errors', '')}  
        required: false 
        private: true 
    - terminate_token    
    - terminateToken: 
        default: ${get('terminate_token', '')}  
        required: false
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-amazon:1.0.23'
    class_name: 'io.cloudslang.content.amazon.actions.servicecatalog.UnprovisionProductAction'
    method_name: 'execute'
  
  outputs: 
    - return_code: ${get('returnCode', '')} 
    - return_result: ${get('returnResult', '')} 
    - exception: ${get('exception', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
