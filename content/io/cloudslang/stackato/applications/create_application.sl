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
#! @description: Creates and deploys an application in Helion Development Platform / Stackato instance.
#!
#! @input host: Helion Development Platform / Stackato host.
#! @input username: Helion Development Platform / Stackato username.
#! @input password: Helion Development Platform / Stackato password.
#! @input application_name: name of the application to create.
#! @input space_guid: GUID of Helion Development Platform / Stackato space to deploy to.
#! @input proxy_host: Optional - Proxy server used to access Helion Development Platform / Stackato services.
#! @input proxy_port: Optional - Proxy server port used to access Helion Development Platform / Stackato services.
#!                    default: '8080'
#! @input proxy_username: Optional - User name used when connecting to proxy.
#! @input proxy_password: Optional - Proxy server password associated with <proxy_username> input value.
#!
#! @output return_result: Response of the operation in case of success, error message otherwise.
#! @output error_message: Return_result if status_code is not '201'.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: Code returned by the operation.
#! @output application_guid: Application ID.
#!
#! @result SUCCESS: Application on Helion Development Platform / Stackato host was successfully created/deployed.
#! @result GET_AUTHENTICATION_FAILURE: Authentication call failed.
#! @result GET_AUTHENTICATION_TOKEN_FAILURE: Authentication token could not be obtained from authentication call response.
#! @result CREATE_APPLICATION_FAILURE: Application on Helion Development Platform /
#!                                     Stackato host could not be created/deployed.
#! @result GET_APPLICATION_GUID_FAILURE: Application GUID could not be obtained from create call response.
#!!#
########################################################################################################################
namespace: io.cloudslang.stackato.applications

imports:
  stackato: io.cloudslang.stackato
  rest: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: create_application

  inputs:
    - host
    - username
    - password:
        sensitive: true
    - application_name
    - space_guid
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

  workflow:
    - authentication:
        do:
          stackato.get_authentication:
            - host
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - return_result
          - error_message
          - token
        navigate:
          - SUCCESS: create_app
          - GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          - GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE

    - create_app:
        do:
          rest.http_client_post:
            - url: ${'https://' + host + '/v2/apps'}
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - body: ${'{"name":"' + application_name + '","space_guid":"' + space_guid + '","memory":1024,"instances":1}'}
            - headers: "${'Authorization: bearer ' + token}"
            - content_type: 'application/json'
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: get_application_guid
          - FAILURE: CREATE_APPLICATION_FAILURE

    - get_application_guid:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "entity,guid"
        publish:
          - application_guid: ${return_result}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: GET_APPLICATION_GUID_FAILURE

  outputs:
    - return_result
    - error_message: ${return_result if return_code == '-1' or status_code != '201' else ''}
    - return_code
    - status_code
    - application_guid

  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - CREATE_APPLICATION_FAILURE
    - GET_APPLICATION_GUID_FAILURE
