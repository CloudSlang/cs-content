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
#! @description: This flow will display a list of all Hosts in your Ansible Automation Platform instance.
#!
#! @input ansible_automation_platform_url: Ansible Automation Platform API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input ansible_automation_platform_username: Username to connect to Ansible Automation Platform
#! @input ansible_automation_platform_password: Password used to connect to Ansible Automation Platform
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
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output hosts_list: A comma-separated list of all hosts and their id's.
#! @output return_result: The response of the Ansible Automation Platform API request in case of success or the error message otherwise.
#! @output error_message: An error message in case there was an error while retrieving the hosts list.
#! @output status_code: The HTTP status code of the Ansible Automation Platform API request.
#!
#! @result FAILURE: There was an error while retrieving the list of hosts.
#! @result SUCCESS: The list of the hosts was retrieved successfully..
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.automation_platform.hosts
flow:
  name: list_hosts
  inputs:
    - ansible_automation_platform_url
    - ansible_automation_platform_username
    - ansible_automation_platform_password:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
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
    - get_all_hosts:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${ansible_automation_platform_url+'/hosts/'}"
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
            - worker_group: '${worker_group}'
        publish:
          - json_output: '${return_result}'
          - error_message
          - status_code
        navigate:
          - SUCCESS: get_array_of_ids
          - FAILURE: on_failure
    - get_array_of_ids:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: '$.results[*].id'
        publish:
          - output: "${return_result.strip('[').strip(']')}"
          - new_string: ''
        navigate:
          - SUCCESS: iterate_through_ids
          - FAILURE: on_failure
    - iterate_through_ids:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${output}'
        publish:
          - list_item: '${result_string}'
        navigate:
          - HAS_MORE: get_hostname_from_id
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - get_hostname_from_id:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${ansible_automation_platform_url+'/hosts/'+list_item}"
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
            - worker_group: '${worker_group}'
        publish:
          - host: '${return_result}'
        navigate:
          - SUCCESS: filter_hostname_from_json
          - FAILURE: on_failure
    - filter_hostname_from_json:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${host}'
            - json_path: $.name
        publish:
          - host_name: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: add_items_to_list
          - FAILURE: on_failure
    - add_items_to_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${new_string}'
            - text: "${list_item+','+host_name+\"\\n\"}"
        publish:
          - hosts_list: '${new_string}'
        navigate:
          - SUCCESS: iterate_through_ids
  outputs:
    - hosts_list: '${hosts_list}'
    - return_result: '${json_output}'
    - error_message: '${error_message}'
    - status_code: '${status_code}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_all_hosts:
        x: 40
        'y': 80
      get_array_of_ids:
        x: 216
        'y': 91
      iterate_through_ids:
        x: 426
        'y': 87
        navigate:
          9b32e6af-61d5-f3b4-fe30-d5b72a38f613:
            targetId: 1ffd07c0-d987-2eba-f0d9-4112d7ba96e4
            port: NO_MORE
      get_hostname_from_id:
        x: 440
        'y': 280
      filter_hostname_from_json:
        x: 440
        'y': 480
      add_items_to_list:
        x: 639
        'y': 285
    results:
      SUCCESS:
        1ffd07c0-d987-2eba-f0d9-4112d7ba96e4:
          x: 638
          'y': 88
