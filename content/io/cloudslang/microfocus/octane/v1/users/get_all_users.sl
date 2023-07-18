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
#! @description: This flow return a list of all users
#!
#! @input url: The URL of the host running Octane. The format should be <protocol>://host:port.
#! @input auth_type: Type of authentication used to execute the request on the target server.Valid: 'basic', 'form', 'springForm', 'digest', 'ntlm', 'kerberos', 'anonymous' (no authentication)Default: 'anonymous'
#! @input shared_space: Shared space Id
#! @input workspace: Workspace Id
#! @input proxy_host: The proxy server used to access the web site.
#! @input proxy_port: The proxy server port. Default value: 8080. Valid values: -1, and positive integer values. When the value is '-1' the default port of the scheme, specified in the 'proxyHost', will be used.
#! @input proxy_username: The user name used when connecting to the proxy. The "authType" input will be used to choose authentication type. The "Basic" and "Digest" proxy auth type are supported.
#! @input proxy_password: The proxy server password associated with the proxyUsername input value.
#! @input trust_all_roots: Specifies whether to enable weak security over TSL. A certificate is trusted even if no trusted certification authority issued it.
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. The hostname verification system prevents communication with other hosts other than the ones you intended. This is done by checking that the hostname is in the subject alternative name extension of the certificate. This system is designed to ensure that, if an attacker (Man-In-The-Middle) redirects traffic to his machine, the client will not accept the connection. If you set this input to "allow_all", this verification is ignored and you become vulnerable to security attacks. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". From the security perspective, to provide protection against possible Man-In-The-Middle attacks, we strongly recommend to use "strict" option.
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that you expect to communicate with, or from Certificate Authorities that you trust to identify other parties. If the protocol (specified by the URL) is not HTTPS or if trustAllRoots is "true" this input is ignored.
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystore is empty, trustPassword default will be supplied
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of 0 represents an infinite timeout.
#! @input socket_timeout: The timeout for waiting for data (a maximum period inactivity between two consecutive data packets), in seconds. A socketTimeout value of 0 represents an infinite timeout.
#! @input header: List containing the headers to use for the request separated by new line (CRLF).Header name - value pair will be separated by ":"Format: According to HTTP standard for headers (RFC 2616)Example: 'Accept:text/plain'
#! @input query_params: List containing query parameters to append to the URL.
#!                      Examples: 'parameterName1=parameterValue1&parameterName2=parameterValue2;'
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group. Default: 'RAS_Operator_Path'
#!
#! @output return_result: Contains a human readable message describing the status of the Octane Action.
#! @output return_code: The returnCode of the operation: 0 for success, -1 for failure.
#! @output status_code: The HTTP status code.
#! @output response_headers: The list containing the headers of the response message, separated by newline.
#! @output error_message: In case of success response, this result is empty. In case of failure response, this result contains the stack trace of the runtime exception.
#! @output data: The list of users
#! @output total_count: Total number of users
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.octane.v1.users
flow:
  name: get_all_users
  inputs:
    - url
    - auth_type:
        required: false
    - shared_space:
        required: true
    - workspace:
        required: true
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
    - connect_timeout:
        required: false
    - socket_timeout:
        required: false
    - header
    - query_params:
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - query_params_validator:
        do:
          io.cloudslang.microfocus.octane.v1.utils.query_params_validator:
            - limit: '4'
            - total_count: '5'
        publish:
          - query_params
          - return_code
          - error_message
        navigate:
          - SUCCESS: get_all_users
          - FAILURE: on_failure
    - get_all_users:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${url+'/api/shared_spaces/'+shared_space+'/users/'}"
            - auth_type: '${auth_type}'
            - headers: '${header}'
            - query_params: '${query_params}'
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
          - response_headers
        navigate:
          - SUCCESS: parse_return_result
          - FAILURE: on_failure
    - parse_return_result:
        do:
          io.cloudslang.microfocus.octane.v1.utils.parse_return_result:
            - text: '${return_result}'
        publish:
          - data
          - total_count
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - return_result: '${return_result}'
    - return_code: '${return_code}'
    - status_code: '${status_code}'
    - response_headers: '${response_headers}'
    - error_message: '${error_message}'
    - data: '${data}'
    - total_count: '${total_count}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      query_params_validator:
        x: 100
        'y': 150
      get_all_users:
        x: 400
        'y': 150
      parse_return_result:
        x: 700
        'y': 150
        navigate:
          6823ba9a-c989-b148-93e5-a8841505ec14:
            targetId: a74b369c-69c5-0f69-bb22-310d3234d812
            port: SUCCESS
    results:
      SUCCESS:
        a74b369c-69c5-0f69-bb22-310d3234d812:
          x: 1000
          'y': 150
