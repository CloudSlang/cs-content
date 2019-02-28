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
#! @description: Authenticates and retrieves details about a specified Helion Development Platform / Stackato
#!               instance application (filtered by application_name).
#!
#! @input host: Helion Development Platform / Stackato host.
#! @input username: Helion Development Platform / Stackato username.
#! @input password: Helion Development Platform / Stackato password.
#! @input application_name: name of the application to get details about.
#! @input proxy_host: Optional - Proxy server used to access Helion Development Platform / Stackato services.
#! @input proxy_port: Optional - Proxy server port used to access Helion Development Platform / Stackato services.
#!                    default: '8080'
#! @input proxy_username: Optional - User name used when connecting to proxy.
#! @input proxy_password: Optional - Proxy server password associated with <proxy_username> input value.
#!
#! @output return_result: Response of the operation in case of success, error message otherwise.
#! @output error_message: Error message of the operation that failed.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: Code returned by the operation.
#! @output resource_guid: GUID of specified application.
#! @output resource_url: URL of specified application.
#! @output resource_created_at: Date when specified application was created.
#! @output resource_updated_at: Last time when specified application was updated.
#!
#! @result SUCCESS: Details of specified application on Helion Development Platform / Stackato host were
#!                  successfully retrieved.
#! @result GET_AUTHENTICATION_FAILURE: Authentication call failed.
#! @result GET_AUTHENTICATION_TOKEN_FAILURE: Authentication token could not be obtained from authentication call response.
#! @result GET_APPLICATIONS_FAILURE: Get applications call failed.
#! @result GET_APPLICATIONS_LIST_FAILURE: List with applications deployed on Helion Development Platform / Stackato
#!                                        could not be retrieved.
#! @result GET_APPLICATION_DETAILS_FAILURE: Details about a specified Helion Development Platform / Stackato
#!                                          application (filtered by application_name) could not be retrieved.
#!!#
########################################################################################################################

namespace: io.cloudslang.stackato.applications

imports:
  applications: io.cloudslang.stackato.applications
  utils: io.cloudslang.stackato.utils

flow:
  name: get_application_details

  inputs:
    - host
    - username
    - password:
        sensitive: true
    - application_name
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
    - get_applications_step:
        do:
          applications.get_applications:
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
          - return_code
          - status_code
        navigate:
          - SUCCESS: get_application_details
          - GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          - GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          - GET_APPLICATIONS_FAILURE: GET_APPLICATIONS_FAILURE
          - GET_APPLICATIONS_LIST_FAILURE: GET_APPLICATIONS_LIST_FAILURE

    - get_application_details:
        do:
          utils.get_resource_details:
            - json_input: ${return_result}
            - key_name: ${application_name}
        publish:
          - error_message
          - return_code
          - resource_guid
          - resource_url
          - resource_created_at
          - resource_updated_at
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: GET_APPLICATION_DETAILS_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - resource_guid
    - resource_url
    - resource_created_at
    - resource_updated_at

  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_APPLICATIONS_FAILURE
    - GET_APPLICATIONS_LIST_FAILURE
    - GET_APPLICATION_DETAILS_FAILURE
