#   (c) Copyright 2019 Micro Focus
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
#! @description: This operation get AWS CloudFormation Stack details
#!
#! @input identity: ID of the secret access key associated with your Amazon AWS account.
#! @input credential: Secret access key associated with your Amazon AWS account.
#! @input region: AWS region where the CloudFormation stack is located
#! @input stack_name: AWS stack name to get details from
#!                    Mandatory
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
#! @output stack_id: CloudFormation stack id in Amazon Resource Notation (ARN) format. Example: arn:aws:cloudformation:<region>:<account>:stack/<stack name>/<UUID>
#! @output stack_status: CloudFormation stack creation status Example: CREATE_COMPLETE, ROLLBACK_COMPLETE
#! @output stack_status_reason: CloudFormation stack creation status reason
#! @output stack_creation_time: CloudFormation stack creation time
#! @output stack_description: CloudFormation stack description
#! @output stack_outputs: CloudFormation stack outputs as JSON array
#! @output stack_resources: CloudFormation stack outputs as JSON array
#! @output return_result: Contains the instance details in case of success, error message otherwise.
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The stack details were successfully retrieved
#! @result FAILURE: There was an error while trying to retrieve details from AWS
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.cloudformation

operation:
  name: get_stack_details
  inputs:
    - identity
    - credential:
        sensitive: true
    - region
    - stack_name
    - stackName:
        default: ${get("stack_name", "")}
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

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.18'
    class_name: io.cloudslang.content.amazon.actions.cloudformation.GetStackDetailsAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${get("returnCode", "")}
    - exception: ${get("exception", "")}
    - stack_id: ${stackId}
    - stack_status: ${stackStatus}
    - stack_status_reason: ${stackStatusReason}
    - stack_creation_time: ${stackCreationTime}
    - stack_description: ${stackDescription}
    - stack_outputs: ${stackOutputs}
    - stack_resources: ${stackResources}

  results:
    - SUCCESS: ${returnCode == "0"}
    - FAILURE
