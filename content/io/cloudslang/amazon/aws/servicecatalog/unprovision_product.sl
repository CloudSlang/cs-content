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
#! @description: Terminates the specified provisioned product.
#!
#! @input identity: ID of the secret access key associated with your Amazon AWS or IAM account.
#! @input credential: Secret access key associated with your Amazon AWS or IAM account.
#! @input proxy_host: Proxy server used to connect to Amazon API. If empty no proxy will be used.
#! @input proxy_port: Proxy server port. You must either specify values for both proxyHost and proxyPort inputs or leave
#!                    them both empty.
#! @input proxy_username: Proxy server user name.
#! @input proxy_password: Proxy server password associated with the proxyUsername input value.
#! @input connect_timeout: The amount of time to wait (in milliseconds) when initially establishing a connection before
#!                         giving up and timing out.
#! @input execution_timeout: The amount of time (in milliseconds) to allow the client to complete the execution of an
#!                           API call. A value of '0' disables this feature.
#! @input polling_interval: The time, in seconds, to wait before a new request that verifies if the operation finished is executed.
#! @input async: Whether to run the operation is async mode.
#! @input region: String that contains the Amazon AWS region name.
#! @input provisioned_product_id: The identifier of the provisioned product. You cannot specify both
#!                                provisioned_product_name and provisioned_product_id.
#! @input provisioned_product_name: A user-friendly name for the provisioned product.This value must be unique for the
#!                                  AWS account and cannot be updated after the product is provisioned. You cannot
#!                                  specify both provisioned_product_name and provisioned_product_id.
#! @input accept_language: String that contains the language code.Example: en (English), jp (Japanese), zh(Chinese).
#! @input ignore_errors: If set to true, AWS Service Catalog stops managing the specified provisioned product even if it
#!                       cannot delete the underlying resources.
#! @input terminate_token: An idempotency token that uniquely identifies the termination request. This token is only
#!                         valid during the termination process. After the provisioned product is terminated, subsequent
#!                         requests to terminate the same provisioned product always return ResourceNotFound.
#!
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output return_result: The full API response in case of success, or an error message in case of failure.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The product was successfully unprovisioned.
#! @result FAILURE: An error has occurred while trying to unprovision the product.
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.aws.servicecatalog
flow:
  name: unprovision_product
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
  - provisioned_product_id:
      required: false
  - provisioned_product_name:
      required: false
  - accept_language:
      default: 'en'
      required: false
  - region:
      default: 'us-east-1'
      required: false
  - ignore_errors:
       default: 'false'
       required: false
  - terminate_token:
      required: false
  workflow:
  - unprovision_product:
      do:
        io.cloudslang.amazon.aws.servicecatalog.products.unprovision_product:
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
        - provisioned_product_id
        - provisioned_product_name
        - terminate_token
        - accept_language
        - region
        - ignore_errors
      publish:
      - return_result
      - return_code
      - exception
      navigate:
      - SUCCESS: SUCCESS
      - FAILURE: FAILURE
  outputs:
  - return_result
  - return_code
  - exception
  results:
  - SUCCESS
  - FAILURE