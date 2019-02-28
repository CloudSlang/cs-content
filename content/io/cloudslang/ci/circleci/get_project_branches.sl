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
#! @description: Retrieves the list of branches from a GitHub project.
#!
#! @input token: CircleCI user token.
#!               To authenticate, add an API token using your account dashboard
#!               Log in to CircleCi: https://circleci.com/vcs-authorize/
#!               Go to : https://circleci.com/account/api and copy the API token.
#!               If you don`t have any token generated, enter a new token name and then click on
#! @input protocol: Optional - connection protocol
#!                  valid: 'http', 'https'
#!                  default: 'https'
#! @input host: CircleCI address
#!              Default: "circleci.com"
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input trust_keystore: Optional - The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input keystore: Optional - The pathname of the Java KeyStore file.
#!                  You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trust_all_roots is 'true'
#!                  this input is ignored.
#!                  Format: Java KeyStore (JKS)
#!                  Default value: '..JAVA_HOME/java/lib/security/cacerts'
#! @input keystore_password: Optional - The password associated with the KeyStore file. If trust_all_roots is false and
#!                           keystore is empty, keystore_password default will be supplied.
#!                           Default value: ''
#! @input username: CircleCI username.
#! @input project: GitHub project name.
#! @input content_type: Optional - content type that should be set in the request header, representing
#!                      the MIME-type of the data in the message body
#!                      Default: 'application/json'
#! @input headers: Optional - list containing the headers to use for the request separated by new line (CRLF);
#!                 header name - value pair will be separated by ":" - Format: According to HTTP standard for
#!                 headers (RFC 2616)
#!                 Example: 'Accept:application/json'
#!
#! @output return_result: Information returned.
#! @output error_message: Return_result if status_code different than '200'.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: Status code of the HTTP call.
#! @output branches: A list of branches.
#!
#! @result SUCCESS: Successful.
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.ci.circleci

imports:
  rest: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: get_project_branches
  inputs:
    - token:
        sensitive: true
    - host:
        default: "circleci.com"
        private: true
    - protocol:
        default: "https"
    - proxy_host:
        required: false
    - proxy_port:
        default: "8080"
        required: false
    - trust_keystore:
        default: ${get_sp('io.cloudslang.base.http.trust_keystore')}
        required: false
    - trust_password:
        default: ${get_sp('io.cloudslang.base.http.trust_password')}
        required: false
        sensitive: true
    - keystore:
        default: ${get_sp('io.cloudslang.base.http.keystore')}
        required: false
    - keystore_password:
        default: ${get_sp('io.cloudslang.base.http.keystore_password')}
        required: false
        sensitive: true
    - content_type:
        default: "application/json"
        private: true
    - headers:
        default: "Accept:application/json"
        private: true

  workflow:
    - get_project_info:
        do:
          rest.http_client_get:
            - url: ${protocol + '://' + host + '/api/v1/projects?circle-token=' + token}
            - protocol
            - host
            - proxy_host
            - proxy_port
            - content_type
            - headers
            - trust_all_roots: "false"
            - x_509_hostname_verifier: "strict"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
        publish:
          - return_result
          - return_code
          - status_code
          - error_message
        navigate:
          - SUCCESS: get_branches
          - FAILURE: FAILURE

    - get_branches:
        do:
          json.get_keys:
            - json_input: ${return_result}
            - json_path: "0,'branches'"
        publish:
          - branches: ${return_result}
          - error_message

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - branches

  results:
    - SUCCESS
    - FAILURE
