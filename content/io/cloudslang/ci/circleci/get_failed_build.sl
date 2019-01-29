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
#! @description: Checks if the latest build of a project's branch from CircleCI has failed.
#!               If the latest build from the branch has failed, it will send an email,
#!               to the supervisor and committer with the following:
#!               Example:
#!                        Repository: repository name
#!                        Branch: branch name
#!                        Username: GitHub username
#!                        committer email: email of GitHub username
#!                        Subject: Last commit subject
#!                        Branch: failed
#!               If the last build from the branch has not failed, it will send an email to reflect that.
#!
#! @input token: CircleCi user token.
#!                To authenticate, add an API token using your account dashboard
#!                Log in to CircleCi: https://circleci.com/vcs-authorize/
#!                Go to : https://circleci.com/account/api and copy the API token.
#!                If you don`t have any token generated, enter a new token name and then click on
#! @input protocol: Optional - Connection protocol.
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
#! @input branch: GitHub project branch.
#! @input content_type: Optional - Content type that should be set in the request header, representing
#!                      the MIME-type of the data in the message body.
#!                      Default: 'application/json'
#! @input headers: Optional - List containing the headers to use for the request separated by new line (CRLF);
#!                 header name - value pair will be separated by ":" - Format: According to HTTP standard for
#!                 headers (RFC 2616) - Example: 'Accept:application/json'
#! @input committer_email: Email address of the committer.
#! @input supervisor: GitHub supervisor email.
#! @input hostname: Email host.
#! @input port: Email port.
#! @input from: Email sender.
#! @input to: Email recipient.
#! @input cc: Optional - Comma-delimited list of cc recipients.
#!
#! @output return_result: Information returned.
#! @output error_message: Return_result if status_code different than '200'.
#! @output return_code: '0' if success, '-1' otherwise
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
  lists: io.cloudslang.base.lists

flow:
  name: get_failed_build

  inputs:
    - token:
        sensitive: true
    - protocol
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
    - username
    - project
    - branch
    - content_type:
        default: "application/json"
        private: true
    - headers:
        default: "Accept:application/json"
        private: true
    - committer_email
    - supervisor
    - hostname
    - port
    - from
    - to
    - cc:
        required: false

  workflow:
    - get_failed_build:
        do:
          rest.http_client_get:
            - url: ${protocol + '://' + host + '/api/v1/project/' + username + '/' + project + '/tree/' + branch + '?circle-token=' + token + '&limit=1&filter=failed'}
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
          - SUCCESS: match_if_failed
          - FAILURE: FAILURE

    - match_if_failed:
        do:
          lists.compare_lists:
            - list_1: ${return_result}
            - list_2: '[]'
        navigate:
          - SUCCESS: mail_success_build
          - FAILURE: get_username

    - get_username:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "0,'username'"
        publish:
          - username: ${return_result}
          - error_message
        navigate:
          - SUCCESS: get_committer_email
          - FAILURE: FAILURE

    - get_committer_email:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "0,'committer_email'"
        publish:
          - committer_email: ${return_result}
          - error_message
        navigate:
          - SUCCESS: get_branch
          - FAILURE: FAILURE

    - get_branch:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "0,'branch'"
        publish:
          - branch: ${return_result}
          - error_message
        navigate:
          - SUCCESS: get_subject
          - FAILURE: FAILURE

    - get_subject:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "0,'subject'"
        publish:
          - ci_subject: ${return_result}
          - error_message
        navigate:
          - SUCCESS: get_build_num
          - FAILURE: FAILURE

    - get_build_num:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "0,'build_num'"
        publish:
          - build_num: ${return_result}
          - error_message
        navigate:
          - SUCCESS: get_commit
          - FAILURE: FAILURE

    - get_commit:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "0,'vcs_revision'"
        publish:
          - commit: ${return_result}
          - error_message
        navigate:
          - SUCCESS: get_outcome
          - FAILURE: FAILURE

    - get_outcome:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "0,'outcome'"
        publish:
          - outcome: ${return_result}
          - error_message
        navigate:
          - SUCCESS: mail_failed_build
          - FAILURE: FAILURE

    - mail_success_build:
         do:
           mail.send_mail:
             - hostname
             - port
             - from
             - to: ${committer_email}
             - subject: ${'[Build' + '] ' + 'Success:' + username + '/' + project + '/' + branch}
             - body: ${'Latest build finished successfully.'}
             - username
             - password
         navigate:
                - SUCCESS: SUCCESS
                - FAILURE: FAILURE

    - mail_failed_build:
         do:
           mail.send_mail:
             - hostname
             - port
             - from
             - to: ${committer_email}
             - cc: ${supervisor}
             - subject: ${'[Build' + '] ' + 'Failed:' + username + '/' + project + '/' + branch}
             - htmlEmail: "True"
             - body: >
                  ${'<p align=center>' + 'Build failure on repository:' + project + '-' + 'branch:' + branch + '</p>'
                  '<table align="center" border="1" cellpadding="0" cellspacing="0" width="400">' +
                  '<tr>' +
                  '<td>' +
                  'Repository:' +
                  '</td>' +
                  '<td bgcolor="#70bbd9">' +
                  project +
                  '</td>' +
                  '</tr>' +
                  '<tr>' +
                  '<td>' +
                  'Branch:' +
                  '</td>' +
                  '<td>' +
                  branch +
                  '</td>' +
                  '</tr>' +
                  '<tr>' +
                  '<td>' +
                  'Username:' +
                  '</td>' +
                  '<td>' +
                  username +
                  '</td>' +
                  '</tr>' +
                  '<tr>' +
                  '<td>' +
                  'committer email:' +
                  '</td>' +
                  '<td>' +
                  committer_email +
                  '</td>' +
                  '</tr>' +
                  '<tr>' +
                  '<td>' +
                  'Subject:' +
                  '</td>' +
                  '<td>' +
                  ci_subject +
                  '</td>' +
                  '</tr>' +
                  '<tr>' +
                  '<td>' +
                  'Status:' +
                  '</td>' +
                  '<td bgcolor="#ee4c50">' +
                  outcome +
                  '</td>' +
                  '</tr>' +
                  '</table>'}
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
