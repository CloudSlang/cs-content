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
#! @description: Checks if the disk space on a Linux machine is less than a given percentage.
#!
#! @input docker_host: Docker machine host
#! @input docker_username: Docker machine username
#! @input docker_password: Optional - Docker machine password
#! @input private_key_file: Optional - path to the private key file
#! @input percentage: Example: 50%
#! @input timeout: Optional - time in milliseconds to wait for the command to complete
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @result SUCCESS: disk space less than percentage
#! @result FAILURE: error occurred
#! @result NOT_ENOUGH_DISKSPACE: disk space more than percentage
#!!#
########################################################################################################################

namespace: io.cloudslang.base.os.linux

imports:
 base_comparisons: io.cloudslang.base.comparisons
 linux: io.cloudslang.base.os.linux

flow:
  name: diskspace_health_check
  inputs:
    - docker_host
    - docker_username
    - docker_password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - percentage
    - timeout:
        required: false
    - worker_group:
        required: false

  workflow:
    - validate_linux_machine_ssh_access:
        worker_group: ${get('worker_group', 'RAS_Operator_Path')}
        do:
          linux.validate_linux_machine_ssh_access:
            - host: ${ docker_host }
            - username: ${ docker_username }
            - password: ${ docker_password }
            - private_key_file
            - timeout

    - check_disk_space:
        worker_group: ${get('worker_group', 'RAS_Operator_Path')}
        do:
          linux.check_linux_disk_space:
            - host: ${ docker_host }
            - username: ${ docker_username }
            - password: ${ docker_password }
            - private_key_file
            - timeout
        publish:
          - disk_space

    - check_availability:
        worker_group: ${get('worker_group', 'RAS_Operator_Path')}
        do:
          base_comparisons.less_than_percentage:
            - first_percentage: ${ disk_space.replace("\n", "") }
            - second_percentage: ${ percentage }
        navigate:
          - LESS: SUCCESS
          - MORE: NOT_ENOUGH_DISKSPACE
          - FAILURE: FAILURE

  results:
    - SUCCESS
    - FAILURE
    - NOT_ENOUGH_DISKSPACE
