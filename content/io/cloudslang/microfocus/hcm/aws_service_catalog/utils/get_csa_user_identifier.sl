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
#! @description: This flow retrieves the CSA user identifier for a given user.
#!
#! @input csa_rest_uri: The Rest URI used to connect to the CSA host.
#! @input csa_user: The CSA user for which to retrieve the user identifier.
#! @input auth_type: The type of authentication used by this operation when trying to execute the request on the target server.
#!                   Default 'basic'
#! @input username: The username used to connect to the CSA host.
#! @input password: Password associated with the <username> input to connect to the CSA host.
#! @input proxy_host: Proxy server used to access the web site.
#! @input proxy_port: Proxy server port. Default: '8080'
#! @input proxy_username: Username used when connecting to the proxy.
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#! @input trust_all_roots: Specifies whether to enable weak security over SSL. Default: 'false'
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'.
#!                                 Default: 'strict'
#! @input trust_keystore: Location of the TrustStore file. Format: a URL or the local path to it
#! @input trust_password: Password associated with the trust_keystore file.
#! @input keystore: Location of the KeyStore file.  Format: a URL or the local path to it.
#! @input keystore_password: Password associated with the KeyStore file.
#! @input connect_timeout: Time in seconds to wait for a connection to be established.
#!                         Default: '10'
#! @input socket_timeout: Time in seconds to wait for data to be retrieved (maximum period inactivity between two
#!                        consecutive data packets)
#!                        Default: '0' (infinite timeout)
#! @input use_cookies: Specifies whether to enable cookie tracking or not.
#!                     Default: 'true'
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls.
#!                    Default: 'true'
#!
#! @output user_id: The ID of the CSA user.
#! @output error_message: Return_result when the return_code is non-zero (e.g. network or other failure).
#! @output return_result: The ID of the CSA user.
#! @output return_code: '0' if success, '-1' otherwise.
#!
#! @result FAILURE: Operation failed. The CSA user identifier was not retrieved.
#! @result SUCCESS: Operation succeeded. The CSA user identifier was retrieved.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.hcm.aws_service_catalog.utils
flow:
  name: get_csa_user_identifier
  inputs:
    - csa_rest_uri:
        required: true
    - csa_user:
        required: true
    - auth_type:
        default: basic
        required: false
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
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - keystore:
        required: false
    - keystore_password:
        required: false
        sensitive: true
    - connect_timeout:
        default: '10'
        required: false
    - socket_timeout:
        default: '0'
        required: false
    - use_cookies:
        default: 'true'
        required: false
    - keep_alive:
        default: 'true'
        required: false
  workflow:
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${csa_rest_uri + '/login/Provider/' + csa_user}"
            - auth_type: '${auth_type}'
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
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - keystore: '${keystore}'
            - keystore_password:
                value: '${keystore_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - use_cookies: '${use_cookies}'
            - keep_alive: '${keep_alive}'
            - method: get
        publish:
          - xml_document: '${return_result}'
          - error_message
          - return_result
          - return_code
        navigate:
          - SUCCESS: xpath_query
          - FAILURE: FAILURE
    - xpath_query:
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${xml_document}'
            - xpath_query: /person/id/text()
        publish:
          - user_id: '${selected_value}'
          - error_message
          - return_result
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - user_id: '${user_id}'
    - error_message: '${error_message}'
    - return_result: '${user_id}'
    - return_code: '${return_code}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_action:
        x: 56
        y: 82
        navigate:
          842ad36c-577b-657e-fed4-902b263f1c24:
            targetId: 8afa3c37-1af4-fe7f-9d24-0c54e9089e25
            port: FAILURE
      xpath_query:
        x: 243
        y: 79
        navigate:
          41d72bbb-fa4e-6778-c5aa-e740e24d5014:
            targetId: f0d6c5a2-7e9b-71be-6f8b-5e1a93819e4f
            port: SUCCESS
    results:
      FAILURE:
        8afa3c37-1af4-fe7f-9d24-0c54e9089e25:
          x: 50
          y: 259
      SUCCESS:
        f0d6c5a2-7e9b-71be-6f8b-5e1a93819e4f:
          x: 426
          y: 82
