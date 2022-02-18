#   (c) Copyright 2022 Micro Focus, L.P.
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
#! @description: This flow terminates an instance. If the resources attached to the instance were created with the
#!               attribute delete_on_termination = true, they would be deleted when the instance is terminated,
#!               otherwise they would be only detached.
#!
#! @input provider_sap: AWS endpoint as described here: https://docs.aws.amazon.com/general/latest/gr/rande.html
#!                      Default: 'https://ec2.amazonaws.com'
#! @input access_key_id: ID of the secret access key associated with your Amazon AWS account.
#! @input access_key: Secret access key associated with your Amazon AWS account.
#! @input region: The name of the region.
#! @input instance_id: The ID of the instance to be terminated.
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: RAS_Operator_Path
#!                      Optional
#! @input proxy_host: Proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services.
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxyUsername input value.
#!                        Optional
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Default: 10
#!                          Optional
#! @input polling_retries: The number of retries to check if the instance is stopped.
#!                         Default: 60
#!                         Optional
#!
#! @output return_result: contains the success message or the exception in case of failure
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise
#! @output exception: Exception if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: The server (instance) was successfully terminated
#! @result FAILURE: error terminating instance
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2
imports:
  instances: io.cloudslang.amazon.aws.ec2.instances
flow:
  name: aws_undeploy_instance_v2
  inputs:
    - provider_sap: 'https://ec2.amazonaws.com'
    - access_key_id
    - access_key:
        sensitive: true
    - region
    - instance_id
    - worker_group:
        default: RAS_Operator_Path
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - polling_interval:
        default: '10'
        required: false
    - polling_retries:
        default: '60'
        required: false
  workflow:
    - set_endpoint:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - region: '${region}'
        publish:
          - provider_sap: '${".".join(("https://ec2",region, "amazonaws.com"))}'
        navigate:
          - SUCCESS: describe_instances
          - FAILURE: on_failure
    - describe_instances:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.instances.describe_instances:
            - endpoint: '${provider_sap}'
            - identity: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - instance_ids_string: '${instance_id}'
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: terminate_instances
          - FAILURE: on_failure
    - terminate_instances:
        worker_group: '${worker_group}'
        do:
          instances.terminate_instances:
            - endpoint: '${provider_sap}'
            - identity: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - instance_ids_string: '${instance_id}'
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - FAILURE: on_failure
          - SUCCESS: check_instance_state_v2
    - check_instance_state_v2:
        worker_group:
          value: '${worker_group}'
          override: true
        loop:
          for: 'step in range(0, int(get("polling_retries", 50)))'
          do:
            io.cloudslang.amazon.aws.ec2.instances.check_instance_state_v2:
              - provider_sap: '${provider_sap}'
              - access_key_id: '${access_key_id}'
              - access_key:
                  value: '${access_key}'
                  sensitive: true
              - instance_id: '${instance_id}'
              - instance_state: terminated
              - proxy_host: '${proxy_host}'
              - proxy_port: '${proxy_port}'
              - proxy_username: '${proxy_username}'
              - proxy_password:
                  value: '${proxy_password}'
                  sensitive: true
              - polling_interval: '${polling_interval}'
              - worker_group: '${worker_group}'
          break:
            - SUCCESS
          publish:
            - return_result
            - return_code
            - exception
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result
    - return_code
    - exception
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      set_endpoint:
        x: 100
        'y': 150
      describe_instances:
        x: 400
        'y': 150
      terminate_instances:
        x: 700
        'y': 150
      check_instance_state_v2:
        x: 1000
        'y': 150
        navigate:
          aa87689f-a4cf-a785-5ef0-56fecc6e7b95:
            targetId: 7c1ba9a1-e160-ac97-8ffb-45652629a992
            port: SUCCESS
    results:
      SUCCESS:
        7c1ba9a1-e160-ac97-8ffb-45652629a992:
          x: 1300
          'y': 150

