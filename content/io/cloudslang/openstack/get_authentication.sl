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
#! @description: Retrieves an unparsed OpenStack authentication token and tenantID.
#!
#! @input host: OpenStack machine host.
#! @input identity_port: Optional - Port used for OpenStack authentication.
#!                       Default: '5000'
#! @input username: OpenStack username.
#! @input password: OpenStack password.
#! @input tenant_name: Name of project on OpenStack.
#! @input proxy_host: Optional - Proxy server used to access web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - Username used when connecting to proxy.
#! @input proxy_password: Optional - Proxy server password associated with <proxy_username> input value.
#!
#! @output return_result: Response of operation.
#! @output status_code: Normal status code is '200'.
#! @output return_code: If return_code == -1 then there was an error.
#! @output error_message: Return_result if return_code == -1 or status_code != '200'.
#!
#! @result SUCCESS: The operation executed successfully, the 'return_code' is 0 and 'status_code' is 200.
#! @result FAILURE: The operation could not be executed, the value of the 'return_code' is different than 0 or the
#!                  'status_code' is different than 200.
#!!#
########################################################################################################################

namespace: io.cloudslang.openstack

operation:
  name: get_authentication

  inputs:
    - host
    - identity_port: '5000'
    - username
    - password:
        sensitive: true
    - tenant_name
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - proxyHost:
        default: ${get("proxy_host", "")}
        required: false
        private: true
    - proxyPort:
        default: ${get("proxy_port", "8080"}
        private: true
    - proxyUsername:
        default: ${get("proxy_username", "")}
        required: false
        private: true
    - proxyPassword:
        default: ${get("proxy_password", "")}
        required: false
        private: true
        sensitive: true
    - url:
        default: ${'http://'+ host + ':' + identity_port + '/v2.0/tokens'}
        private: true
    - body:
        default: >
          ${'{"auth": {"tenantName": "' + tenant_name +
          '","passwordCredentials": {"username": "' + username +
          '", "password": "' + password + '"}}}'}
        private: true
        sensitive: true
    - method:
        default: 'post'
        private: true
    - contentType:
        default: 'application/json'
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-http-client:0.1.73'
    class_name: io.cloudslang.content.httpclient.HttpClientAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - status_code: ${'' if 'statusCode' not in locals() else statusCode}
    - return_code: ${returnCode}
    - error_message: ${returnResult if returnCode == '-1' or statusCode != '200' else ''}

  results:
    - SUCCESS: ${'statusCode' in locals() and returnCode != '-1' and statusCode == '200'}
    - FAILURE
