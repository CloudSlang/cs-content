#   (c) Copyright 2021 Micro Focus, L.P.
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
#! @description: The operation checks if an instance has a specific state.
#!
#! @input provider_sap: The endpoint to which requests are sent.
#!                      Default: https://ec2.amazonaws.com
#! @input access_key_id: The ID of the secret access key associated with your Amazon AWS or IAM account.
#! @input access_key: The secret access key associated with your Amazon AWS or IAM account.
#! @input instance_id: The ID of the server (instance) you want to check.
#! @input instance_state: The state that you would like the instance to have.
#! @input proxy_host: Optional - Proxy server used to access the provider services
#! @input proxy_port: Optional - Proxy server port used to access the provider services.
#! @input proxy_username: Optional - Proxy server user name.
#! @input proxy_password: Optional - Proxy server password associated with the proxy_username input value.
#! @input polling_interval: Optional - The number of seconds to wait until performing another check.
#! @input worker_group: Optional - A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output output: Contains the success message or the exception in case of failure
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise
#! @output exception: Exception if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: The server (instance) has the expected state
#! @result FAILURE: Error checking the instance state, or the actual state is not the expected one
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.instances

imports:
  instances: io.cloudslang.amazon.aws.ec2.instances
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils

flow:
  name: check_instance_state_v2
  inputs:
    - provider_sap: 'https://ec2.amazonaws.com'
    - access_key_id
    - access_key:
        sensitive: true
    - instance_id
    - instance_state
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - polling_interval:
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false

  workflow:
    - describe_instances:
        worker_group: '${worker_group}'
        do:
          instances.describe_instances:
            - endpoint: '${provider_sap}'
            - identity: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - instance_ids_string: '${instance_id}'
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: string_occurrence_counter
          - FAILURE: on_failure

    - string_occurrence_counter:
        worker_group: '${worker_group}'
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: '${return_result}'
            - string_to_find: '${instance_state}'
        publish: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: sleep

    - sleep:
        worker_group: '${worker_group}'
        do:
          utils.sleep:
            - seconds: "${get('polling_interval', '10')}"
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure

  outputs:
    - output: '${return_result}'
    - return_code
    - exception

  results:
    - SUCCESS
    - FAILURE

extensions:
  graph:
    steps:
      describe_instances:
        x: 39
        'y': 76
      string_occurrence_counter:
        x: 211
        'y': 71
        navigate:
          097c51fc-07b5-1036-3c2c-0813bbf9c783:
            targetId: 80e46c3f-a021-d108-278e-02e6b98aeeeb
            port: SUCCESS
          bf3692c6-7d50-3f5a-c663-180545667baf:
            vertices:
              - x: 353
                'y': 196
            targetId: sleep
            port: FAILURE
      sleep:
        x: 215
        'y': 248
        navigate:
          b7ebf2ec-c424-ac47-5afa-81ffa4b4153e:
            targetId: 2c232bdd-fd5c-ab65-a8a4-388870ce487c
            port: SUCCESS
    results:
      SUCCESS:
        80e46c3f-a021-d108-278e-02e6b98aeeeb:
          x: 398
          'y': 78
      FAILURE:
        2c232bdd-fd5c-ab65-a8a4-388870ce487c:
          x: 399
          'y': 246