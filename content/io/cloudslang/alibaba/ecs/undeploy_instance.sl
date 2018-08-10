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
#! @description: This flow terminates an instance. If the resources attached to the instance, they would be deleted
#!               when the instance is terminated.
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
#! @input region_id: Region ID of an instance. You can call DescribeRegions to obtain the latest region list.
#! @input instance_id: The ID of the instance to be terminated.
#! @input force_stop: Whether to force shutdown upon device restart.
#!                    Value range:true: force the instance to shut down, false: the instance shuts down normally
#!                    Default: false
#!                    Optional
#! @input confirm_stop: Whether to stop an I1 ECS instance or not.  A required parameter for I1 type family instance, it
#!                      only takes effect when the instance is of I1 type family.
#!                      Valid values: true, false
#!                      Default value: false
#!                      Optional
#! @input stopped_mode: Whether a VPC ECS instance is billed after it is stopped or not.
#!                      Optional value: KeepChargingAfter you enable the feature of No fees for stopped instances for a
#!                      VPC instance, you can set StoppedMode=KeepCharging to disable the feature, the ECS instance will
#!                      be billed after it is stopped,  and its resource and Internet IP address are reserved.
#!                      Optional
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Default: 10
#! @input polling_retries: The number of retries to check if the instance is stopped.
#!                         Default: 50
#!
#! @output return_result: The authentication token in case of success, or an error message in case of failure.
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise
#! @output exception: Exception if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: The server (instance) has been successfully terminated
#! @result FAILURE: An error occur while trying to delete the instance
#!!#
########################################################################################################################

namespace: io.cloudslang.alibaba.ecs

imports:
  strings: io.cloudslang.base.strings
  instances: io.cloudslang.alibaba.ecs.instances

flow:
  name: undeploy_instance
  inputs:
    - access_key_id
    - access_key_secret:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - region_id
    - instance_id
    - force_stop:
        required: false
    - confirm_stop:
        required: false
    - stopped_mode:
        required: false
    - polling_interval:
        required: false
    - polling_retries:
        required: false

  workflow:
    - get_instance_Status:
        do:
          instances.get_instance_status_:
            - access_key_id
            - access_key_secret
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - region_id
            - instance_id: '${instance_id}'
        publish:
          - return_result
          - return_code
          - exception
          - instance_status_returned: '${instance_status}'
        navigate:
          - SUCCESS: string_occurrence_counter
          - FAILURE: on_failure

    - string_occurrence_counter:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${instance_status_returned}
            - string_to_find: Stopped
        navigate:
          - SUCCESS: delete_instance
          - FAILURE: stop_instance

    - delete_instance:
        do:
          instances.delete_instance:
            - access_key_id
            - access_key_secret
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - region_id
            - instance_id: '${instance_id}'
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure

    - stop_instance:
        do:
          instances.stop_instance:
            - access_key_id
            - access_key_secret
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - region_id
            - instance_id: '${instance_id}'
            - force_stop
            - confirm_stop
            - stopped_mode
            - polling_interval
            - polling_retries
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: delete_instance
          - FAILURE: on_failure

  outputs:
    - return_result
    - return_code
    - exception

  results:
    - SUCCESS
    - FAILURE
