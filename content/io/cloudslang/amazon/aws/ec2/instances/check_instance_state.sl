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
#! @description: The operation checks if an instance has a specific state.
#!
#! @input identity: ID of the secret access key associated with your Amazon AWS account.
#! @input credential: Secret access key associated with your Amazon AWS account.
#! @input proxy_host: Proxy server used to access the provider services
#! @input proxy_port: Proxy server port used to access the provider services
#!                    Default: '8080'
#! @input proxy_username: Optional - Proxy server user name.
#!                        Default: ''
#! @input proxy_password: Optional - Proxy server password associated with the proxy_username
#!                        input value.
#!                        Default: ''
#! @input instance_id: The ID of the server (instance) you want to check.
#! @input instance_state: The state that you would like the instance to have.
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Default: '10'
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
  name: check_instance_state

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
    - instance_id
    - instance_state
    - polling_interval:
        required: false

  workflow:
    - describe_instances:
        do:
          instances.describe_instances:
            - identity
            - credential
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - instance_ids_string: ${instance_id}
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: string_occurrence_counter
          - FAILURE: on_failure

    - string_occurrence_counter:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${return_result}
            - string_to_find: ${instance_state}
        publish: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: sleep

    - sleep:
        do:
          utils.sleep:
            - seconds: ${get('polling_interval', '10')}
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure

  outputs:
    - output: ${return_result}
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
        y: 74
      string_occurrence_counter:
        x: 215
        y: 70
        navigate:
          097c51fc-07b5-1036-3c2c-0813bbf9c783:
            targetId: 80e46c3f-a021-d108-278e-02e6b98aeeeb
            port: SUCCESS
      sleep:
        x: 215
        y: 249
        navigate:
          b7ebf2ec-c424-ac47-5afa-81ffa4b4153e:
            targetId: 2c232bdd-fd5c-ab65-a8a4-388870ce487c
            port: SUCCESS
    results:
      SUCCESS:
        80e46c3f-a021-d108-278e-02e6b98aeeeb:
          x: 398
          y: 78
      FAILURE:
        2c232bdd-fd5c-ab65-a8a4-388870ce487c:
          x: 399
          y: 246
