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
#! @description: This flow will display a list of all Users in your Ansible Automation Platform instance.
#!
#! @input ansible_automation_platform_url: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input ansible_automation_platform_username: Username to connect to Ansible Tower.
#! @input ansible_automation_platform_password: Password used to connect to Ansible Tower.
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - User name used when connecting to the proxy.
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
#! @output users_list: A comma-separated list of all users and their id's.
#! @output error_message: An error message in case there was an error while retrieving the users list.
#! @output status_code: The HTTP status code of the Ansible Tower API request.
#!
#! @result SUCCESS: The ID of the user was retrieved successfully..
#! @result FAILURE: There was an error while retrieving the user ID.
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.automation_platform.users
flow:
  name: list_users
  inputs:
    - ansible_automation_platform_url
    - ansible_automation_platform_username
    - ansible_automation_platform_password:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
        sensitive: true
    - proxy_password:
        required: false
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
    - get_all_users:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${ansible_automation_platform_url+'/users/'}"
            - auth_type: basic
            - username: '${ansible_automation_platform_username}'
            - password:
                value: "${ansible_automation_platform_password}"
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_password}'
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
            - worker_group:
                value: '${worker_group}'
        publish:
          - json_output: '${return_result}'
          - error_message
          - status_code
        navigate:
          - SUCCESS: get_array_of_ids
          - FAILURE: on_failure
    - get_array_of_ids:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: '$.results[*].id'
            - worker_group:
                value: '${worker_group}'
        publish:
          - output: "${return_result.strip('[').strip(']')}"
          - new_string: ''
          - error_message: '${exception}'
        navigate:
          - SUCCESS: iterate_trough_ids
          - FAILURE: on_failure
    - iterate_trough_ids:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${output}'
            - worker_group:
                value: '${worker_group}'
        publish:
          - list_item: '${result_string}'
        navigate:
          - HAS_MORE: get_username_from_id
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - get_username_from_id:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${ansible_automation_platform_url+'/users/'+list_item}"
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
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - worker_group:
                value: '${worker_group}'
        publish:
          - user: '${return_result}'
          - error_message
          - status_code
        navigate:
          - SUCCESS: filter_username_from_json
          - FAILURE: on_failure
    - filter_username_from_json:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${user}'
            - json_path: $.username
            - worker_group:
                value: '${worker_group}'
        publish:
          - user_name: "${return_result.strip('\"')}"
          - error_message: '${exception}'
        navigate:
          - SUCCESS: add_items_to_list
          - FAILURE: on_failure
    - add_items_to_list:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${new_string}'
            - text: "${list_item+','+user_name+\"\\n\"}"
            - worker_group:
                value: '${worker_group}'
        publish:
          - users_list: '${new_string}'
        navigate:
          - SUCCESS: iterate_trough_ids
  outputs:
    - users_list: '${users_list}'
    - status_code: '${status_code}'
    - error_message: '${error_message}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_all_users:
        x: 80
        'y': 80
      get_array_of_ids:
        x: 280
        'y': 80
      iterate_trough_ids:
        x: 480
        'y': 80
        navigate:
          9b32e6af-61d5-f3b4-fe30-d5b72a38f613:
            targetId: 1ffd07c0-d987-2eba-f0d9-4112d7ba96e4
            port: NO_MORE
      get_username_from_id:
        x: 480
        'y': 280
      filter_username_from_json:
        x: 480
        'y': 480
      add_items_to_list:
        x: 680
        'y': 280
    results:
      SUCCESS:
        1ffd07c0-d987-2eba-f0d9-4112d7ba96e4:
          x: 680
          'y': 80

