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
############################################################################################################################################################################
#!!
#! @description: This flow verifies that delete_zombie_droplets workflow works correctly.
#!               Logical steps:
#!               - create zombie droplet
#!               - wait for droplet startup
#!               - call delete_zombie_droplets
#!               - validate zombie droplet is removed
#! @input time_to_live: threshold to compare the droplet's lifetime to (in minutes)
#! @input droplet_name: name of the droplet used in this test
#! @input image: image the droplet is created from
#! @input ssh_keys: array containing the IDs of the SSH keys
#! @input token: personal access token for DigitalOcean API
#! @input proxy_host: Optional - proxy server used to access the web site
#! @input proxy_port: Optional - proxy server port
#! @input proxy_username: Optional - user name used when connecting to the proxy
#! @input proxy_password: Optional - proxy server password associated with the proxy_username input value
#!!#
########################################################################################################

namespace: io.cloudslang.digital_ocean.v2.examples

imports:
  examples: io.cloudslang.digital_ocean.v2.examples
  droplets: io.cloudslang.digital_ocean.v2.droplets
  droplet_utils: io.cloudslang.digital_ocean.v2.utils

flow:
  name: test_delete_zombie_droplets

  inputs:
    - time_to_live
    - droplet_name
    - image
    - ssh_keys
    - token
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false

  workflow:
    - create_zombie_stub:
        do:
          droplets.create_droplet:
            - name: ${droplet_name}
            - image
            - ssh_keys
            - token
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - droplet_id
        navigate:
          - SUCCESS: wait_for_create_event
          - FAILURE: CREATE_DROPLET_FAILURE

    - wait_for_create_event:
        do:
          droplet_utils.wait_for_status_to_change:
            - droplet_id
            - status: 'new'
            - token
            - timeout: '600'
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        navigate:
          - SUCCESS: remove_zombie_droplets
          - DROPLET_NOT_FOUND: WAIT_FOR_CREATE_EVENT_DROPLET_NOT_FOUND
          - FAILURE: WAIT_FOR_CREATE_EVENT_FAILURE
          - TIMEOUT: WAIT_FOR_CREATE_EVENT_TIMEOUT

    - remove_zombie_droplets:
        do:
          examples.delete_zombie_droplets:
            - time_to_live
            - name_pattern: ${droplet_name}
            - token
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        navigate:
          - SUCCESS: wait_for_remove_event
          - FAILURE: REMOVE_ZOMBIE_DROPLETS_FAILURE

    - wait_for_remove_event:
        do:
          droplet_utils.wait_for_status_to_change:
            - droplet_id
            - status: 'active'
            - token
            - timeout: '600'
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        navigate:
          - SUCCESS: WAIT_FOR_REMOVE_EVENT_UNEXPECTED_RESULT
          - DROPLET_NOT_FOUND: SUCCESS
          - FAILURE: WAIT_FOR_REMOVE_EVENT_FAILURE
          - TIMEOUT: WAIT_FOR_REMOVE_EVENT_TIMEOUT
  results:
    - SUCCESS
    - CREATE_DROPLET_FAILURE
    - WAIT_FOR_CREATE_EVENT_DROPLET_NOT_FOUND
    - WAIT_FOR_CREATE_EVENT_FAILURE
    - WAIT_FOR_CREATE_EVENT_TIMEOUT
    - REMOVE_ZOMBIE_DROPLETS_FAILURE
    - WAIT_FOR_REMOVE_EVENT_UNEXPECTED_RESULT
    - WAIT_FOR_REMOVE_EVENT_FAILURE
    - WAIT_FOR_REMOVE_EVENT_TIMEOUT
