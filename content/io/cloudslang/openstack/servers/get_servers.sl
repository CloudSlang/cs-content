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
#! @description: Retrieves a list of OpenStack servers.
#!
#! @input host: OpenStack machine host
#! @input compute_port: Optional - port used for OpenStack computations - Default: '8774'
#! @input token: OpenStack token obtained after authentication
#! @input tenant_id: OpenStack tenantID obtained after authentication
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#!
#! @output return_result: response of operation
#! @output status_code: normal status_code is 202
#! @output error_message: error message
#!
#! @result SUCCESS: operation succeeded (status_code == '200')
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.openstack.servers

operation:
  name: get_servers

  inputs:
    - host
    - compute_port: '8774'
    - token:
        sensitive: true
    - tenant_id
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        required: false
        private: true
    - proxyPort:
        default: ${get("proxy_port", "")}
        private: true
        required: false
    - headers:
        default: ${'X-AUTH-TOKEN:' + token}
        private: true
    - url:
        default: ${'http://'+ host + ':' + compute_port + '/v2/' + tenant_id + '/servers'}
        private: true
    - method:
        default: 'get'
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-http-client:0.1.88'
    class_name: io.cloudslang.content.httpclient.HttpClientAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - status_code: ${statusCode}
    - error_message: ${returnResult if statusCode != '202' else ''}

  results:
    - SUCCESS : ${'statusCode' in locals() and statusCode == '200'}
    - FAILURE
