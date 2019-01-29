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
#! @description: Performs a REST API call to add an embedded cartridge to a specified RedHat OpenShift Online application.
#!
#! @input host: RedHat OpenShift Online host
#! @input username: Optional - RedHat OpenShift Online username
#!                  example: 'someone@mailprovider.com'
#! @input password: Optional - RedHat OpenShift Online password used for authentication
#! @input proxy_host: Optional - proxy server used to access RedHat OpenShift Online web site
#! @input proxy_port: Optional - proxy server port
#!                    default: '8080'
#! @input proxy_username: Optional - user name used when connecting to proxy
#! @input proxy_password: Optional - proxy server password associated with <proxy_username> input value
#! @input domain: name of RedHat OpenShift Online domain in which the application resides
#! @input application_name: RedHat OpenShift Online application name to add cartridge to
#! @input cartridge: name of embedded cartridge to be added
#!                   valid: 'mongodb-2.0', 'cron-1.4', 'mysql-5.1', 'postgresql-8.4', 'haproxy-1.4',
#!                   '10gen-mms-agent-0.1', 'phpmyadmin-3.4', 'metrics-0.1', 'rockmongo-1.1', 'jenkins-client-1.4'
#!
#! @output return_result: response of the operation in case of success, error message otherwise
#! @output error_message: return_result if statusCode is not '201'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by the operation
#!
#! @result SUCCESS: embedded cartridge successfully added to the Openshift application
#! @result FAILURE: There was an error while trying to add the embedded cartridge to the Openshift application
#!!#
########################################################################################################################

namespace: io.cloudslang.openshift.cartridges

imports:
  rest: io.cloudslang.base.http

flow:
  name: add_cartridge

  inputs:
    - host
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - domain
    - application_name
    - cartridge

  workflow:
    - add_cartridge:
        do:
          rest.http_client_post:
            - url: ${'https://' + host + '/broker/rest/domains/' + domain + '/applications/' + application_name + '/cartridges'}
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - content_type: 'application/json'
            - body: ${'{"cartridge":"' + cartridge + '"}'}
            - headers: 'Accept: application/json'
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
