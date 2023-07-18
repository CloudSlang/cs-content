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
#! @description: Deletes a property value from multiple issues. The issues to be updated can be specified by filter criteria.
#!                
#!               The criteria the filter used to identify eligible issues are:
#!                
#!               entityIds Only issues from this list are eligible.
#!               currentValue Only issues with the property set to this value are eligible.
#!               If both criteria is specified, they are joined with the logical AND: only issues that satisfy both criteria are considered eligible.
#!                
#!               If no filter criteria are specified, all the issues visible to the user and where the user has the EDIT_ISSUES permission for the issue are considered eligible.
#!
#! @input url: URL to which the call is made.
#! @input username: Username used for URL authentication
#! @input password: Password used for URL authentication
#! @input property_key: The key of the property.
#! @input entity_ids: List of issues to perform the bulk delete operation on.
#! @input current_value: The value of properties to perform the bulk operation on.
#! @input proxy_host: Optional - Proxy server used to access the web site.
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
#! @input trust_keystore: Optional - Location of the TrustStore file.
#!                        Format: a URL or the local path to it
#! @input trust_password: Optional -  Password associated with the trust_keystore file.
#! @input connect_timeout: Optional - Time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#! @input socket_timeout: Optional - Time in seconds to wait for data to be retrieved
#!                        Default: '0' (infinite)
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output response_headers: Jira bulk delete issue property response headers
#! @output status_code: 200 - Returned if the request is successful.400 - Returned if the request is invalid.401 - Returned if the authentication credentials are incorrect or missing.
#! @output error_message: Error message
#! @output return_result: Does not return anything on success.
#! @output return_code: 0 - success, -1 - failure
#!
#! @result FAILURE: Execution failed
#! @result SUCCESS: status_code == 200
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.issues.issue_properties
flow:
  name: bulk_delete_issue_property
  inputs:
    - url
    - username:
        required: true
    - password:
        required: true
        sensitive: true
    - property_key
    - entity_ids:
        required: false
    - current_value:
        required: false
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
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${url + '/rest/api/3/issue/properties/' + property_key}"
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
            - response_character_set: utf-8
            - body: "${'{\"entityIds\": [' + (entity_ids if entity_ids is not None else \"\") + '],\"currentValue\": \"' + (current_value if current_value is not None else \"\") + '\"}'}"
            - content_type: application/json
            - request_character_set: utf-8
            - method: delete
            - valid_http_status_codes: '${str(list(range(200, 500)))}'
        publish:
          - return_result: '${return_result}'
          - return_code
          - status_code
          - response_headers
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: test_for_http_error
    - test_for_http_error:
        do:
          io.cloudslang.atlassian.jira.v1.utils.test_for_http_error:
            - return_result: '${return_result}'
        publish:
          - error_message
        navigate:
          - FAILURE: on_failure
  outputs:
    - response_headers: '${response_headers}'
    - status_code: '${status_code}'
    - error_message: '${error_message}'
    - return_result: '${return_result}'
    - return_code: '${return_code}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_action:
        x: 240
        'y': 200
        navigate:
          856afb30-9d91-366c-7a68-1565e37d80c8:
            targetId: 70f668aa-93d0-2a16-254a-384531eef6e7
            port: SUCCESS
      test_for_http_error:
        x: 240
        'y': 360
    results:
      SUCCESS:
        70f668aa-93d0-2a16-254a-384531eef6e7:
          x: 400
          'y': 200
