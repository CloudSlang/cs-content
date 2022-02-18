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
#! @description: Workflow to test docker get_all_images operation.
#! @input host: Docker machine host
#! @input port: Docker machine port
#! @input username: Docker machine username
#! @input password: Docker machine password
#! @input image_name: Docker image name to pull
#! @result SUCCESS: get_all_images performed successfully
#! @result FAILURE: get_all_images finished with an error
#! @result DOWNLOADFAIL: prerequest error - could not download dockerimage
#! @result VERIFYFAILURE: fails ro verify downloaded images
#! @result DELETEFAIL: fails to delete downloaded image
#! @result MACHINE_IS_NOT_CLEAN: prerequest fails - machine is not clean
#! @result FAIL_GET_ALL_IMAGES_BEFORE: fails to verify machine images
#!!#
####################################################
namespace: io.cloudslang.docker.images

imports:
  images: io.cloudslang.docker.images
  strings: io.cloudslang.base.strings
  maintenance: io.cloudslang.docker.maintenance

flow:
  name: test_get_all_images_outputs

  inputs:
    - host
    - port:
        required: false
    - username
    - password
    - image_name
  workflow:
    - clear_docker_host:
       do:
         maintenance.clear_host:
           - docker_host: ${host}
           - port
           - docker_username: ${username}
           - docker_password: ${password}
       navigate:
         - SUCCESS: hello_world_image_download
         - FAILURE: CLEAR_DOCKER_HOST_FAILURE

    - hello_world_image_download:
        do:
          images.pull_image:
            - host
            - port
            - username
            - password
            - image_name
        navigate:
          - SUCCESS: get_all_images
          - FAILURE: DOWNLOADFAIL

    - get_all_images:
        do:
          images.get_all_images:
            - host
            - port
            - username
            - password
        publish:
            - list: ${image_list}
        navigate:
          - SUCCESS: verify_output
          - FAILURE: FAILURE

    - verify_output:
        do:
          strings.string_equals:
            - first_string: ${ image_name }
            - second_string: ${ list }
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: VERIFYFAILURE
  results:
    - SUCCESS
    - CLEAR_DOCKER_HOST_FAILURE
    - FAILURE
    - DOWNLOADFAIL
    - VERIFYFAILURE
