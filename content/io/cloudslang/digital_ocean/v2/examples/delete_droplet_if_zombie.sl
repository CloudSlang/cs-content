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
#!!
#! @description: Deletes a DigitalOcean droplet if it is considered a zombie.
#!
#! @input droplet_id: ID of the droplet as a string value.
#! @input droplet_name: Name of the droplet.
#! @input creation_time_as_string: Creation time (UTC timezone) of the droplet as a string value.
#!                                 Format (used by DigitalOcean): '2015-09-27T18:47:19Z'
#! @input time_to_live: Threshold to compare the droplet's lifetime to (in minutes).
#! @input name_pattern: Regex pattern for zombie droplet names.
#!                      Example: 'ci-([0-9]+)-coreos-([0-9]+)'
#! @input token: Personal access token for DigitalOcean API.
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#! @input proxy_username: Optional - User name used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input connect_timeout: Optional - Time in seconds to wait for a connection to be established.
#!                         (0 represents infinite value)
#! @input socket_timeout: Optional - Time in seconds to wait for data to be retrieved.
#!                        (0 represents infinite value)
#!
#! @result DELETED: Droplet is deleted.
#! @result NOT_DELETED: Droplet is not deleted.
#! @result FAILURE: An error occurred.
#!!#
########################################################################################################################

namespace: io.cloudslang.digital_ocean.v2.examples

imports:
  droplets: io.cloudslang.digital_ocean.v2.droplets
  examples: io.cloudslang.digital_ocean.v2.examples

flow:
  name: delete_droplet_if_zombie

  inputs:
    - droplet_id
    - droplet_name
    - creation_time_as_string
    - time_to_live
    - name_pattern
    - token:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - connect_timeout:
        required: false
    - socket_timeout:
        required: false

  workflow:
    - check_droplet_is_zombie:
        do:
          examples.check_droplet_is_zombie:
            - droplet_name
            - creation_time_as_string
            - time_to_live
            - name_pattern
        navigate:
          - ZOMBIE: delete_droplet
          - NOT_ZOMBIE: NOT_DELETED
          - FAILURE: FAILURE

    - delete_droplet:
        do:
          droplets.delete_droplet:
            - token
            - droplet_id
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - connect_timeout
            - socket_timeout
        navigate:
          - SUCCESS: DELETED
          - FAILURE: FAILURE

  results:
    - DELETED
    - NOT_DELETED
    - FAILURE
