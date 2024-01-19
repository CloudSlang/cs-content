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
#! @description: This workflow checks whether the volume is in the desired state or not.
#!
#! @input provider_sap: The endpoint to which requests are sent.
#!                      Default: https://ec2.amazonaws.com
#! @input access_key_id: The ID of the secret access key associated with your Amazon AWS or IAM account.
#! @input access_key: The secret access key associated with your Amazon AWS or IAM account.
#! @input volume_id: The id of volume whose state needs to be checked.
#! @input volume_state: The desired state of volume.
#! @input proxy_host: The proxy server used to access the provider services
#!                    Optional
#! @input proxy_port: The proxy server port used to access the provider services.
#!                    Optional
#! @input proxy_username: The proxy server user name.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#!
#! @output return_result: Contains the success message or the exception in case of failure
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise
#! @output exception: Exception if there was an error when executing, empty otherwise
#!
#! @result FAILURE: Error checking the volume state, or the actual state is not the expected one
#! @result SUCCESS: The volume has the expected state.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.volumes

imports:
  volumes: io.cloudslang.amazon.aws.ec2.volumes
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils

flow:
  name: check_volume_state
  inputs:
    - provider_sap: 'https://ec2.amazonaws.com'
    - access_key_id
    - access_key:
        sensitive: true
    - volume_id
    - volume_state
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
    - describe_volume:
        worker_group: '${worker_group}'
        do:
          volumes.describe_volumes:
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
            - volume_ids_string: '${volume_id}'
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
            - string_to_find: '${volume_state}'
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
    - return_result
    - return_code
    - exception

  results:
    - FAILURE
    - SUCCESS

extensions:
  graph:
    steps:
      describe_volume:
        x: 93.02890014648438
        'y': 85.56676483154297
      string_occurrence_counter:
        x: 259
        'y': 87
        navigate:
          142db514-d01c-a100-a4c5-8797fe623bb7:
            targetId: b9df608e-e997-67d3-1059-944677ce597d
            port: SUCCESS
          f75a7e66-88c0-28dd-2fc8-f3b539ab4f77:
            vertices:
              - x: 385
                'y': 209
            targetId: sleep
            port: FAILURE
      sleep:
        x: 255
        'y': 268
        navigate:
          f72c9058-a2c9-5f0d-cb2a-d8fcadf1e59a:
            targetId: 9786a567-5ef3-fa53-5ae0-51de5d24f0e1
            port: SUCCESS
    results:
      FAILURE:
        9786a567-5ef3-fa53-5ae0-51de5d24f0e1:
          x: 420
          'y': 261
      SUCCESS:
        b9df608e-e997-67d3-1059-944677ce597d:
          x: 412
          'y': 92