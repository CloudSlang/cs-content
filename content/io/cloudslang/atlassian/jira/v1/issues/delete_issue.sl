#   Copyright 2024 Open Text
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
#! @description: Deletes an issue. An issue cannot be deleted if it has one or more subtasks. To delete an issue with subtasks, set deleteSubtasks. This causes the issue's subtasks to be deleted with the issue.
#!
#! @input url: Jira url.
#! @input username: Username for the API authenticator
#! @input password: Password for the API authenticator
#! @input issue_id_or_key: The ID or key of the issue.
#! @input delete_subtasks: Whether the issue's subtasks are deleted when the issue is deleted. Values: true/false
#! @input proxy_host: The proxy server used to access the web site.
#! @input proxy_port: The proxy server port. Default value: 8080. Valid values: -1, and positive integer values. When the value is '-1' the default port of the scheme, specified in the 'proxy_host', will be used.
#! @input proxy_username: The user name used when connecting to the proxy. The 'auth_type' input will be used to choose authentication type. The 'Basic' and 'Digest' proxy authentication type are supported.
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
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
#! @input trust_keystore: Optional - The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default value: false Valid values: true, false
#! @input x509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. The hostname verification system prevents communication with other hosts other than the ones you intended. This is done by checking that the hostname is in the subject alternative name extension of the certificate. This system is designed to ensure that, if an attacker(Man In The Middle) redirects traffic to his machine, the client will not accept the connection. If you set this input to "allow_all", this verification is ignored and you become vulnerable to security attacks. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". From the security perspective, to provide protection against possible Man-In-The-Middle attacks, we strongly recommend to use "strict" option. Default value: strict Valid values: strict, browser_compatible, allow_all
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0' represents an infinite timeout. Default value: 0 Format: an integer representing seconds Examples: 10, 20
#! @input socket_timeout: Optional - Time in seconds to wait for data to be retrieved.
#!                        Default: '0' (infinite)
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output return_result: The entire HTTP result as JSON, which for this operation is empty.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: Status code of the HTTP call. 204 - Returned if the request is successful.
#!                      400 - Returned if the issue has subtasks and deleteSubtasks is not set to true.
#!                      401 - Returned if the authentication credentials are incorrect.
#!                      403 - Returned if the user does not have permission to delete the issue.
#!                      404 - Returned if the issue is not found or the user does not have permission to view the issue.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#! @output error_message: The API call error or the retrieved entity error as JSON.
#!
#! @result SUCCESS: Issue deleted
#! @result FAILURE: Operation failed
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.issues
flow:
  name: delete_issue
  inputs:
    - url
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - issue_id_or_key
    - delete_subtasks:
        default: 'false'
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
    - trust_keystore:
        default: "${get_sp('io.cloudslang.base.http.trust_keystore')}"
        required: false
    - trust_password:
        default: "${get_sp('io.cloudslang.base.http.trust_password')}"
        required: false
        sensitive: true
    - trust_all_roots:
        default: 'false'
        required: false
    - x509_hostname_verifier:
        default: strict
        required: false
    - connect_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
        required: false
    - worker_group:
        required: false
  workflow:
    - http_client_delete:
        do:
          io.cloudslang.base.http.http_client_delete:
            - url: "${url + '/rest/api/3/issue/' + issue_id_or_key}"
            - username: '${auth_username}'
            - password:
                value: '${auth_password}'
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
            - x_509_hostname_verifier: '${x509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - request_character_set: utf-8
            - content_type: application/json
            - worker_group: '${worker_group}'
        publish:
          - return_code: '${return_code}'
          - status_code: '${status_code}'
          - response_headers: '${response_headers}'
          - return_result: '${return_result}'
          - error_message: '${error_message}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: test_for_http_error
    - test_for_http_error:
        do:
          io.cloudslang.atlassian.jira.v1.utils.test_for_http_error:
            - status_code: '${status_code}'
            - return_result: '${return_result}'
        publish:
          - error_message
        navigate:
          - FAILURE: on_failure
  outputs:
    - return_result: '${return_result}'
    - return_code: '${return_code}'
    - status_code: '${status_code}'
    - response_headers: '${response_headers}'
    - error_message: '${error_message}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      http_client_delete:
        x: 280
        'y': 200
        navigate:
          6377af44-0b8f-e9d1-35dc-5d7115b9efb6:
            targetId: a371d274-c013-6741-8cda-b0a4c62b7384
            port: SUCCESS
      test_for_http_error:
        x: 280
        'y': 360
    results:
      SUCCESS:
        a371d274-c013-6741-8cda-b0a4c62b7384:
          x: 560
          'y': 200
