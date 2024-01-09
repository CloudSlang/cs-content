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
#! @description: Requests updates to the configuration of the specified provisioned product.
#!
#! @input identity: ID of the secret access key associated with your Amazon AWS or IAM account.
#!                  Example: 'AKIAIOSFODNN7EXAMPLE'
#! @input credential: Secret access key associated with your Amazon AWS or IAM account.
#!                    Example: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
#! @input proxy_host: Proxy server used to connect to Amazon API. If empty no proxy will be used.
#!                    Optional
#! @input proxy_port: Proxy server port. You must either specify values for both proxy_host and proxy_port inputs or leave
#!                    them both empty.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input connect_timeout: The amount of time to wait (in milliseconds) when initially establishing a connection before
#!                         giving up and timing out.
#!                         Default: '10000'
#!                         Optional
#! @input execution_timeout: The amount of time (in milliseconds) to allow the client to complete the execution of an
#!                           API call. A value of '0' disables this feature.
#!                           Default: '60000'
#!                           Optional
#! @input polling_interval: The time, in seconds, to wait before a new request that verifies if the operation finished
#!                          is executed.
#!                          Optional
#!                          Default: '1000'
#! @input async: Whether to run the operation is async mode.
#!               Default: 'false'
#!               Optional
#! @input region: String that contains the Amazon AWS region name.
#!                Optional
#! @input accepted_language: The language code.
#!                           Example: en (English), jp (Japanese), zh(Chinese)
#!                           Default: 'en'
#!                           Optional
#! @input path_id: The new path identifier. This value is optional if the product has a default path, and required if
#!                 the product has more than one path.
#!                 Optional
#! @input product_id: The product identifier.
#!                    Example: 'prod-n3frsv3vnznzo'
#!                    Optional
#! @input provisioned_product_id: The identifier of the provisioned product. You cannot specify both
#!                                provisioned_product_name and provisioned_product_id.
#!                                Optional
#! @input provisioned_product_name: The updated name of the provisioned product. You cannot specify both
#!                                  provisioned_product_name and provisioned_product_id.
#!                                  Optional
#! @input provisioning_artifact_id: The identifier of the provisioning artifact.
#!                                  Example:'pa-o5nvsxzzyuzjk'
#!                                  Optional
#! @input provisioning_parameters: The new parameters.
#!                                 Example: 'KeyName=myKey,InstanceType=m1.small'
#!                                 Optional
#! @input use_previous_value: If set to true, the new parameters are ignored and the previous parameter value is kept.
#!                            Default: 'false'
#!                            Optional
#! @input delimiter: The delimiter used to separate the values from provisioning_parameters input.
#!                   Default: ','
#!                   Optional
#! @input update_token: The idempotency token that uniquely identifies the provisioning update request.
#!
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output return_result: The full API response in case of success, or an error message in case of failure.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#! @output created_time: The UTC time stamp of the creation time.
#! @output path_id_output: The new path identifier. This value is optional if the product has a default path, and
#!                         required if the product has more than one path.
#! @output product_id_result: The product identifier.
#!                            Example: 'prod-n3frsv3vnznzo'
#! @output provisioned_product_id_output: The identifier of the provisioned product.
#! @output provisioned_product_name_result: The updated name of the provisioned product.
#! @output provisioned_product_type: The type of provisioned product. The supported value is 'CFN_STACK'.
#! @output provisioning_artifact_id_output: The identifier of the provisioning artifact.
#! @output update_time: The time when the record was last updated.
#! @output record_id: The identifier of the record.
#! @output record_type: The record type.
#!                      PROVISION_PRODUCT
#!                      UPDATE_PROVISIONED_PRODUCT
#!                      TERMINATE_PROVISIONED_PRODUCT
#! @output record_errors: The errors that occurred.
#! @output record_tags: One or more tags.
#! @output status: The status of the provisioned product.Valid values:
#!                 'CREATED' - The request was created but the operation has not started.
#!                 'IN_PROGRESS' - The requested operation is in progress.
#!                 'IN_PROGRESS_IN_ERROR' - The provisioned product is under change but the requested operation failed
#!                 and some remediation is occurring. For example, a rollback.
#!                 'SUCCEEDED' - The requested operation has successfully completed.
#!                 'FAILED' - The requested operation has unsuccessfully completed. Investigate using the error messages
#!                 returned.
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
#! @result SUCCESS: The specified product was successfully update.
#! @result FAILURE: An error has occured while trying to update the specified product.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.servicecatalog.products

operation: 
  name: update_provisioned_product
  
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
    - execution_timeout:  
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
        required: false  
    - region:  
        required: false  
    - accepted_language:  
        required: false  
    - acceptedLanguage: 
        default: ${get('accepted_language', '')}  
        required: false 
        private: true 
    - path_id:  
        required: false  
    - pathId: 
        default: ${get('path_id', '')}  
        required: false 
        private: true 
    - product_id
    - productId: 
        default: ${get('product_id', '')}
        private: true 
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
    - provisioning_artifact_id
    - provisioningArtifactId: 
        default: ${get('provisioning_artifact_id', '')}
        private: true 
    - provisioning_parameters:  
        required: false  
    - provisioningParameters: 
        default: ${get('provisioning_parameters', '')}  
        required: false 
        private: true 
    - use_previous_value:  
        required: false  
    - usePreviousValue: 
        default: ${get('use_previous_value', '')}  
        required: false 
        private: true 
    - delimiter:  
        required: false  
    - update_token:  
        required: false  
    - updateToken: 
        default: ${get('update_token', '')}  
        required: false 
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-amazon:1.0.53-SNAPSHOT-300'
    class_name: 'io.cloudslang.content.amazon.actions.servicecatalog.UpdateProvisionedProduct'
    method_name: 'execute'
  
  outputs: 
    - return_code: ${get('returnCode', '')} 
    - return_result: ${get('returnResult', '')} 
    - exception: ${get('exception', '')} 
    - created_time: ${get('createdTime', '')} 
    - path_id_output: ${get('pathId', '')} 
    - product_id_result: ${get('productIdResult', '')} 
    - provisioned_product_id_output: ${get('provisionedProductId', '')} 
    - provisioned_product_name_result: ${get('provisionedProductNameResult', '')} 
    - provisioned_product_type: ${get('provisionedProductType', '')} 
    - provisioning_artifact_id_output: ${get('provisioningArtifactId', '')} 
    - update_time: ${get('updateTime', '')} 
    - record_id: ${get('recordId', '')} 
    - record_type: ${get('recordType', '')} 
    - record_errors: ${get('recordErrors', '')} 
    - record_tags: ${get('recordTags', '')} 
    - status: ${get('status', '')}
    - stack_outputs: ${get('stackOutputs', '')}
    - stack_resources: ${get('stackResources', '')}
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
