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
#! @description: Renames a server
#!
#! @input servers_endpoint: New Relic servers API endpoint
#! @input api_key: New Relic REST API key
#! @input server_id: server id
#! @input server_name: new server name
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - username used when connecting to proxy
#! @input proxy_password: Optional - proxy server password associated with <proxy_username> input value
#!
#! @output return_result: response of operation
#! @output status_code: normal status code is '200'
#! @output return_code: if return_code == -1 then there was an error
#! @output error_message: return_result if return_code == 1 or status_code != '200'
#!
#! @result SUCCESS: operation succeeded (return_code != '-1' and status_code == '200')
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.new_relic.servers

imports:
  json: io.cloudslang.base.json
  rest: io.cloudslang.base.http

flow:
  name: update_server_name

  inputs:
    - servers_endpoint: "https://api.newrelic.com/v2/servers"
    - api_key:
        sensitive: true
    - server_id
    - server_name
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
    - add_name:
        do:
          json.add_value:
            - json_input: '{"server":{"name":"default"}}'
            - json_path: "server,name"
            - value: ${server_name}
        publish:
          - body_json: ${return_result}
          - error_message
          - return_code

    - update_server_name:
        do:
          rest.http_client_put:
            - url: ${servers_endpoint + '/' + server_id + '.json'}
            - proxy_host
            - proxy_port
            - proxy_username
            - porxy_password
            - headers: ${'X-Api-Key:' + api_key}
            - content_type: "application/json"
            - body: ${body_json}
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
