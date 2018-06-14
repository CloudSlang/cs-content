#   (c) Copyright 2018 Micro Focus
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
#! @description: Example workflow that launches an AWS CloudFormation stack.
#!
#! @input access_key_id: ID of the secret access key associated with your Amazon AWS account.
#! @input access_key: Secret access key associated with your Amazon AWS account.
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
#! @input stack_capabilities: A list of values that you must specify before AWS CloudFormation can create certain stacks. Some stack templates might include resources that can affect permissions in your AWS account, for example, by creating new AWS Identity and Access Management (IAM) users. or those stacks, you must explicitly acknowledge their capabilities by specifying this parameter.
#!                      Valid values: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
#! @input template_body: AWS template body.
#! @input template_parameters: AWS template parameters in key=value format. Every key:value pair should be on its own line.
#! @input sleep_time: sleep time in seconds between retries
#! @input retries_max: maximum number of retries before giving up
#!
#!
#! @result SUCCESS: The stack was successfully created
#! @result FAILURE: There was an error while trying to create the stack
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.cloudformation.examples

imports:
  cloudformation: io.cloudslang.amazon.aws.cloudformation
  strings: io.cloudslang.base.strings

flow:
  name: launch_stack
  inputs:
    - access_key_id
    - access_key:
        sensitive: true
    - region
    - stack_name: ''
    - stack_capabilities:
        required: false
    - template_body: ''
    - template_parameters:
        default: "${'param1=' + value1 + '\\n\\\nparam2='  + value2 + '\\n\\\nparam3='  + value3}"
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - sleep_time:
        default: '30'
        required: false
    - retries_max:
        default: '10'
        required: false

  workflow:
    - create_stack:
        do:
          cloudformation.create_stack:
            - identity:
                value: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - region
            - stack_name
            - template_body
            - parameters: '${template_parameters}'
            - capabilities: '${stack_capabilities}'
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - retry_count: '0'
        navigate:
          - SUCCESS: get_stack_details
          - FAILURE: on_failure

    - list_stacks:
        do:
          cloudformation.list_stacks:
            - identity:
                value: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - region
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure

    - get_stack_details:
        do:
          cloudformation.get_stack_details:
            - identity:
                value: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - region
            - stack_name
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - stack_status
        navigate:
          - SUCCESS: is_stack_created
          - FAILURE: on_failure

    - is_stack_created:
        do:
          strings.string_equals:
            - first_string: '${stack_status}'
            - second_string: CREATE_COMPLETE
        navigate:
          - SUCCESS: list_stacks
          - FAILURE: add_numbers

    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '${sleep_time}'
        navigate:
          - SUCCESS: get_stack_details
          - FAILURE: on_failure

    - add_numbers:
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: '${retry_count}'
            - value2: '1'
        publish:
          - retry_count: '${result}'
        navigate:
          - SUCCESS: check_retry
          - FAILURE: on_failure

    - check_retry:
        do:
          io.cloudslang.base.math.compare_numbers:
            - value1: '${retry_count}'
            - value2: '${retries_max}'
        navigate:
          - GREATER_THAN: FAILURE
          - EQUALS: sleep
          - LESS_THAN: sleep
  results:
    - FAILURE
    - SUCCESS

extensions:
  graph:
    steps:
      create_stack:
        x: 71
        y: 106
      list_stacks:
        x: 659
        y: 107
        navigate:
          40f99d8a-14df-ee1e-08fa-2150abef743d:
            targetId: 9b31debc-5211-7ae2-d870-fa22325e37a9
            port: SUCCESS
      get_stack_details:
        x: 280
        y: 106
      is_stack_created:
        x: 494
        y: 99
      sleep:
        x: 281
        y: 280
      add_numbers:
        x: 462
        y: 281
      check_retry:
        x: 458
        y: 433
        navigate:
          9675d7e4-57c4-13b5-7a01-dee957d1d14b:
            targetId: 3aa9d9ea-1ecd-b4d8-106c-f95ab0ef5472
            port: GREATER_THAN
    results:
      FAILURE:
        3aa9d9ea-1ecd-b4d8-106c-f95ab0ef5472:
          x: 651
          y: 423
      SUCCESS:
        9b31debc-5211-7ae2-d870-fa22325e37a9:
          x: 839
          y: 113