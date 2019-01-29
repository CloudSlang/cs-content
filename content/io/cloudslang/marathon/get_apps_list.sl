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
#! @description: Retrieves a list of Marathon apps.
#!
#! @input marathon_host: Marathon agent host
#! @input marathon_port: Optional - Marathon agent port - Default: 8080
#! @input cmd: Optional - filter apps to only those whose commands contain cmd
#! @input embed: Optional - embeds nested resources that match supplied path - Default: none
#!               Valid: "apps.tasks" App's tasks are not embedded in response by default "apps.failures".
#!               App's last failures are not embedded in response by default
#! @input proxy_host: Optional - proxy host
#! @input proxy_port: Optional - proxy port
#!
#! @output return_result: response of the operation
#! @output error_message: return_result if return_code == -1 or status_code != 200
#! @output return_code: if return_code == -1 then there was an error
#! @output status_code: normal status code is 200
#!
#! @result SUCCESS: operation succeeded (return_code != '-1' and status_code == '200')
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.marathon

operation:
  name: get_apps_list

  inputs:
    - marathon_host
    - marathon_port:
        default: "8080"
        required: false
    - cmd:
        required: false
    - embed:
        default: "none"
        required: false
    - url:
        default: ${'http://' + marathon_host + ':' + marathon_port + '/v2/apps?embed=' + embed}
        private: true
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get('proxy_host', None)}
        required: false
        private: true
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get('proxy_port', None)}
        required: false
        private: true
    - method:
        default: "get"
        private: true
    - contentType:
        default: "application/json"
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-http-client:0.1.73'
    class_name: io.cloudslang.content.httpclient.HttpClientAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - error_message: ${returnResult if returnCode == '-1' or statusCode != '200' else ''}
    - return_code: ${returnCode}
    - status_code: ${get('statusCode', None)}

  results:
    - SUCCESS: ${returnCode != '-1' and statusCode == '200'}
    - FAILURE
