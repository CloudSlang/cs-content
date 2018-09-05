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
#! @description: Provisions the specified product. A provisioned product is a resourced instance of a product. For example,
#!               provisioning a product based on a CloudFormation template launches a CloudFormation stack and its underlying resources.
#!
#! @input identity: ID of the secret access key associated with your Amazon AWS account.
#! @input credential: Secret access key associated with your Amazon AWS account.
#! @input proxy_host: Proxy server used to connect to Amazon API. If empty no proxy will be used.
#! @input proxy_port: Proxy server port. You must either specify values for both proxyHost and proxyPort inputs or leave them both empty.
#! @input proxy_username: Proxy server user name.
#! @input proxy_password: Proxy server password associated with the proxyUsername input value.
#! @input connect_timeout: The amount of time to wait (in milliseconds) when initially establishing a connection before giving up and timing out.
#! @input execution_timeout: The amount of time (in milliseconds) to allow the client to complete the execution of an API call. A value of '0' disables this feature.
#! @input polling_interval: The time, in seconds, to wait before a new request that verifies if the operation finished is executed.
#! @input async: Whether to run the operation is async mode.
#! @input product_id: The product identifier.
#! @input provisioned_product_name: A user-friendly name for the provisioned product. This value must be unique for the
#!                                  AWS account and cannot be updated after the product is provisioned.
#! @input provisioning_artifact_id: The identifier of the provisioning artifact also known as version Id.
#! @input provisioning_parameters: Template parameters in key value format, one key=value, delimited by the value from delimiter input.
#! @input delimiter: The delimiter used to separate the values from provisioningParameters and tags inputs.
#! @input tags: One or more tags.
#! @input provision_token: An idempotency token that uniquely identifies the provisioning request.
#! @input accept_language: String that contains the language code.
#! @input notification_arns: Strings that are passed to CloudFormation.The Simple Notification Service topic Amazon Resource
#!                           Names to which to publish stack-related events.
#! @input path_id: String that contains the identifier path of the product. This value is optional if the product has a
#!                 default path, and required if the product has more than one path.
#! @input region: String that contains the Amazon AWS region name.
#!
#! @output return_result: The full API response in case of success, or an error message in case of failure.
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#! @output created_time: The UTC time stamp of the creation time.
#! @output path_id_output: String that contains the identifier path of the product.This value is optional if the product
#!                         has a default path, and required if the product has more than one path.
#! @output product_id_output: The product identifier.
#! @output provisioned_product_id: The identifier of the provisioned product.
#! @output provisioned_product_name_output: A user-friendly name for the provisioned product.This value must be unique
#!                                          for the AWS account and cannot be updated after the product is provisioned.
#! @output provisioned_product_type: The type of provisioned product. The supported value is 'CFN_STACK'.
#! @output provisioned_artifact_id: The identifier of the provisioned artifact.
#! @output status: The status of the provisioned product.
#! @output stack_id: The unique stack ID that is associated with the stack.
#! @output stack_name: The name that is associated with the stack.
#! @output stack_outputs: The optional Outputs section declares output values that you can import into other stacks
#!                        (to create cross-stack references), return in response (to describe stack calls), or view on
#!                        the AWS CloudFormation console.
#! @output stack_resources:  The key name of the AWS Resources that you want to include in the stack, such as an
#!                           Amazon EC2 instance or an Amazon S3 bucket.
#!
#! @result FAILURE: An error has occurred while trying to provision the product.
#! @result SUCCESS: The product was successfully provisioned.
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.aws.servicecatalog
flow:
  name: provision_product
  inputs:
    - identity
    - credential:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
        default: '8080'
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - connect_timeout:
        required: false
        default: '10000'
    - execution_timeout:
        required: false
        default: '60000'
    - polling_interval:
        required: false
        default: '1000'
    - async:
        required: false
        default: 'false'
    - product_id
    - provisioned_product_name
    - provisioning_artifact_id
    - provisioning_parameters:
        required: false
    - delimiter:
        required: false
        default: ','
    - tags:
        required: false
    - provision_token:
        required: false
    - accept_language:
        default: 'en'
        required: false
    - notification_arns:
        required: false
    - path_id:
        required: false
    - region:
        default: 'us-east-1'
        required: false
  workflow:
    - provision_product:
        do:
          io.cloudslang.amazon.aws.servicecatalog.products.provision_product:
            - identity
            - credential:
                sensitive: true
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password:
                sensitive: true
            - connect_timeout
            - execution_timeout
            - polling_interval
            - async
            - provisioning_parameters
            - product_id
            - provisioned_product_name
            - provisioning_artifact_id
            - delimiter
            - tags
            - provision_token
            - accept_language
            - notification_arns
            - path_id
            - region

        publish:
            - return_result
            - created_time
            - path_id_output
            - product_id_output
            - provisioned_product_id
            - provisioned_product_name_output
            - provisioned_product_type
            - provisioned_artifact_id
            - status
            - stack_id
            - stack_name
            - stack_outputs
            - stack_resources
            - return_code
            - exception
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - return_result
    - created_time
    - path_id_output
    - product_id_output
    - provisioned_product_id
    - provisioned_product_name_output
    - provisioned_product_type
    - provisioned_artifact_id
    - status
    - stack_id
    - stack_name
    - stack_outputs
    - stack_resources
    - return_code
    - exception
  results:
    - SUCCESS
    - FAILURE


