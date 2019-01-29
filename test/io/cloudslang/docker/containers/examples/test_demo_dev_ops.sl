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
####################################################

namespace: io.cloudslang.docker.containers.examples

imports:
  examples: io.cloudslang.docker.containers.examples
  containers: io.cloudslang.docker.containers

flow:
  name: test_demo_dev_ops

  inputs:
    - docker_host
    - docker_username
    - private_key_file
    - app_port
    - email_host
    - email_port
    - email_sender
    - email_recipient
    - proxy_host:
        required: false
    - proxy_port:
        required: false
  workflow:
    - clear_docker_containers:
         do:
           containers.clear_containers:
             - docker_host
             - docker_username
             - private_key_file
         navigate:
           - SUCCESS: execute_demo_dev_ops
           - FAILURE: CLEAR_DOCKER_CONTAINERS_PROBLEM

    - execute_demo_dev_ops:
        do:
          examples.demo_dev_ops:
            - docker_host
            - docker_username
            - private_key_file
            - app_port
            - email_host
            - email_port
            - email_sender
            - email_recipient
            - proxy_host
            - proxy_port
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: EXECUTE_DEMO_DEV_OPS_PROBLEM

  results:
    - SUCCESS
    - CLEAR_DOCKER_CONTAINERS_PROBLEM
    - EXECUTE_DEMO_DEV_OPS_PROBLEM
