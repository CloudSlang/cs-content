#   (c) Copyright 2014-2017 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: Workflow to test docker get_image_name_from_id.
#! @input host: Docker machine host
#! @input port: Docker machine port
#! @input username: Docker machine username
#! @input password: Docker machine password
#! @input image_id: Docker image ID
#! @result SUCCESS: get_image_name_from_id performed successfully
#! @result FAILURE: get_image_name_from_id finished with an error
#! @result DOWNLOADFAIL: prerequest error - could not download dockerimage
#! @result VEFIFYFAILURE: fails ro verify downloaded images
#! @result MACHINE_IS_NOT_CLEAN: prerequest fails - machine is not clean
#! @result FAIL_GET_ALL_IMAGES_BEFORE: fails to verify machine images
#!!#
####################################################
namespace: io.cloudslang.docker.images

imports:
  images: io.cloudslang.docker.images
  maintenance: io.cloudslang.docker.maintenance
  strings: io.cloudslang.base.strings

flow:
  name: test_get_image_name_from_id

  inputs:
    - host
    - port:
        required: false
    - username
    - password
    - image_id
  workflow:
    - clear_docker_host_prereqeust:
        do:
          maintenance.clear_host:
            - docker_host: ${ host }
            - port
            - docker_username: ${ username }
            - docker_password: ${ password }
        navigate:
          - SUCCESS: hello_world_image_download
          - FAILURE: MACHINE_IS_NOT_CLEAN

    - hello_world_image_download:
        do:
          images.pull_image:
            - host
            - port
            - username
            - password
            - image_name: "raskin/hello-world"
        navigate:
          - SUCCESS: get_image_name_from_id
          - FAILURE: DOWNLOADFAIL

    - get_image_name_from_id:
        do:
          images.get_image_name_from_id:
            - host
            - port
            - username
            - password
            - image_id
        publish:
            - image_name : ${ image_name }
        navigate:
          - SUCCESS: verify_output
          - FAILURE: FAILURE

    - verify_output:
        do:
          strings.string_equals:
            - first_string: "raskin/hello-world:latest "
            - second_string: ${ image_name }
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: VEFIFYFAILURE

  results:
    - SUCCESS
    - FAILURE
    - DOWNLOADFAIL
    - VEFIFYFAILURE
    - MACHINE_IS_NOT_CLEAN
