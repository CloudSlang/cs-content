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
########################################################################################################################
#!!
#! @description: Creates a checkpoint for a running runc container.
#!
#! @input pre_dump: Perform a pre-dump checkpoint (true/false).
#!                  Example: "false"
#! @input docker_host: The address of the Docker host to checkpoint.
#!                     Example: "192.168.0.1"
#! @input port: The ssh port used by the Docker host.
#! @input username: A user with sufficient privileges to restore the container.
#! @input password: The user's password.
#! @input runc_container: The name of the container to checkpoint.
#!                        Example: "petclinic"
#! @input root_path: The full path to the folder which contains the containers folders.
#!                   Example: "/usr/local/migrate/"
#! @input predump_image_location: The full path to the folder which will contain the container's pre_dump image.
#! @input dump_image_location: The full path  to the folder which will contain the container's dump image.
#!
#! @result SUCCESS: Checkpoint created successfully for the runc container
#! @result RESTORE_DUMP_FAILURE: There was an error while trying to create the dump for t6he runc container
#! @result RESTORE_PRE_DUMP_FAILURE: There was an error while pre-dumnping the runc container
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.runc

imports:
  ssh: io.cloudslang.base.ssh
  comparisons: io.cloudslang.base.comparisons

flow:
  name: restore_container

  inputs:
    - docker_host
    - port: "22"
    - username
    - password
    - runc_container
    - root_path: "/usr/local/migrate"
    - pre_dump: "false"
    - predump_image_location: ${root_path + "/" + runc_container + "/predump"}
    - dump_image_location: ${root_path + "/" + runc_container + "/dump"}
  workflow:
  - check_arguments:
      do:
        comparisons.equals:
          - first: ${pre_dump}
          - second: "true"
      navigate:
          - 'TRUE': restore_pre_dump
          - 'FALSE': restore_dump

  - restore_pre_dump:
      do:
        ssh.ssh_flow:
          - host: ${docker_host}
          - port
          - username
          - password
          - private_key_file
          - command: >
              ${"cd " + root_path + "/" + runc_container + "; nohup docker-runc restore " +
              runc_container + " --image-path ./dump --prev-images-dir ./predump &"}
          - arguments
          - character_set
          - pty
          - timeout
          - close_session
          - agentForwarding
      publish:
          - return_result
      navigate:
          - SUCCESS: SUCCESS
          - FAILURE: RESTORE_PRE_DUMP_FAILURE

  - restore_dump:
      do:
        ssh.ssh_flow:
          - host: ${docker_host}
          - port
          - username
          - password
          - private_key_file
          - command: >
              ${"cd " + root_path + "/" + runc_container + "; nohup docker-runc restore " +
              runc_container + " --image-path ./dump &"}
          - arguments
          - character_set
          - pty
          - timeout
          - close_session
          - agentForwarding
      publish:
          - return_result
      navigate:
          - SUCCESS: SUCCESS
          - FAILURE: RESTORE_DUMP_FAILURE

  results:
    - SUCCESS
    - RESTORE_DUMP_FAILURE
    - RESTORE_PRE_DUMP_FAILURE
