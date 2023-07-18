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
#! @description: Deletes unused Docker images if disk space usage is greater than a given value.
#!
#! @input docker_host: Docker machine host
#! @input docker_username: Docker machine username
#! @input docker_password: Optional - Docker machine password
#! @input private_key_file: Optional - absolute path to private key file
#! @input percentage: if disk space is greater than this value then unused images will be deleted - Example: 50%
#! @input timeout: Optional - time in milliseconds to wait for the command to complete - Default: 6000000
#!
#! @output total_amount_of_images_deleted: number of deleted images
#!
#! @result SUCCESS: successful
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.maintenance

imports:
 linux: io.cloudslang.base.os.linux
 images: io.cloudslang.docker.images

flow:
  name: images_maintenance

  inputs:
    - docker_host
    - docker_username
    - docker_password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - percentage
    - timeout: "6000000"

  workflow:
    - check_diskspace:
        do:
          linux.diskspace_health_check:
            - docker_host
            - docker_username
            - docker_password
            - private_key_file
            - percentage
            - timeout
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
          - NOT_ENOUGH_DISKSPACE: clear_unused_images

    - clear_unused_images:
        do:
          images.clear_unused_and_dangling_images:
            - docker_host
            - docker_username
            - docker_password
            - private_key_file
            - timeout
        publish:
          - amount_of_images_deleted: ${ amount_of_images_deleted if 'amount_of_images_deleted' in locals() and amount_of_images_deleted else '0' }
          - amount_of_dangling_images_deleted: >
              ${ amount_of_dangling_images_deleted if 'amount_of_dangling_images_deleted' in locals() and amount_of_dangling_images_deleted else '0' }
          - dangling_images_list_safe_to_delete
          - images_list_safe_to_delete
          - total_amount: ${ str(int(amount_of_images_deleted) + int(amount_of_dangling_images_deleted)) }

  outputs:
    - total_amount_of_images_deleted: ${ '' if 'total_amount' not in locals() else total_amount }
