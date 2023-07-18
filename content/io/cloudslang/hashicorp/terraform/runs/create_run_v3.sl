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
#! @description: Creates a run in workspace.
#!
#! @input auth_token: The authorization token for terraform
#! @input workspace_id: The Id of created workspace
#! @input tf_run_message: Specifies the message to be associated with this run
#!                     Optional
#! @input is_destroy: Specifies if this plan is a destroy plan, which will destroy all provisioned resources.
#!                    Optional
#! @input request_body: The request body of the crate run.
#!                      Optional
#! @input proxy_host: Proxy server used to access the Terraform service.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Terraform service.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no
#!                         trusted certification authority issued it.
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to
#!                                 allow_all to skip any checking. For the value browser_compatible the hostname
#!                                 verifier works the same way as Curl and Firefox. The hostname must match either the
#!                                 first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of
#!                                 the subject-alts. The only difference between browser_compatible and strict is that a
#!                                 wildcard (such as *.foo.com) with browser_compatible matches all subdomains,
#!                                 including a.b.foo.com.
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that
#!                        you expect to communicate with, or from Certificate Authorities that you trust to identify
#!                        other parties.  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is
#!                        'true' this input is ignored. Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystore
#!                        is empty, trustPassword default will be supplied.
#!                        Optional
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.
#!                         Optional
#! @input socket_timeout: The timeout for waiting for data (a maximum period inactivity between two consecutive data
#!                        packets), in seconds. A socketTimeout value of '0' represents an infinite timeout.
#!                        Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls. If
#!                    keepAlive is false, the already open connection will be used and after execution it will close it.
#!                    Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.
#!                                   Optional
#! @input connections_max_total: The maximum limit of connections in total.
#!                               Optional
#! @input response_character_set: The character encoding to be used for the HTTP response,If responseCharacterSet is
#!                                empty, the charset from the 'Content-Type' HTTP response header will be used.If
#!                                responseCharacterSet is empty and the charset from the HTTP response Content-Type
#!                                header is empty, the default value will be used. You should not use this for
#!                                method=HEAD or OPTIONS
#!                                Optional
#!
#! @output return_result: If successful, returns the complete API response. In case of an error this output will contain
#!                        the error message.
#! @output status_code: The HTTP status code for Terraform API request.
#! @output tf_run_id: Id of the run.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.runs
flow:
  name: create_run_v3
  inputs:
    - auth_token:
        sensitive: true
    - workspace_id:
        sensitive: false
    - tf_run_message:
        required: false
    - is_destroy:
        default: 'false'
        required: false
    - request_body:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
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
  workflow:
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${request_body}'
        navigate:
          - SUCCESS: api_to_create_run_with_request_body
          - FAILURE: api_to_create_run_with_given_request_body
    - api_to_create_run_with_given_request_body:
        do:
          io.cloudslang.hashicorp.terraform.utils.http_client_without_request_character_set:
            - url: 'https://app.terraform.io/api/v2/runs'
            - auth_type: anonymous
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
            - headers: "${'Authorization: Bearer ' + auth_token}"
            - body: '${request_body}'
            - content_type: application/vnd.api+json
            - method: POST
        publish:
          - return_result
          - status_code
        navigate:
          - SUCCESS: get_value
          - FAILURE: on_failure
    - api_to_create_run_with_request_body:
        do:
          io.cloudslang.hashicorp.terraform.utils.http_client_without_request_character_set:
            - url: 'https://app.terraform.io/api/v2/runs'
            - auth_type: anonymous
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
            - headers: "${'Authorization: Bearer ' + auth_token}"
            - body: "${'{\"data\":{\"attributes\":{\"is-Destroy\":'+is_destroy+'},\"relationships\":{\"workspace\": {\"data\": {\"type\":\"workspaces\",\"id\":\"'+workspace_id+'\"}}},\"type\":\"runs\"}}'}"
            - content_type: application/vnd.api+json
            - method: POST
        publish:
          - return_result
          - status_code
        navigate:
          - SUCCESS: get_value
          - FAILURE: on_failure
    - get_value:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: 'data,id'
        publish:
          - tf_run_id: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result
    - status_code
    - tf_run_id
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      string_equals:
        x: 80
        'y': 200
      api_to_create_run_with_given_request_body:
        x: 400
        'y': 200
      api_to_create_run_with_request_body:
        x: 80
        'y': 400
      get_value:
        x: 400
        'y': 400
        navigate:
          a1f352fe-83a1-b039-d195-dfbc39f18be8:
            targetId: b6332f43-8a06-546e-3cb9-36dba53c8095
            port: SUCCESS
    results:
      SUCCESS:
        b6332f43-8a06-546e-3cb9-36dba53c8095:
          x: 640
          'y': 400
