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
#
########################################################################################################################

namespace: io.cloudslang.docker.images

imports:
  images: io.cloudslang.docker.images
  containers: io.cloudslang.docker.containers
  strings: io.cloudslang.base.strings
  maintenance: io.cloudslang.docker.maintenance

flow:
  name: test_clear_unused_images

  inputs:
    - host
    - port:
        required: false
    - username
    - password
    - image_name1
    - image_name2

  workflow:

    - clear_docker_host_prereqeust:
        do:
          maintenance.clear_host:
            - docker_host: ${ host }
            - port
            - docker_username: ${ username }
            - docker_password: ${ password }
        navigate:
          - SUCCESS: pull_image1
          - FAILURE: PREREQUST_MACHINE_IS_NOT_CLEAN

    - pull_image1:
        do:
          images.pull_image:
            - host
            - port
            - username
            - password
            - image_name: ${ image_name1 }
        navigate:
          - SUCCESS: pull_image2
          - FAILURE: FAIL_PULL_IMAGE

    - pull_image2:
        do:
          images.pull_image:
            - host
            - port
            - username
            - password
            - image_name: ${ image_name2 }
        navigate:
          - SUCCESS: run_container
          - FAILURE: FAIL_PULL_IMAGE

    - run_container:
        do:
          containers.run_container:
            - host
            - port
            - username
            - password
            - container_name: "test_container"
            - image_name: ${ image_name1 }
        navigate:
          - SUCCESS: get_list
          - FAILURE: FAIL_RUN_CONTAINER

    - get_list:
        do:
          images.get_used_images:
            - host
            - port
            - username
            - password
        publish:
          - image_list: ${image_list.strip()}
        navigate:
          - SUCCESS: verify_used_images
          - FAILURE: FAIL_GET_USED_IMAGES

    - verify_used_images:
        do:
          strings.string_equals:
            - first_string: ${ image_name1 }
            - second_string: ${ image_list }
        navigate:
          - SUCCESS: clear_unused_images
          - FAILURE: VERIFY_USED_IMAGES_FAILURE

    - clear_unused_images:
        do:
          images.clear_unused_images:
            - docker_host: ${ host }
            - docker_username: ${ username }
            - docker_password: ${ password }
            - port
        publish:
          - images_list_safe_to_delete
          - amount_of_images_deleted
          - used_images_list
          - all_parent_images: ${updated_all_parent_images}
        navigate:
          - SUCCESS: verify_amount_of_images_deleted_output
          - FAILURE: FAILURE

    - verify_amount_of_images_deleted_output:
        do:
          strings.string_equals:
            - first_string: ${ amount_of_images_deleted }
            - second_string: '1'
        navigate:
          - SUCCESS: get_all_images
          - FAILURE: AMOUNT_OF_IMAGES_DELETED_IS_WRONG

    - get_all_images:
        do:
          images.get_all_images:
            - host
            - port
            - username
            - password
        publish:
          - image_list: ${image_list.strip()}
        navigate:
          - SUCCESS: validate_image_list
          - FAILURE: FAIL_GET_ALL_IMAGES

    - validate_image_list:
        do:
          strings.string_equals:
            - first_string: ${ image_name1 }
            - second_string: ${ image_list }
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: VERIFY_FAILURE
  results:
    - SUCCESS
    - PREREQUST_MACHINE_IS_NOT_CLEAN
    - FAIL_PULL_IMAGE
    - FAIL_RUN_CONTAINER
    - FAIL_GET_USED_IMAGES
    - VERIFY_USED_IMAGES_FAILURE
    - FAILURE
    - AMOUNT_OF_IMAGES_DELETED_IS_WRONG
    - FAIL_GET_ALL_IMAGES
    - VERIFY_FAILURE
