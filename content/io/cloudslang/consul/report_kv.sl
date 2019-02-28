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
#! @description: Retrieves parsed key data.
#!
#! @input host: Consul agent host.
#! @input consul_port: Optional - Consul agent port.
#!                     Default: '8500'
#! @input key_name: Name of key to retrieve.
#!
#! @output decoded: Parsed response.
#! @output key: Key name.
#! @output flags: Key flags.
#! @output create_index: Key create index.
#! @output value: Key value.
#! @output modify_index: Key modify index.
#! @output lock_index: Key lock index.
#! @output error_message: Return_result if there was an error.
#!
#! @result SUCCESS: Parsing was successful (return_code == '0').
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.consul

imports:
  consul: io.cloudslang.consul

flow:
  name: report_kv

  inputs:
    - host
    - consul_port:
        default: "8500"
        required: false
    - key_name

  workflow:
    - retrieve_key:
        do:
          consul.get_kv:
            - key_name
            - host
            - consul_port
        publish:
          - return_result

    - parse_key:
        do:
          consul.parse_key:
            - json_response: ${return_result}
        publish:
          - decoded
          - key
          - flags
          - create_index
          - value
          - modify_index
          - lock_index
          - error_message

  outputs:
    - decoded
    - key
    - flags
    - create_index
    - value
    - modify_index
    - lock_index
    - error_message

  results:
    - SUCCESS
    - FAILURE
