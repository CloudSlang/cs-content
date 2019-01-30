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
#! @description: Deletes an OpenStack server.
#!
#! @input host: OpenStack machine host.
#! @input compute_port: Optional - Port used for OpenStack computations.
#!                      Default: '8774'
#! @input token: OpenStack token obtained after authentication.
#! @input tenant_id: OpenStack tenantID obtained after authentication.
#! @input server_id: ID of server to be deleted.
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!
#! @output return_result: Response of the operation.
#! @output status_code: Normal status code is '204'.
#! @output error_message: Return_result if status_code != '204'.
#!
#! @result SUCCESS: Operation succeeded (status_code == '204').
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.openstack.servers

operation:
  name: delete_server

  inputs:
    - host
    - compute_port: '8774'
    - token:
        sensitive: true
    - tenant_id
    - server_id
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
        default: ${'http://'+ host + ':' + compute_port + '/v2/' + tenant_id + '/servers/' + server_id}
        private: true
    - method:
        default: 'delete'
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-http-client:0.1.73'
    class_name: io.cloudslang.content.httpclient.HttpClientAction
    method_name: execute

  outputs:
    - return_result: ${'' if 'returnResult' not in locals() else returnResult}
    - status_code: ${statusCode}
    - error_message: ${returnResult if statusCode != '204' else ''}

  results:
    - SUCCESS: ${'statusCode' in locals() and statusCode == '204'}
    - FAILURE
