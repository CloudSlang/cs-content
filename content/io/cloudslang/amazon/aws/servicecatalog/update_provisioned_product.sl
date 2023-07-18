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
#! @input credential: Secret access key associated with your Amazon AWS or IAM account.
#! @input proxy_host: Proxy server used to connect to Amazon API. If empty no proxy will be used.
#! @input proxy_port: Proxy server port. You must either specify values for both proxy_host and proxy_port inputs or leave
#!                    them both empty.
#! @input proxy_username: Proxy server user name.
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#! @input connect_timeout: The amount of time to wait (in milliseconds) when initially establishing a connection before
#!                         giving up and timing out.
#! @input execution_timeout: The amount of time (in milliseconds) to allow the client to complete the execution of an
#!                           API call. A value of '0' disables this feature.
#! @input polling_interval: The time, in seconds, to wait before a new request that verifies if the operation finished is executed.
#! @input async: Whether to run the operation is async mode.
#! @input region: String that contains the Amazon AWS region name.
#! @input accepted_language: The language code.
#! @input path_id: The new path identifier. This value is optional if the product has a default path, and required if
#!                 the product has more than one path.
#! @input product_id: The product identifier.
#! @input provisioned_product_id: The identifier of the provisioned product. You cannot specify both
#!                                provisioned_product_name and provisioned_product_id.
#! @input provisioned_product_name: The updated name of the provisioned product. You cannot specify both
#!                                  provisioned_product_name and provisioned_product_id.
#! @input provisioning_artifact_id: The identifier of the provisioning artifact.
#! @input provisioning_parameters: The new parameters.
#! @input use_previous_value: If set to true, the new parameters are ignored and the previous parameter value is kept.
#! @input delimiter: The delimiter used to separate the values from provisioning_parameters input.
#! @input update_token: The idempotency token that uniquely identifies the provisioning update request.
#!
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output return_result: The full API response in case of success, or an error message in case of failure.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#! @output created_time: The UTC time stamp of the creation time.
#! @output path_id_output: The new path identifier. This value is optional if the product has a default path, and
#!                         required if the product has more than one path.
#! @output product_id_result: The product identifier.
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
namespace: io.cloudslang.amazon.aws.servicecatalog

flow:
  name: update_provisioned_product
  inputs:
  - identity
  - credential:
      sensitive: true
  - proxy_host:
      required: false
  - proxy_port:
      required: false
  - proxy_username:
      required: false
  - proxy_password:
      required: false
      sensitive: true
  - connect_timeout:
      required: false
  - execution_timeout:
      required: false
  - polling_interval:
      required: false
      default: '1000'
  - async:
      required: false
  - region:
      required: false
  - accepted_language:
      required: false
  - path_id:
      required: false
  - product_id
  - provisioned_product_id:
      required: false
  - provisioned_product_name:
      required: false
  - provisioning_artifact_id
  - provisioning_parameters:
      required: false
  - use_previous_value:
      required: false
  - delimiter:
      required: false
  - update_token:
      required: false
  workflow:
    - update_provisioned_product:
        do:
          io.cloudslang.amazon.aws.servicecatalog.products.update_provisioned_product:
            - identity
            - credential:
                value: '${credential}'
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
            - region
            - accepted_language
            - path_id
            - product_id
            - provisioned_product_id
            - provisioned_product_name
            - provisioning_artifact_id
            - provisioning_parameters
            - use_previous_value
            - delimiter
            - update_token

        publish:
          - return_code
          - return_result
          - exception
          - created_time
          - path_id_output
          - product_id_result
          - provisioned_product_id_output
          - provisioned_product_name_result
          - provisioned_product_type
          - provisioning_artifact_id_output
          - update_time
          - record_id
          - record_type
          - record_errors
          - record_tags
          - status
          - stack_outputs
          - stack_resources
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - return_code
    - return_result
    - exception
    - created_time
    - path_id_output
    - product_id_result
    - provisioned_product_id_output
    - provisioned_product_name_result
    - provisioned_product_type
    - provisioning_artifact_id_output
    - update_time
    - record_id
    - record_type
    - record_errors
    - record_tags
    - status
    - stack_outputs
    - stack_resources
  results:
    - SUCCESS
    - FAILURE