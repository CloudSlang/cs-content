#   (c) Copyright 2022 Micro Focus, L.P.
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
#! @description: Returns details of projects, issue types within projects, and, when requested, the create screen fields for each issue type for the user.
#!
#! @input url: URL to which the call is made.
#! @input username: Username used for URL authentication
#! @input password: Password used for URL authentication
#! @input project_ids: List of project IDs. This parameter accepts a comma-separated list.
#! @input project_keys: List of project keys. This parameter accepts a comma-separated list.
#! @input issuetype_ids: List of issue type IDs. This parameter accepts a comma-separated list.
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input issuetype_names: List of issue type names. This parameter accepts a comma-separated list.
#! @input expand: Use expand to include additional information about issue metadata in the response. This parameter accepts projects.issuetypes.fields, which returns information about the fields in the issue creation screen for each issue type. Fields hidden from the screen are not returned. Use the information to populate the fields and update fields in Create issue and Create issues.
#! @input proxy_port: Optional - Proxy port used to access the web site.
#! @input proxy_username: Optional - Proxy usernameused to access the web site.
#! @input proxy_password: Optional - Proxy password used to access the web site.
#! @input tls_version: Optional - This input allows a list of comma separated values of the specific protocols to be used.
#!                     Valid: SSLv3, TLSv1, TLSv1.1, TLSv1.2.
#!                     Default: 'TLSv1.2'
#! @input allowed_cyphers: Optional - A comma delimited list of cyphers to use. The value of this input will be ignored
#!                         if 'tlsVersion' does not contain 'TLSv1.2'.This capability is provided “as is”, please see product
#!                         documentation for further security considerations. In order to connect successfully to the target
#!                         host, it should accept at least one of the following cyphers. If this is not the case, it is the
#!                         user's responsibility to configure the host accordingly or to update the list of allowed cyphers.
#!                         Default: TLS_DHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
#!                         TLS_DHE_RSA_WITH_AES_256_CBC_SHA256,TLS_DHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,
#!                         TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
#!                         TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_256_CBC_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA256
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#! @input trust_keystore: Optional - The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Default value: ''
#! @input trust_password: Optional - The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input connect_timeout: Optional - Time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#! @input socket_timeout: Optional - Time in seconds to wait for data to be retrieved
#!                        Default: '0' (infinite)
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output response_headers: Jira get create issue metadata response headers
#! @output status_code: 200 - Returned if the request is successful.
#!                      401 - Returned if the authentication credentials are incorrect or missing.
#! @output error_message: Error message
#! @output return_result: Json containing data regarding create issue metadata
#! @output return_code: 0 - success, -1 - failure
#! @output project_ids_list: List of project ids delimited by ,
#!
#! @result SUCCESS: status_code == 200
#! @result FAILURE: Execution failed
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.issues
flow:
  name: get_create_issue_metadata
  inputs:
    - url
    - username:
        required: true
    - password:
        required: true
        sensitive: true
    - project_ids:
        required: false
    - project_keys:
        required: false
    - issuetype_ids:
        required: false
    - proxy_host:
        required: false
    - issuetype_names:
        required: false
    - expand:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - tls_version:
        required: false
    - allowed_cyphers:
        required: false
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
        required: false
    - trust_keystore:
        default: "${get_sp('io.cloudslang.base.http.trust_keystore')}"
        required: false
    - trust_password:
        default: "${get_sp('io.cloudslang.base.http.trust_password')}"
        required: false
        sensitive: true
    - connect_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
        required: false
    - worker_group:
        required: false
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${url + '/rest/api/3/issue/createmeta'}"
            - auth_type: basic
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - tls_version: '${tls_version}'
            - allowed_cyphers: '${allowed_cyphers}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - headers: 'Accept: application/json'
            - query_params: |-
                ${(
                    ('projectIds=' + project_ids + '&' if project_ids is not None else '') +
                    ('projectKeys=' + project_keys + '&' if project_keys is not None else '') +
                    ('issuetypeIds=' + issuetype_ids + '&' if issuetype_ids is not None else '') +
                    ('issuetypeNames=' + issuetype_names + '&' if issuetype_names is not None else '') +
                    ('expand=' + expand + '&' if expand is not None else '')
                )[:-1] if (
                    ('projectIds=' + project_ids + '&' if project_ids is not None else '') +
                    ('projectKeys=' + project_keys + '&' if project_keys is not None else '') +
                    ('issuetypeIds=' + issuetype_ids + '&' if issuetype_ids is not None else '') +
                    ('issuetypeNames=' + issuetype_names + '&' if issuetype_names is not None else '') +
                    ('expand=' + expand + '&' if expand is not None else '')
                ) != '' else ''}
            - content_type: application/json
            - worker_group: '${worker_group}'
        publish:
          - return_result: '${return_result}'
          - return_code: '${return_code}'
          - status_code: '${status_code}'
          - response_headers: '${response_headers}'
          - error_message
        navigate:
          - SUCCESS: get_ids_from_json_array_1
          - FAILURE: test_for_http_error
    - test_for_http_error:
        do:
          io.cloudslang.atlassian.jira.v1.utils.test_for_http_error:
            - return_result: '${return_result}'
        publish:
          - error_message
        navigate:
          - FAILURE: on_failure
    - get_ids_from_json_array_1:
        do:
          io.cloudslang.atlassian.jira.v1.utils.get_ids_from_json_array:
            - data_json: '${return_result}'
            - array_name: projects
        publish:
          - project_ids_list: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - response_headers: '${response_headers}'
    - status_code: '${status_code}'
    - error_message: "${error_message if error_message != '' else (return_result if status_code != '200' else '')}"
    - return_result: "${return_result if status_code == '200' else ''}"
    - return_code: '${return_code}'
    - project_ids_list: '${project_ids_list}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      http_client_get:
        x: 120
        'y': 200
      test_for_http_error:
        x: 120
        'y': 360
      get_ids_from_json_array_1:
        x: 280
        'y': 200
        navigate:
          eb83d23f-9a52-647b-2727-8a71e72246cd:
            targetId: 70f668aa-93d0-2a16-254a-384531eef6e7
            port: SUCCESS
    results:
      SUCCESS:
        70f668aa-93d0-2a16-254a-384531eef6e7:
          x: 400
          'y': 200
