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
#! @description: This operation launches an AWS Cloud Formation stack.
#!
#! @input identity: ID of the secret access key associated with your Amazon AWS account.
#! @input credential: Secret access key associated with your Amazon AWS account.
#! @input proxy_host: Proxy server used to access the provider services.
#!                    Optional
#! @input connect_timeout: Connect timeout in milliseconds.
#!                    Default: '10000'
#!                    Optional
#! @input execution_timeout: Execution timeout in milliseconds.
#!                    Default: '600000'
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input region: AWS region where the stack will be created.
#! @input stack_name: AWS stack name to be created.
#! @input template_body: AWS template body.
#! @input parameters: AWS template parameters in key:value format. Every key:value pair should be on its own line.
#! @input capabilities: A list of values that you must specify before AWS CloudFormation can create certain stacks. Some stack templates might include resources that can affect permissions in your AWS account, for example, by creating new AWS Identity and Access Management (IAM) users. or those stacks, you must explicitly acknowledge their capabilities by specifying this parameter.
#!                      Valid values: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
#!
#! @output return_result: Contains the instance details in case of success, error message otherwise.
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The stack was successfully created
#! @result FAILURE: There was an error while trying to create the stack
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.aws.cloudformation

operation:
  name: create_stack
  inputs:
    - identity
    - credential:
        sensitive: true
    - region
    - stack_name
    - stackName:
        default: ${get("stack_name", "")}
        private: true
    - template_body
    - templateBody:
        default: ${get("template_body", "")}
        private: true
    - parameters:
        required: false
    - capabilities:
        required: false
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

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.18'
    class_name: io.cloudslang.content.amazon.actions.cloudformation.CreateStackAction
    method_name: execute

  outputs:
    - return_result: ${get("returnResult", "")}
    - return_code: ${get("returnCode", "")}
    - exception: ${get("exception", "")}
 
  results:
    - SUCCESS: ${returnCode == "0"}
    - FAILURE