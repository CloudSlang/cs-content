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
#
########################################################################################################################
#!!
#! @description: Deletes all droplets considered as zombies.
#!               A droplet is considered zombie if its name matches a given pattern and its
#!               lifetime exceeds a given value.
#!
#! @input time_to_live: Optional - Threshold in minutes to compare the droplet's lifetime to as number or string.
#!                      Default: 150 minutes (2.5 hours)
#! @input name_pattern: Optional - Regex pattern for zombie droplet names.
#!                      Default: 'ci-([0-9]+)-coreos-([0-9]+)'
#! @input token: Personal access token for DigitalOcean API.
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#! @input proxy_username: Optional - User name used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input connect_timeout: Optional - Time in seconds to wait for a connection to be established.
#!                        (0 represents infinite value)
#! @input socket_timeout: Optional - Time in seconds to wait for data to be retrieved.
#!                        (0 represents infinite value)
#!
#! @result SUCCESS: Zombie droplets deleted successfully.
#! @result FAILURE: Something went wrong while trying to delete zombie droplets.
#!!#
########################################################################################################################

namespace: io.cloudslang.digital_ocean.v2.examples

imports:
  droplets: io.cloudslang.digital_ocean.v2.droplets
  examples: io.cloudslang.digital_ocean.v2.examples

flow:
  name: delete_zombie_droplets

  inputs:
    - time_to_live: "150"
    - name_pattern: 'ci-([0-9]+)-coreos-([0-9]+)'
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
    - retrieve_droplets_information:
        do:
          droplets.list_all_droplets:
            - token
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - connect_timeout
            - socket_timeout
        publish:
          - droplets

    - process_droplets_information:
        loop:
          for: droplet in droplets
          do:
            examples.delete_droplet_if_zombie:
              - droplet_id: ${str(droplet['id'])}
              - droplet_name: ${droplet['name']}
              - creation_time_as_string: ${str(droplet['created_at'])}
              - time_to_live: ${int(time_to_live)}
              - name_pattern
              - token
              - proxy_host
              - proxy_port
              - proxy_username
              - proxy_password
              - connect_timeout
              - socket_timeout
          navigate:
            - DELETED: SUCCESS
            - NOT_DELETED: SUCCESS
            - FAILURE: FAILURE

  results:
    - SUCCESS
    - FAILURE
