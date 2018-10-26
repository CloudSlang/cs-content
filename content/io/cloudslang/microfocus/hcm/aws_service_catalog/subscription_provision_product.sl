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
#! @description: This flow reads the component properties from a given CSA subscription, select the properties associated
#!               with Amazon Service Catalog provisioning parameters and provision an Amazon Service Catalog product with
#!               selected parameters from CSA subscription.
#!
#! @input hcm_subscription_id: The ID of the subscription for which to retrieve the component properties.
#! @input hcm_service_instance_id: The ID of the service instance which will be used for tagging.
#! @input aws_accessKeyId: ID of the secret access key associated with your Amazon AWS account.
#! @input aws_secretAccessKey: Secret access key associated with your Amazon AWS account.
#! @input aws_product_id: The AWS product identifier.
#! @input aws_provisioned_product_name: A user-friendly name for the provisioned product. This value must be unique for
#!                                      the AWS account and cannot be updated after the product is provisioned.
#! @input aws_provisioning_artifact_id: The identifier of the provisioning artifact also known as version Id.
#! @input aws_tags: One or more tags in key value format, one key=value, delimited by "&" character.
#!                  Examples: tag1=tagValue1&tag2=tagValue2
#! @input aws_provision_token: An idempotency token that uniquely identifies the provisioning request.
#! @input aws_accept_language: String that contains the language code.
#!                             Examples: "en" - English, "jp" - Japanese, "zh" - Chinese
#! @input aws_notification_arns: The Simple Notification Service topic Amazon Resource Names to which to publish
#!                               stack-related events.
#! @input aws_path_id: String that contains the identifier path of the product. This value is optional if the product
#!                     has a default path, and required if the product has more than one path.
#! @input aws_region: String that contains the Amazon AWS region name.
#! @input aws_proxy_host: Proxy server used to access the Amazon.
#! @input aws_proxy_port: Proxy server port.
#!                        Default: '8080'
#! @input aws_proxy_username: Username used when connecting to the proxy.
#! @input aws_proxy_password: Proxy server password associated with the <proxy_username> input value.
#! @input aws_execution_timeout: The amount of time (in milliseconds) to allow the client to complete the execution of
#!                               an API call. A value of '0' disables this feature.
#! @input aws_polling_interval: The time, in seconds, to wait before a new request that verifies if the operation
#!                              finished is executed.
#! @input aws_async: Whether to run the operation is async mode.
#! @input aws_connect_timeout: The amount of time to wait (in milliseconds) when initially establishing a connection to
#!                             Amazon before giving up and timing out.
#!
#! @output provisioned_product_created_time: The UTC time stamp of the resource creation time.
#! @output provisioned_product_type: The type of provisioned product. The supported value is 'CFN_STACK'.
#! @output provisioned_product_id: The identifier of the provisioned product.
#! @output provisioned_product_status: The status of the provisioned product.
#! @output stack_id: The unique stack ID that is associated with the stack.
#! @output stack_name: The name that is associated with the stack.
#! @output stack_outputs: The optional Outputs section declares output values that you can import into other stacks
#!                        (to create cross-stack references), return in response (to describe stack calls), or view on
#!                        the AWS CloudFormation console.
#! @output stack_resources: The key name of the AWS Resources that you want to include in the stack, such as an Amazon
#!                          EC2 instance or an Amazon S3 bucket.
#! @output return_result: The full AWS Service Catalog API response, in JSON format, in case of success, or an error message in case of failure.
#! @output return_code: "0" if flow was successfully executed, "-1" otherwise.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result FAILURE: An error has occurred while trying to execute the flow.
#! @result SUCCESS: The flow was successfully executed.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.hcm.aws_service_catalog
flow:
  name: subscription_provision_product
  inputs:
    - hcm_subscription_id
    - hcm_service_instance_id
    - aws_accessKeyId
    - aws_secretAccessKey:
        sensitive: true
    - aws_product_id
    - aws_provisioned_product_name
    - aws_provisioning_artifact_id
    - aws_tags:
        required: false
    - aws_provision_token:
        required: false
    - aws_accept_language:
        required: false
    - aws_notification_arns:
        required: false
    - aws_path_id:
        required: false
    - aws_region:
        required: false
    - aws_proxy_host:
        required: false
    - aws_proxy_port:
        default: '8080'
        required: false
    - aws_proxy_username:
        required: false
    - aws_proxy_password:
        required: false
        sensitive: true
    - aws_execution_timeout:
        default: '60000'
        required: false
    - aws_polling_interval:
        default: '1000'
        required: false
    - aws_async:
        default: 'false'
        required: false
    - aws_connect_timeout: '10000'
  workflow:
    - read_component_properties:
        do:
          io.cloudslang.microfocus.hcm.aws_service_catalog.utils.read_component_properties:
            - csa_rest_uri: ${get_sp('io.cloudslang.microfocus.hcm.rest_uri')}
            - csa_user: ${get_sp('io.cloudslang.microfocus.hcm.user')}
            - csa_subscription_id: '${hcm_subscription_id}'
            - delimiter: '&'
            - auth_type: ${get_sp('io.cloudslang.microfocus.hcm.auth_type')}
            - username: ${get_sp('io.cloudslang.microfocus.hcm.user')}
            - password:
                value: ${get_sp('io.cloudslang.microfocus.hcm.password')}
                sensitive: true
            - proxy_host: ''
            - proxy_username: ''
            - trust_all_roots: ${get_sp('io.cloudslang.microfocus.hcm.trust_all_roots')}
            - x_509_hostname_verifier: ${get_sp('io.cloudslang.microfocus.hcm.x_509_hostname_verifier')}
            - trust_keystore: ${get_sp('io.cloudslang.microfocus.hcm.trust_keystore')}
            - trust_password:
                value: ${get_sp('io.cloudslang.microfocus.hcm.trust_password')}
                sensitive: true
            - keystore: ${get_sp('io.cloudslang.microfocus.hcm.keystore')}
            - keystore_password:
                value: ${get_sp('io.cloudslang.microfocus.hcm.keystore_password')}
                sensitive: true
            - connect_timeout: ${get_sp('io.cloudslang.microfocus.hcm.connect_timeout')}
            - socket_timeout: ${get_sp('io.cloudslang.microfocus.hcm.socket_timeout')}
            - use_cookies: ${get_sp('io.cloudslang.microfocus.hcm.use_cookies')}
            - keep_alive: ${get_sp('io.cloudslang.microfocus.hcm.keep_alive')}
        publish:
          - parameters_list: '${return_result}'
        navigate:
          - SUCCESS: provision_product
          - FAILURE: FAILURE
    - provision_product:
        do:
          io.cloudslang.amazon.aws.servicecatalog.provision_product:
            - identity: '${aws_accessKeyId}'
            - credential:
                value: '${aws_secretAccessKey}'
                sensitive: true
            - proxy_host: '${aws_proxy_host}'
            - proxy_port: '${aws_proxy_port}'
            - proxy_username: '${aws_proxy_username}'
            - proxy_password:
                value: '${aws_proxy_password}'
                sensitive: true
            - connect_timeout: '${aws_connect_timeout}'
            - execution_timeout: '${aws_execution_timeout}'
            - pooling_interval: '${aws_polling_interval}'
            - async: '${aws_async}'
            - product_id: '${aws_product_id}'
            - provisioned_product_name: '${aws_provisioned_product_name}'
            - provisioning_artifact_id: '${aws_provisioning_artifact_id}'
            - provisioning_parameters: '${parameters_list}'
            - delimiter: '&'
            - tags: '${hcm_service_instance_id=${hcm_service_instance_id}}'
            - provision_token: '${aws_provision_token}'
            - accept_language: '${aws_accept_language}'
            - notification_arns: '${aws_notification_arns}'
            - path_id: '${aws_path_id}'
            - region: '${aws_region}'
        publish:
          - return_result
          - return_code
          - exception
          - created_time
          - provisioned_product_type
          - status
          - stack_id
          - stack_name
          - stack_outputs
          - stack_resources
          - provisioned_product_id
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - provisioned_product_created_time: '${created_time}'
    - provisioned_product_type: '${provisioned_product_type}'
    - provisioned_product_id: '${provisioned_product_id}'
    - provisioned_product_status: '${status}'
    - stack_id: '${stack_id}'
    - stack_name: '${stack_name}'
    - stack_outputs: '${stack_outputs}'
    - stack_resources: '${stack_resources}'
    - return_result: '${return_result}'
    - return_code: '${return_code}'
    - exception: '${exception}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      read_component_properties:
        x: 47
        y: 146
        navigate:
          7d461649-cfad-7ae3-0dae-445957688f8d:
            targetId: 0fba1334-6aa9-f61b-fe50-d8fb2650d483
            port: FAILURE
      provision_product:
        x: 279
        y: 147
        navigate:
          3bed89ed-20f0-5535-3605-af3e8e989099:
            targetId: 96952f9c-1b7f-9049-91b1-a408f192d6fb
            port: SUCCESS
          3a27d0f3-a430-74bf-da1d-308c543b7ef2:
            targetId: 0fba1334-6aa9-f61b-fe50-d8fb2650d483
            port: FAILURE
    results:
      FAILURE:
        0fba1334-6aa9-f61b-fe50-d8fb2650d483:
          x: 43
          y: 339
      SUCCESS:
        96952f9c-1b7f-9049-91b1-a408f192d6fb:
          x: 502
          y: 136
