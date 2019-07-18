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
#! @description: Performs a REST API call to create a new RedHat OpenShift Online application.
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
#! @input domain: name of RedHat OpenShift Online domain in which application will be created
#!                note: domain must be created first in order to create applications
#! @input application_name: RedHat OpenShift Online application name
#! @input cartridge: list with names of frameworks to be added in RedHat OpenShift Online application
#!                   example: ['ruby-1.8']
#! @input scale: Optional - mark RedHat OpenShift Online application as scalable
#!               default: False
#! @input gear_profile: Optional - size of the gear
#!                      default: 'small'
#! @input initial_git_url: Optional - URL to Git source repository
#!
#! @output return_result: response of the operation in case of success, error message otherwise
#! @output error_message: return_result if status_code is not '201'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by the operation
#!
#! @result SUCCESS: new RedHat OpenShift Online application was created successfully
#! @result CONVERT_LIST_TO_STRING_FAILURE
#! @result CREATE_APPLICATION_FAILURE
#!!#
########################################################################################################################

namespace: io.cloudslang.openshift.applications

imports:
  rest: io.cloudslang.base.http
  list: io.cloudslang.base.lists

flow:
  name: create_application

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
    - scale:
        default: "False"
        required: false
    - gear_profile:
        default: 'small'
        required: false
    - initial_git_url:
        required: false

  workflow:
    - cartridge_str:
        do:
          list.convert_list_to_string:
            - list: ${cartridge}
            - double_quotes: "True"
            - result_delimiter: ','
            - result_to_lowercase: "True"
        publish:
          - cartridge_str: ${result}
        navigate:
          - SUCCESS: create_app

    - create_app:
        do:
          rest.http_client_post:
            - url: ${'https://' + host + '/broker/rest/domains/' + domain + '/applications'}
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - content_type: 'application/json'
            - application_name_string: ${'"name":"' + application_name + '",'}
            - cartridge_string: ${'"cartridge":[' + cartridge_str + ']'}
            - scale_string: ${',"scale":' + str(scale).lower()}
            - gear_profile_string: ${',"gear_profile":"' + gear_profile + '"' if gear_profile else ''}
            - initial_git_url_string: ${',"initial_git_url":"' + initial_git_url + '"' if initial_git_url else ''}
            - body: ${'{' + application_name_string + cartridge_string + gear_profile_string + initial_git_url_string + scale_string + '}'}
            - headers: 'Accept: application/json'
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CREATE_APPLICATION_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - CREATE_APPLICATION_FAILURE
