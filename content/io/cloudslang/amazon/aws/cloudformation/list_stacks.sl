#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: This operation lists all deployed AWS Cloud Formation stacks.
#!
#! @input identity: ID of the secret access key associated with your Amazon AWS account.
#! @input credential: Secret access key associated with your Amazon AWS account.
#! @input region: AWS region from where the stacks should be listed.
#! @input connect_timeout: Connect timeout in milliseconds.
#!                    Default: '10000'
#!                    Optional
#! @input execution_timeout: Execution timeout in milliseconds.
#!                    Default: '600000'
#!                    Optional
#! @input proxy_host: Proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#!
#! @output return_result: Contains the instance details in case of success, error message otherwise.
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The list of stacks was successfully retrieved.
#! @result FAILURE: There was an error while retrieving the list of stacks from AWS.
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.aws.cloudformation

operation:
  name: list_stacks
  inputs:
    - identity
    - credential:
        sensitive: true
    - connect_timeout:
        required: false
        default: "10000"
    - connectTimeout:
        default: ${get("connect_timeout", "")}
        private: true
    - execution_timeout:
        required: false
        default: "600000"
    - executionTimeout:
        default: ${get("execution_timeout", "")}
        private: true
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        required: false
        private: true
    - proxy_port:
        default: '8080'
        required: false
    - proxyPort:
        default: ${get("proxy_port", "")}
        required: false
        private: true
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get("proxy_username", "")}
        required: false
        private: true
    - proxy_password:
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get("proxy_password", "")}
        required: false
        private: true
        sensitive: true
    - region

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.18'
    class_name: io.cloudslang.content.amazon.actions.cloudformation.ListStacksAction
    method_name: execute

  outputs:
    - return_result: ${get("returnResult", "")}
    - return_code: ${get("returnCode", "")}
    - exception: ${get("exception", "")}
 
  results:
    - SUCCESS: ${returnCode == "0"}
    - FAILURE