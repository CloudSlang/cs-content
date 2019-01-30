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
#! @description: Retrieves a single Server, identified by ID. The time range for summary data is the last 10 minutes.
#!
#! @input servers_endpoint: New Relic servers API endpoint
#! @input api_key: New Relic REST API key
#! @input server_id: server id
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - Username used when connecting to proxy
#! @input proxy_password: Optional - Proxy server password associated with <proxy_username> input value
#!
#! @output return_result: Response of operation
#! @output status_code: Normal status code is '200'
#! @output return_code: If return_code == -1 then there was an error
#! @output error_message: return_result if return_code == 1 or status_code != '200'
#!
#! @result SUCCESS: Operation succeeded (return_code != '-1' and status_code == '200')
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.new_relic.servers

imports:
  rest: io.cloudslang.base.http

flow:
  name: get_server_details

  inputs:
    - servers_endpoint: "https://api.newrelic.com/v2/servers"
    - api_key:
        sensitive: true
    - server_id
    - proxy_host:
        required: false
        default: ''
    - proxy_port:
        required: false
        default: '8080'
    - proxy_username:
        required: false
        default: ''
    - proxy_password:
        required: false
        default: ''
        sensitive: true

  workflow:
    - list_servers:
        do:
          rest.http_client_get:
            - url: ${servers_endpoint + '/' + server_id + '.json'}
            - headers: ${'X-Api-Key:' + api_key}
            - content_type: "application/json"
            - proxy_host
            - proxy_port
            - proxy_username
        publish:
          - return_result
          - error_message
          - return_code
          - status_code

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
