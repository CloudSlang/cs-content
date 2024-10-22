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
#! @description: This flow will lookup the given Inventory name and return its id.
#!
#! @input ansible_automation_platform_url: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input ansible_automation_platform_username: Username to connect to Ansible Tower
#! @input ansible_automation_platform_password: Password used to connect to Ansible Tower
#! @input inventory_name: The exact Inventory name of the Ansible Tower Inventory component that you want to lookup the id for (example: "Demo Inventory").
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - User name used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output InventoryID: Value of the "id" property of this Ansible Tower component (integrer).
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.automation_platform.inventories
flow:
  name: get_inventory_id
  inputs:
    - ansible_automation_platform_url
    - ansible_automation_platform_username
    - ansible_automation_platform_password:
        sensitive: true
    - inventory_name
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
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - Convert_whitespaces:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.redhat.ansible_tower.utils.search_and_replace:
            - origin_string: '${inventory_name}'
            - text_to_replace: ' '
            - replace_with: '%20'
        publish:
          - InventoryName: '${replaced_string}'
        navigate:
          - SUCCESS: Connect_to_Ansible_Tower
    - Connect_to_Ansible_Tower:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${ansible_automation_platform_url+'/inventories?name='+inventory_name}"
            - auth_type: basic
            - username: "${ansible_automation_platform_username}"
            - password:
                value: "${ansible_automation_platform_password}"
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - headers: 'Content-Type:application/json'
            - worker_group: '${worker_group}'
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: Filter_count_from_JSON
          - FAILURE: on_failure
    - Filter_ID_from_JSON:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: '$.results[*].id'
        publish:
          - InventoryID: "${return_result.strip('[').strip(']')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - Filter_count_from_JSON:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.count
        publish:
          - count: "${return_result.strip('[').strip(']')}"
        navigate:
          - SUCCESS: Check_count_is_1
          - FAILURE: on_failure
    - Check_count_is_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${count}'
            - second_string: '1'
        navigate:
          - SUCCESS: Filter_ID_from_JSON
          - FAILURE: FAILURE
  outputs:
    - InventoryID: '${InventoryID}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Convert_whitespaces:
        x: 40
        'y': 80
      Connect_to_Ansible_Tower:
        x: 51
        'y': 272
      Filter_ID_from_JSON:
        x: 482
        'y': 75
        navigate:
          1931d9dd-3a25-7ed5-85e5-9275a2b4b549:
            targetId: 2e398679-49d5-534e-8413-f1f4e46f370a
            port: SUCCESS
      Filter_count_from_JSON:
        x: 265
        'y': 266
      Check_count_is_1:
        x: 263
        'y': 77
        navigate:
          754bef08-5d3c-d689-923a-45e2754b90d6:
            targetId: d55d7b8d-f0b6-a820-b28e-797a1d141a77
            port: FAILURE
    results:
      FAILURE:
        d55d7b8d-f0b6-a820-b28e-797a1d141a77:
          x: 474
          'y': 260
      SUCCESS:
        2e398679-49d5-534e-8413-f1f4e46f370a:
          x: 668
          'y': 83
