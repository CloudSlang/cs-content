#   Copyright 2024 Open Text
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
#! @description: This operation is used to start a specified instance.
#!
#! @input access_key_id: The Access Key ID associated with your Alibaba cloud account.
#! @input access_key_secret: The Secret ID of the Access Key associated with your Alibaba cloud account.
#! @input proxy_host: Proxy server used to access the Alibaba cloud services.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Alibaba cloud services.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input region_id: Region ID of an instance.
#! @input instance_id: The specified instance ID.
#! @input init_local_disk: Recover to the previous normal status of instance local disk when exceptions occurs.
#!                         Valid values: 'true', 'false'
#!                         Optional
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Default: '10'
#! @input polling_retries: The number of retries to check if the instance is stopped.
#!                         Default: '50'
#!
#! @output output: It contains the state of the instance or the exception in case of failure.
#! @output instance_state: The state of ECS instance.
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The server (instance) has been successfully started.
#! @result FAILURE: An error occured while trying to start the instance.
#!!#
########################################################################################################################

namespace: io.cloudslang.alibaba.ecs

imports:
  instances: io.cloudslang.alibaba.ecs.instances
  strings: io.cloudslang.base.strings

flow:
  name: start_instance
  inputs:
    - access_key_id
    - access_key_secret:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - region_id
    - instance_id
    - init_local_disk:
        required: false
    - polling_interval:
        default: '10'
        required: false
    - polling_retries:
        default: '50'
        required: false

  workflow:
    - get_instance_status:
        do:
          instances.get_instance_status:
            - access_key_id
            - access_key_secret
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - region_id
            - instance_id: '${instance_id}'
        publish:
          - output: 'Instance is already in Running state'
          - return_code
          - exception
          - instance_status: '${instance_status}'

    - start_instance:
        do:
          instances.start_instance:
            - access_key_id
            - access_key_secret
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - region_id
            - init_local_disk
            - instance_id: '${instance_id}'
        publish:
          - output: '${return_result}'
          - return_code
          - exception
        navigate:
          - SUCCESS: check_instance_state
          - FAILURE: on_failure

    - check_instance_state:
        loop:
          for: 'step in range(0, int(get("polling_retries", 50)))'
          do:
            instances.check_instance_state:
              - access_key_id
              - access_key_secret
              - proxy_host
              - proxy_port
              - proxy_username
              - proxy_password
              - instance_id
              - region_id
              - instance_status: Running
              - polling_interval
          break:
            - SUCCESS
          publish:
            - output
            - return_code
            - exception
            - instance_status: '${instance_status}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure

  outputs:
    - output
    - instance_state: '${instance_status}'
    - return_code
    - exception

  results:
    - SUCCESS
    - FAILURE
