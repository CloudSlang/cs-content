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
########################################################################################################################
#!!
#! @description: Archives and transfers the image to the destination host.
#!
#! @input pre_dump: Indicates if a predump image should be transferred.
#!                  Example: "false"
#! @input docker_host: The address of the source Docker host.
#! @input destination_host: The address of the target Docker host.
#! @input port: The ssh port used by the Docker hosts.
#! @input username: Docker username.
#! @input password: Docker password.
#! @input runc_container: The name of the container to checkpoint.
#!                        Example: "petclinic"
#! @input target_container: destination container where the image will be transferred.
#! @input root_path: The full path to the folder which contains the containers folders.
#!                   Example: "/usr/local/migrate/"
#! @input predump_image_location: The full path to the folder which will contain the container's pre_dump image.
#! @input dump_image_location: The full path  to the folder which will contain the container's dump image.
#!
#! @result SUCCESS: Image archived and transferred successfully
#! @result PACK_DUMP_FAILURE: DUMP packing failure
#! @result TRANSFER_DUMP_FAILURE: DUMP transfer failure
#! @result DELETE_DUMP_FAILURE: DUMP deletion failure
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.runc.examples

imports:
  ssh: io.cloudslang.base.ssh
  remote_file_transfer: io.cloudslang.base.remote_file_transfer

flow:
  name: transfer_images

  inputs:
    - docker_host
    - destination_host
    - port: "22"
    - username
    - password
    - runc_container
    - target_container
    - root_path: "/usr/local/migrate/"
    - dump_image_location: ${root_path + runc_container + "/dump"}

  workflow:
  - pack_dump:
      do:
        ssh.ssh_flow:
          - host: ${docker_host}
          - port
          - username
          - password
          - private_key_file
          - command: ${"cd " + root_path + "/" + runc_container + "; tar -cf dump.tar dump/*"}
          - arguments
          - character_set
          - pty
          - timeout
          - close_session
          - agentForwarding
      publish:
          - return_result
      navigate:
          - SUCCESS: transfer_dump
          - FAILURE: PACK_DUMP_FAILURE

  - transfer_dump:
      do:
        remote_file_transfer.remote_secure_copy:
          - source_host: ${docker_host}
          - source_path: ${root_path + runc_container + "/dump.tar"}
          - source_port: ${port}
          - source_username: ${username}
          - source_password: ${password}
          - source_private_key_file
          - destination_host
          - destination_path: ${root_path + target_container + "/dump.tar"}
          - destination_port
          - destination_username: ${username}
          - destination_password: ${password}
          - destination_private_key_file
          - known_hosts_policy
          - timeout
      publish:
          - return_result
      navigate:
          - SUCCESS: delete_dump_file
          - FAILURE: TRANSFER_DUMP_FAILURE

  - delete_dump_file:
      do:
        ssh.ssh_flow:
          - host: ${docker_host}
          - port
          - username
          - password
          - private_key_file
          - command: ${"rm " + root_path + runc_container + "/dump.tar"}
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
          - FAILURE: DELETE_DUMP_FAILURE

  results:
    - SUCCESS
    - PACK_DUMP_FAILURE
    - TRANSFER_DUMP_FAILURE
    - DELETE_DUMP_FAILURE
