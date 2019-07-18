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
#! @description: Retrieves build failure from CircleCI - GitHub project - branches.
#!               If the latest build has failed, it will send an email,
#!               to the supervisor and committer with the following:
#!               Example:
#!                        Repository: repository name
#!                        Branch: branch name
#!                        Username: GitHub username
#!                        committer email: email of GitHub username
#!                        Subject: Last commit subject
#!                        Branch: failed
#!               If the last build from a branch has not failed, it will send an email to reflect that.
#!
#! @input token: CircleCI user token.
#!                To authenticate, add an API token using your account dashboard
#!                Log in to CircleCi: https://circleci.com/vcs-authorize/
#!                Go to : https://circleci.com/account/api and copy the API token.
#!                If you don`t have any token generated, enter a new token name and then click on
#! @input protocol: Optional - connection protocol
#!                  valid: 'http', 'https'
#!                  default: 'https'
#! @input host: CircleCI address.
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
#! @input branches: GitHub project branches.
#! @input content_type: Optional - Content type that should be set in the request header, representing
#!                      the MIME-type of the data in the message body.
#!                      Default: 'application/json'
#! @input headers: Optional - List containing the headers to use for the request separated by new line (CRLF);
#!                 header name - value pair will be separated by ":" - Format: According to HTTP standard for
#!                 headers (RFC 2616) - Example: 'Accept:application/json'
#! @input committer_email: email address of the committer.
#! @input branch: GitHub branch.
#!                Default: ''
#! @input branches: A list of all the available branches on a certain project.
#!                  Default: ''
#! @input supervisor: GitHub supervisor email.
#! @input hostname: Email host.
#! @input port: Email port.
#! @input from: Email sender.
#! @input to: Email recipient.
#! @input cc: Optional - Comma-delimited list of cc recipients.
#!
#! @output return_result: Information returned.
#! @output error_message: Return_result if status_code different than '200'.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: Status code of the HTTP call.
#!
#! @result SUCCESS: Successful.
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.ci.circleci

imports:
  rest: io.cloudslang.base.http
  json: io.cloudslang.base.json
  mail: io.cloudslang.base.mail
  circleci: io.cloudslang.ci.circleci

flow:
  name: get_branches_build_failure

  inputs:
    - token:
        sensitive: true
    - protocol:
        default: "https"
    - host:
        default: "circleci.com"
        private: true
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
    - username
    - project
    - committer_email
    - branch:
        default: ''
        required: false
    - branches:
        default: ''
        required: false
    - supervisor
    - hostname
    - port
    - from
    - to
    - cc:
        required: false

  workflow:
    - get_project_branches:
        do:
          circleci.get_project_branches:
            - url: ${protocol + '://' + host + '/api/v1/projects?circle-token=' + token}
            - protocol
            - host
            - token
            - proxy_host
            - proxy_port
            - trust_all_roots: "false"
            - x_509_hostname_verifier: "strict"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - content_type
            - headers
        publish:
          - branches
          - error_message
          - return_result
        navigate:
          - SUCCESS: get_branches_build_failure
          - FAILURE: FAILURE

    - get_branches_build_failure:
        loop:
          for: branch in branches
          do:
            circleci.get_failed_build:
              - url: ${protocol + '://' + host + '/api/v1/project/' + username + '/' + project + '/tree/' + branch + '?circle-token=:' + token + '&limit=1&filter=failed'}
              - token
              - protocol
              - host
              - branch
              - committer_email
              - proxy_host
              - proxy_port
              - trust_all_roots: "false"
              - x_509_hostname_verifier: "strict"
              - trust_keystore
              - trust_password
              - keystore
              - keystore_password
              - username
              - project
              - branches
              - supervisor
              - hostname
              - port
              - from
              - to
              - cc: ${supervisor}
          publish:
            - return_result
            - return_code
            - status_code
            - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - FAILURE
