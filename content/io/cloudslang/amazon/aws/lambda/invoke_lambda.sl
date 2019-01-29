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
#! @description: This operation  invokes an AWS Lambda Function
#!
#! @input identity: ID of the secret access key associated with your Amazon AWS account.
#! @input credential: Secret access key associated with your Amazon AWS account.
#! @input proxy_host: Proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input connect_timeout: The amount of time (in milliseconds) that the HTTP connection will wait to establish a connection before giving up.
#!                         Optional
#! @input execution_timeout: The amount of time (in milliseconds) to allow the client to complete the execution of an API call.
#!                           Optional
#! @input region: AWS region where the stack will be created
#!                Optional
#! @input function: Name of the Lambda function
#! @input function_payload: JSON payload to be sent to the lambda function
#!                          Optional
#! @input qualifier: Lambda function version
#!                   Default: '$LATEST'
#!                   Optional
#!
#! @output return_result: Contains the AWS Lambda function execution result details in case of success, error message otherwise.
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The server (instance) was successfully deployed.
#! @result FAILURE: There was an error while trying to deploy the instance.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.lambda

operation:
  name: invoke_lambda
  inputs:
    - identity
    - credential:
        sensitive: true
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
        sensitive: true
        private: true
    - connect_timeout:
        required: false
    - connectTimeout:
        default: ${get("connect_timeout", "")}
        required: false
        private: true
    - execution_timeout:
        required: false
    - executionTimeout:
        default: ${get("execution_timeout", "")}
        required: false
        private: true
    - region
    - function
    - qualifier:
        required: false
    - function_payload:
        required: false
    - functionPayload:
        default: ${get("function_payload", "")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.18'
    class_name: io.cloudslang.content.amazon.actions.lambda.InvokeLambdaAction
    method_name: execute

  outputs:
    - return_result: ${get("returnResult", "")}
    - return_code: ${get("returnCode", "")}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == "0"}
    - FAILURE
