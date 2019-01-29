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
#! @description: Retrieves information about all droplets in a DigitalOcean account.
#!
#! @input token: Personal access token for DigitalOcean API.
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#! @input proxy_username: Optional - User name used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input connect_timeout: Optional - Time in seconds to wait for a connection to be established.
#!                         (0 represents infinite value).
#! @input socket_timeout: Optional - Time in seconds to wait for data to be retrieved.
#!                        (0 represents infinite value).
#!
#! @output response: Raw response of the API call.
#! @output droplets: List of droplet objects - JSON types (object, array) are represented as Python objects
#!                   information can be retrieved in Python style.
#!                   Example: droplet['name']
#!
#! @result SUCCESS: Information about all droplets retrieved successfully.
#! @result FAILURE: Something went wrong while trying to list droplets.
#!!#
########################################################################################################################
namespace: io.cloudslang.digital_ocean.v2.droplets

imports:
  rest: io.cloudslang.base.http
  strings: io.cloudslang.base.strings
  json: io.cloudslang.base.json

flow:
  name: list_all_droplets

  inputs:
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
    - execute_get_request:
        do:
          rest.http_client_get:
            - url: ${'https://api.digitalocean.com/v2/droplets'}
            - auth_type: 'anonymous'
            - headers: "${'Authorization: Bearer ' + token}"
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
            - first_string: '200'
            - second_string: ${str(status_code)}

    - extract_droplets_information:
        do:
          json.get_value:
            - json_input: ${ response }
            - json_path: "droplets"
        publish:
          - droplets: ${return_result}

  outputs:
    - response
    - droplets
