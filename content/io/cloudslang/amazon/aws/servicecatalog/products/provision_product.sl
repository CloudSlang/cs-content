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
#! @description: Provisions the specified product. A provisioned product is a resourced instance of a product.
#!               For example, provisioning a product based on a CloudFormation template launches a
#!               CloudFormation stack and its underlying resources.
#!
#! @input identity: ID of the secret access key associated with your Amazon AWS or IAM account.
#!                   Example:'AKIAIOSFODNN7EXAMPLE'
#! @input credential: Secret access key associated with your Amazon AWS or IAM account.
#!                    Example:'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
#! @input proxy_host: Proxy server used to connect to Amazon API. If empty no proxy will be used.
#!                    Optional
#! @input proxy_port: Proxy server port. You must either specify values for both proxyHost and proxyPort inputs or leave
#!                    them both empty.
#!                    Optional
#!                    Default: '8080'
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxyUsername input value.Default: ''
#!                        Optional
#! @input connect_timeout: The amount of time to wait (in milliseconds) when initially establishing a connection before
#!                         giving up and timing out.
#!                         Default: '10000'
#!                         Optional
#! @input execution_timeout: The amount of time (in milliseconds) to allow the client to complete the execution
#!                           of an API call. A value of '0' disables this feature.
#!                           Default: '60000'
#!                           Optional
#! @input polling_interval: The time, in seconds, to wait before a new request that verifies if the operation finished
#!                          is executed.
#!                          Optional
#!                          Default: '1000'
#! @input async: Whether to run the operation is async mode.
#!               Optional
#!               Default: 'false'
#! @input product_id: The product identifier.
#!                    Example: 'prod-n3frsv3vnznzo'
#! @input provisioned_product_name: A user-friendly name for the provisioned product. This value must be unique for the
#!                                  AWS account and cannot be updated after the product is provisioned.
#! @input provisioning_artifact_id: The identifier of the provisioning artifact also known as version Id.
#!                                   Example:'pa-o5nvsxzzyuzjk'
#! @input provisioning_parameters: Template parameters in key value format, one key=value, delimited by the value from
#!                                 delimiter input.
#!                                 Optional
#!                                 Example: 'KeyName=myKey,InstanceType=m1.small'
#! @input delimiter: The delimiter used to separate the values from provisioningParameters and tags inputs.
#!                   Optional
#!                   Default: ','
#! @input tags: One or more tags in key=value format, one key=value, delimited by the value from delimiter input.
#!              Optional
#! @input provision_token: An idempotency token that uniquely identifies the provisioning request.
#!                         Optional
#! @input accept_language: String that contains the language code.
#!                         Example: en (English), jp (Japanese), zh(Chinese)
#!                         Default: 'en'
#!                         Optional
#! @input notification_arns: Strings that are passed to CloudFormation.The Simple Notification Service topic Amazon
#!                           Resource Names to which to publish stack-related events.
#!                           Optional
#! @input path_id: String that contains the identifier path of the product. This value is optional if the product has a
#!                 default path, and required if the product has more than one path.
#!                 Optional
#! @input region: String that contains the Amazon AWS region name.
#!                Optional
#!
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output return_result: The full API response in case of success, or an error message in case of failure.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#! @output created_time: The UTC time stamp of the creation time.
#! @output path_id_output: String that contains the identifier path of the product.This value is optional if the product
#!                         has a default path, and required if the product has more than one path.
#! @output product_id_output: The product identifier.Example: 'prod-n3frsv3vnznzo'
#! @output provisioned_product_id: The identifier of the provisioned product.
#! @output provisioned_product_name_output: A user-friendly name for the provisioned product.This value must be unique
#!                                          for the AWS account and cannot be updated after the product is provisioned.
#! @output provisioned_product_type: The type of provisioned product. The supported value is 'CFN_STACK'.
#! @output provisioned_artifact_id: The identifier of the provisioned artifact.
#! @output status: The status of the provisioned product.
#!                 Valid values: 'CREATED' - The request was created but the operation has not started.
#!                               'IN_PROGRESS' - The requested operation is in progress.
#!                               'IN_PROGRESS_IN_ERROR' - The provisioned product is under change but the requested
#!                                                        operation failed and some remediation is occurring.
#!                                                        For example, a rollback.
#!                               'SUCCEEDED' - The requested operation has successfully completed.
#!                               'FAILED' - The requested operation has unsuccessfully completed.
#! @output stack_id: The unique stack ID that is associated with the stack.
#! @output stack_name: The name that is associated with the stack. The name must be unique in the region in which you
#!                     are creating the stack.A stack name can contain only alphanumeric characters (case sensitive) and
#!                     hyphens. It must start with an alphabetic character and cannot be longer than 128 characters.
#! @output stack_outputs: The optional Outputs section declares output values that you can import into other stacks (to
#!                        create cross-stack references), return in response (to describe stack calls), or view on the
#!                        AWS CloudFormation console. The Outputs section can include the following fields: Logical ID -
#!                        An identifier for the current output. The logical ID must be alphanumeric (a-z, A-Z, 0-9) and
#!                        unique within the template.Description(optional) - A String type that describes the output
#!                        valueValue (required) - The value of the property returned by the aws cloudformation
#!                        describe-stacks command. The value of an output can include literals, parameter references,
#!                        pseudo-parameters, a mapping value, or intrinsic functions.Export (optional) - The name of the
#!                        resource output to be exported for a cross-stack reference.
#! @output stack_resources: The key name of the AWS Resources that you want to include in the stack, such as an Amazon
#!                          EC2 instance or an Amazon S3 bucket.The Resources section can include the following fields:
#!                          Logical ID - The logical ID must be alphanumeric (A-Za-z0-9) and unique within the
#!                          template.Resource type - The resource type identifies the type of resource that you are
#!                          declaring.Resource properties - Resource properties are additional options that you can
#!                          specify for a resource.
#!
#! @result SUCCESS: The product was successfully provisioned.
#! @result FAILURE: An error has occurred while trying to provision the product.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.servicecatalog.products

operation: 
  name: provision_product
  
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
    - polling_interval:
        default: '1000'
        required: false
    - pollingInterval:
        default: ${get('polling_interval', '')}
        required: false
        private: true
    - async:
        default: 'false'
        required: false  
    - product_id    
    - productId: 
        default: ${get('product_id', '')}  
        required: false 
        private: true 
    - provisioned_product_name    
    - provisionedProductName: 
        default: ${get('provisioned_product_name', '')}  
        required: false 
        private: true 
    - provisioning_artifact_id    
    - provisioningArtifactId: 
        default: ${get('provisioning_artifact_id', '')}  
        required: false 
        private: true 
    - provisioning_parameters:
        required: false
    - provisioningParameters:
        default: ${get('provisioning_parameters', '')}
        required: false
        private: true
    - delimiter:
        default: ','
        required: false
    - tags:  
        required: false  
    - provision_token:  
        required: false  
    - provisionToken: 
        default: ${get('provision_token', '')}  
        required: false 
        private: true 
    - accept_language:
        default: 'en'
        required: false  
    - acceptLanguage: 
        default: ${get('accept_language', '')}  
        required: false 
        private: true 
    - notification_arns:  
        required: false  
    - notificationArns: 
        default: ${get('notification_arns', '')}  
        required: false 
        private: true 
    - path_id:  
        required: false  
    - pathId: 
        default: ${get('path_id', '')}  
        required: false 
        private: true 
    - region:
        default: 'us-east-1'
        required: false  
    
  java_action: 
    gav: 'io.cloudslang.content:cs-amazon:1.0.41-RC2'
    class_name: 'io.cloudslang.content.amazon.actions.servicecatalog.ProvisionProductAction'
    method_name: 'execute'
  
  outputs: 
    - return_code: ${get('returnCode', '')} 
    - return_result: ${get('returnResult', '')} 
    - exception: ${get('exception', '')} 
    - created_time: ${get('createdTime', '')} 
    - path_id_output: ${get('pathId', '')} 
    - product_id_output: ${get('productIdResult', '')}
    - provisioned_product_id: ${get('provisionedProductId', '')} 
    - provisioned_product_name_output: ${get('provisionedProductNameResult', '')}
    - provisioned_product_type: ${get('provisionedProductType', '')} 
    - provisioned_artifact_id: ${get('provisionedArtifactId', '')} 
    - status: ${get('status', '')} 
    - stack_id: ${get('stackId', '')} 
    - stack_name: ${get('stackName', '')} 
    - stack_outputs: ${get('stackOutputs', '')} 
    - stack_resources: ${get('stackResources', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
