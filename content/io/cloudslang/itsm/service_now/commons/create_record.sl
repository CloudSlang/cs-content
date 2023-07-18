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
#! @description: Performs a REST Post request to any ServiceNow table.
#!
#! @input host: required - URL of the ServiceNow instance
#!              Example: 'dev10000.service-now.com'
#! @input protocol: Optional - protocol that is used to send the request
#!                  Valid: https. Obs: ServiceNow uses only this protocol
#!                  Default: https
#! @input auth_type: Optional - type of authentication used to execute the request on the target server
#!                   Valid: 'basic', 'anonymous' (When OAuth token is provided). Obs: ServiceNow uses only these
#!                   Default: 'basic'
#! @input api_version: Optional - servicenow api version to be used for the call
#!                   Valid: 'v1'
#!                   Default: ''
#! @input table_name: required - name of the servicenow table which should be used for the request.
#!                    Example: incident, problem , change
#! @input username: Optional - username used for URL authentication; for NTLM authentication, required format is
#!                  'domain\user'
#! @input password: Optional - password used for URL authentication
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - user name used when connecting to the proxy
#! @input proxy_password: Optional - proxy server password associated with the proxy_username input value
#! @input connect_timeout: Optional - time in seconds to wait for a connection to be established - Default: '0' (infinite)
#! @input socket_timeout: Optional - time in seconds to wait for data to be retrieved - Default: '0' (infinite)
#! @input headers: Optional - list containing the headers to use for the request separated by new line (CRLF);
#!                 header name - value pair will be separated by ":" - Format: According to HTTP standard for
#!                 headers (RFC 2616) - Example: 'Accept:text/plain'
#! @input query_params: Optional - list containing query parameters to append to the URL
#!                      Example: 'parameterName1=parameterValue1&parameterName2=parameterValue2;'
#! @input body: Optional - string to include in the body of the request, in the format accepted by ServiceNow
#!              Example: {'short_description':'Example description','severity':'1','assigned_to':'46c1293aa9fe1981000dc753e75ebeee'}
#! @input content_type: Optional - content type that should be set in the request header, representing the MIME-type of the
#!                      data in the message body - Default: 'application/json'
#!
#! @output return_result: response of the operation in case of success or the error message otherwise
#! @output system_id: system id of the record created
#! @output error_message: return_result if status_code is not contained in interval between '200' and '299'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: status code of the HTTP call
#!
#! @result SUCCESS: record created successfully
#! @result REST_POST_API_CALL_FAILURE: There was an error while running a call on the REST API
#! @result GET_SYSID_FAILURE: There was an error while trying to retrieve SYSID
#!!#
########################################################################################################################

namespace: io.cloudslang.itsm.service_now.commons

imports:
  rest: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: create_record

  inputs:
    - host
    - protocol:
        required: false
        default: "https"
    - auth_type:
        required: false
        default: "basic"
    - api_version:
        required: false
        default: ''
    - table_name
    - username:
        required: false
        default: ''
    - password:
        required: false
        default: ''
        sensitive: true
    - proxy_host:
        required: false
        default: ''
    - proxy_port:
        default: "8080"
        required: false
    - proxy_username:
        required: false
        default: ''
    - proxy_password:
        required: false
        default: ''
        sensitive: true
    - connect_timeout:
        default: "0"
        required: false
    - socket_timeout:
        default: "0"
        required: false
    - headers:
        required: false
        default: ''
    - query_params:
        required: false
        default: ''
    - body:
        required: false
        default: ''
    - content_type:
        default: "application/json"
        required: false
        private: true

  workflow:
    - create_record:
        do:
          rest.http_client_post:
            - url: >
                ${protocol + '://' + host + '/api/now/' + api_version + '/table/' + table_name}
            - auth_type
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - connect_timeout
            - socket_timeout
            - headers
            - query_params
            - body
            - content_type
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: get_sys_id
          - FAILURE: REST_POST_API_CALL_FAILURE

    - get_sys_id:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "result,sys_id"
        publish:
            - system_id: ${return_result}
        navigate:
            - SUCCESS: SUCCESS
            - FAILURE: GET_SYSID_FAILURE

  outputs:
    - system_id
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - REST_POST_API_CALL_FAILURE
    - GET_SYSID_FAILURE
