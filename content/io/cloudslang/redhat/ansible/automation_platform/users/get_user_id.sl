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
#! @description: This flow will lookup the given username and return it's id from your Ansible Automation Platform system.
#!
#! @input ansible_automation_platform_url: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2).
#! @input ansible_automation_platform_username: Username to connect to Ansible Tower.
#! @input ansible_automation_platform_password: Password used to connect to Ansible Tower.
#! @input username: The exact username of the Ansible Tower User component that you want to lookup the id for (example: "DemoUser").
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - Username used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input trust_keystore: Optional - The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Default value: ''
#! @input trust_password: Optional - The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input worker_group: Optional - When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output user_id: The id (integer) of the selected User.
#! @output error_message: An error message in case there was an error while creating the User.
#! @output status_code: The HTTP status code of the Ansible Tower API request.
#!
#! @result SUCCESS: The ID of the user was retrieved successfully..
#! @result FAILURE: There was an error while retrieving the user ID.
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.automation_platform.users
flow:
  name: get_user_id
  inputs:
    - ansible_automation_platform_url
    - ansible_automation_platform_username
    - ansible_automation_platform_password:
        sensitive: true
    - username
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
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - connect_to_ansible_tower:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${ansible_automation_platform_url+'/users?username='+username}"
            - auth_type: basic
            - username: '${ansible_automation_platform_username}'
            - password:
                value: '${ansible_automation_platform_password}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - headers: 'Content-Type:application/json'
            - worker_group:
                value: '${worker_group}'
        publish:
          - json_output: '${return_result}'
          - error_message
          - status_code
        navigate:
          - SUCCESS: filter_count_from_json
          - FAILURE: on_failure
    - filter_id_from_json:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: '$.results[*].id'
        publish:
          - user_id: "${return_result.strip('[').strip(']')}"
          - error_message: '${exception}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - filter_count_from_json:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.count
            - worker_group:
                value: '${worker_group}'
        publish:
          - count: "${return_result.strip('[').strip(']')}"
          - error_message: '${exception}'
        navigate:
          - SUCCESS: check_count_is_1
          - FAILURE: on_failure
    - check_count_is_1:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${count}'
            - second_string: '1'
        navigate:
          - SUCCESS: filter_id_from_json
          - FAILURE: FAILURE
  outputs:
    - user_id: '${user_id}'
    - error_message: '${error_message}'
    - status_code: '${status_code}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      connect_to_ansible_tower:
        x: 80
        'y': 80
      filter_id_from_json:
        x: 680
        'y': 80
        navigate:
          1931d9dd-3a25-7ed5-85e5-9275a2b4b549:
            targetId: 2e398679-49d5-534e-8413-f1f4e46f370a
            port: SUCCESS
      filter_count_from_json:
        x: 280
        'y': 80
      check_count_is_1:
        x: 480
        'y': 80
        navigate:
          754bef08-5d3c-d689-923a-45e2754b90d6:
            targetId: d55d7b8d-f0b6-a820-b28e-797a1d141a77
            port: FAILURE
    results:
      FAILURE:
        d55d7b8d-f0b6-a820-b28e-797a1d141a77:
          x: 480
          'y': 320
      SUCCESS:
        2e398679-49d5-534e-8413-f1f4e46f370a:
          x: 680
          'y': 320

