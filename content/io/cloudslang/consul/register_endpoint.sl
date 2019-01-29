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
#! @description: Directly registers or updates entries in the catalog.
#!
#! @input host: Consul agent host.
#! @input consul_port: Optional - Consul agent host port.
#!                     Default: '8500'
#! @input node: Node name.
#! @input address: Node host.
#! @input datacenter: Optional - Matched to that of agent.
#!                    Default: ''
#! @input service: Optional - If Service key is provided, then service will also be registered.
#!                 Default: ''
#! @input check: Optional - If the Check key is provided, then a health check will also be registered.
#!               Default: ''
#!
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
  name: register_endpoint

  inputs:
    - host
    - consul_port:
        default: '8500'
        required: false
    - node
    - address
    - datacenter:
        default: ''
        required: false
    - service:
        default: ''
        required: false
    - check:
        default: ''
        required: false

  workflow:
    - parse_register_endpoint_request:
        do:
          consul.parse_register_endpoint_request:
            - node
            - address
            - datacenter
            - service
            - check
        publish:
          - json_request

    - send_register_endpoint_request:
        do:
          consul.send_register_endpoint_request:
            - host
            - consul_port
            - json_request
        publish:
          - error_message

  outputs:
    - error_message

  results:
    - SUCCESS
    - FAILURE
