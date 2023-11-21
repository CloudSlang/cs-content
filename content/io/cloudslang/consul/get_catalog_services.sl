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
#! @description: Gets a list of services in a given data center.
#!
#! @input host: Consul agent host.
#! @input consul_port: Optional - Consul agent port.
#!                     Default: '8500'
#! @input datacenter: Optional - Matched to that of agent.
#!                    Default: ''
#!
#! @output return_result: Response of the operation.
#! @output error_message: Return_result if return_code is equal to ': 1' or status_code different than '200'.
#! @output return_code: If return_code is equal to '-1' then there was an error.
#! @output status_code: Normal status code is '200'.
#!
#! @result SUCCESS: Operation succeeded (return_code != '-1' and status_code == '200').
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.consul

operation:
  name: get_catalog_services

  inputs:
    - host
    - consul_port:
        default: '8500'
        required: false
    - datacenter:
        default: ''
        required: false
    - dc:
        default: ${'?dc=' + datacenter if bool(datacenter) else ''}
        required: false
        private: true
    - url:
        default: ${'http://' + host + ':' + consul_port + '/v1/catalog/services' + dc}
        private: true
    - method:
        default: 'get'
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-http-client:0.1.93'
    class_name: io.cloudslang.content.httpclient.HttpClientAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - error_message: ${returnResult if returnCode == '-1' or statusCode != '200' else ''}
    - return_code: ${returnCode}
    - status_code: ${statusCode}

  results:
    - SUCCESS: ${returnCode != '-1' and statusCode == '200'}
    - FAILURE
