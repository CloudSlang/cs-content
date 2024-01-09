#   Copyright 2023 Open Text
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
#! @description: Gets information about the specified provisioned product.
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
#! @input accepted_language: The language code.
#!                           Example: en (English), jp (Japanese), zh(Chinese)
#!                           Default: 'en'
#!                           Optional
#! @input product_id: The provisioned product identifier.
#!                    Required
#!
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output return_result: The full API response in case of success, or an error message in case of failure.
#!                        The data is returned in JSON format by the service in the first case.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#! @output provisioned_product_arn: The ARN of the provisioned product.
#!                                  Pattern: '[a-zA-Z0-9][a-zA-Z0-9._-]{0,127}|arn:[a-z0-9-\.]{1,63}:
#!                                  [a-z0-9-\.]{0,63}:[a-z0-9-\.]{0,63}:[a-z0-9-\.]{0,63}:[^/].{0,1023}'
#! @output provisioned_product_created_time: The UTC time stamp of the creation time.
#! @output provisioned_product_id: The identifier of the provisioned product.
#!                                 Example: 'pp-almi4aq6ylmoa'
#! @output provisioned_product_status: The current status of the provisioned product.
#!                                     Valid: 'AVAILABLE' - Stable state, ready to perform any operation.
#!                                                          The most recent operation succeeded and completed.
#!                                            'UNDER_CHANGE' - Transitive state, operations performed might not have
#!                                                             valid results. Wait for an AVAILABLE status before
#!                                                             performing operations.
#!                                            'TAINTED' - Stable state, ready to perform any operation. The stack has
#!                                                        completed the requested operation but is not exactly what was
#!                                                        requested. For example, a request to update to a new version
#!                                                        failed and the stack rolled back to the current version.
#!                                            'ERROR' - An unexpected error occurred, the provisioned product exists but
#!                                                      the stack is not running. For example, CloudFormation received a
#!                                                      parameter value that was not valid and could not launch the stack.
#!                                            'PLAN_IN_PROGRESS'
#! @output provisioned_product_name_result: The user-friendly name of the provisioned product.
#! @output provisioned_product_type: The type of provisioned product. The supported value is CFN_STACK. 
#!
#! @result SUCCESS: The action ended successfully.
#! @result FAILURE: An error has occurred while trying to get details about the product.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.servicecatalog.products

operation: 
  name: describe_provisioned_product
  
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
    - accepted_language:
        default: 'en'
        required: false  
    - acceptedLanguage: 
        default: ${get('accepted_language', '')}  
        required: false 
        private: true 
    - product_id:
        required: true
    - productId: 
        default: ${get('product_id', '')}  
        required: true
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-amazon:1.0.53-SNAPSHOT-300'
    class_name: 'io.cloudslang.content.amazon.actions.servicecatalog.DescribeProvisionedProductAction'
    method_name: 'execute'
  
  outputs: 
    - return_code: ${get('returnCode', '')} 
    - return_result: ${get('returnResult', '')} 
    - exception: ${get('exception', '')} 
    - provisioned_product_arn: ${get('provisionedProductArn', '')} 
    - provisioned_product_created_time: ${get('provisionedProductCreatedTime', '')} 
    - provisioned_product_id: ${get('provisionedProductId', '')} 
    - provisioned_product_status: ${get('provisionedProductStatus', '')} 
    - provisioned_product_name_result: ${get('provisionedProductNameResult', '')} 
    - provisioned_product_type: ${get('provisionedProductType', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
