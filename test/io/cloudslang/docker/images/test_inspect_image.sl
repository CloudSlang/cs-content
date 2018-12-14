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
#! @description: Workflow to test docker get_all_images operation.
#! @input host: Docker machine host
#! @input port: Docker machine port
#! @input username: Docker machine username
#! @input password: Docker machine password
#! @input image_name: Docker image name to inspect
#! @result SUCCESS: get_all_images performed successfully
#! @result FAILURE: get_all_images finished with an error
#! @result DOWNLOAD_FAILURE: prerequest error - could not download dockerimage
#! @result VERIFY_FAILURE: fails ro verify downloaded images
#! @result MACHINE_IS_NOT_CLEAN: prerequest fails - machine is not clean
#!!#
####################################################
namespace: io.cloudslang.docker.images

imports:
  images: io.cloudslang.docker.images
  strings: io.cloudslang.base.strings
  maintenance: io.cloudslang.docker.maintenance

flow:
  name: test_inspect_image

  inputs:
    - host
    - port:
        required: false
    - username
    - password
    - image_name
  workflow:
    - clear_docker_host_prereqeust:
        do:
         maintenance.clear_host:
           - docker_host: ${ host }
           - port
           - docker_username: ${ username }
           - docker_password: ${ password }
        navigate:
         - SUCCESS: pull_image
         - FAILURE: MACHINE_IS_NOT_CLEAN

    - pull_image:
        do:
          images.pull_image:
            - host
            - port
            - username
            - password
            - image_name
        navigate:
          - SUCCESS: inspect_image
          - FAILURE: DOWNLOAD_FAILURE

    - inspect_image:
        do:
          images.inspect_image:
            - host
            - port
            - username
            - password
            - image_name
        publish:
            - standard_out
        navigate:
          - SUCCESS: verify_output
          - FAILURE: FAILURE

    - verify_output:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${ standard_out }
            - string_to_find: "/hello"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: VERIFY_FAILURE

  results:
    - SUCCESS
    - FAILURE
    - DOWNLOAD_FAILURE
    - VERIFY_FAILURE
    - MACHINE_IS_NOT_CLEAN
