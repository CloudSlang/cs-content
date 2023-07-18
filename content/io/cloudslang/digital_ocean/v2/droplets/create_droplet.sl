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
#! @description: Creates a DigitalOcean droplet.
#!
#! @input name: Human-readable string you wish to use when displaying the Droplet name.
#! @input region: Optional - Unique slug identifier for the region that you wish to deploy in.
#!                Default: 'ams3'
#! @input size: Unique slug identifier for the size that you wish to select for this Droplet.
#!              Default: '512mb'
#! @input image: ID or slug identifier of the base image for your droplet.
#! @input ssh_keys: Optional - Array containing the IDs of the SSH keys
#!                  that you wish to embed in the Droplet's root account upon creation.
#! @input backups: Optional - Boolean indicating whether automated backups should be enabled for the Droplet.
#!                 Automated backups can only be enabled when the Droplet is created.
#!                 Default: 'false'
#! @input ipv6: Optional - Boolean indicating whether IPv6 is enabled on the Droplet.
#!              Default: 'false'
#! @input private_networking: Optional - boolean indicating whether private networking is enabled for the Droplet.
#!                            Default: 'false'
#! @input user_data: Optional - String of the desired User Data for the Droplet. Double quotes (") need to be escaped
#!                    with a backslash (\).
#! @input token: Personal access token for DigitalOcean API.
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#! @input proxy_username: Optional - User name used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input connect_timeout: Optional - Time in seconds to wait for a connection to be established.
#!                        (0 represents infinite value)
#! @input socket_timeout: Optional - Time in seconds to wait for data to be retrieved (0 represents infinite value).
#!
#! @output response: Raw response of the API call.
#! @output droplet_id: ID of the created droplet in case of success, empty in case of failure.
#!
#! @result SUCCESS: Droplet created successfully.
#! @result FAILURE: Something went wrong while trying to create droplet.
#!!#
########################################################################################################################

namespace: io.cloudslang.digital_ocean.v2.droplets

imports:
  rest: io.cloudslang.base.http
  strings: io.cloudslang.base.strings
  json: io.cloudslang.base.json

flow:
  name: create_droplet

  inputs:
    - name
    - region: 'ams3'
    - size: '512mb'
    - image
    - ssh_keys:
        required: false
        sensitive: true
    - backups: "false"
    - ipv6: "false"
    - private_networking: "false"
    - user_data:
        required: false
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
    - ssh_keys_formatted:
        default: ${str(ssh_keys) if ssh_keys else 'null'}
        private: true
    - user_data_formatted:
        default: ${user_data if user_data else 'null'}
        private: true

  workflow:
    - execute_post_request:
        do:
          rest.http_client_post:
            - url: 'https://api.digitalocean.com/v2/droplets'
            - auth_type: 'anonymous'
            - headers: "${'Authorization: Bearer ' + token}"
            - body: >
                ${
                '{ ' +
                '"name": "' + name + '", ' +
                '"region": "' + region + '", ' +
                '"size": "' + size + '", ' +
                '"image": "' + str(image) + '", ' +
                '"ssh_keys": ' + ssh_keys_formatted + ', ' +
                '"backups": ' + str(backups).lower() + ', ' +
                '"ipv6": ' + str(ipv6).lower() + ', ' +
                '"private_networking": ' +  str(private_networking).lower() + ', ' +
                '"user_data": ' + user_data_formatted +
                ' }'
                }
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - content_type: 'application/json'
            - connect_timeout
            - socket_timeout
        publish:
          - response: ${return_result}
          - status_code

    - check_result:
        do:
          strings.string_equals:
            - first_string: '202'
            - second_string: ${str(status_code)}

    - extract_droplet_id:
        do:
          json.get_value:
            - json_input: ${ response }
            - json_path: "droplet,id"
        publish:
          - droplet_id: ${return_result}

  outputs:
    - response
    - droplet_id: ${droplet_id if droplet_id else ''}
