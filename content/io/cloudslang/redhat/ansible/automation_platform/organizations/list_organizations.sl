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
#! @description: This flow will display a list of all Organizations in your Ansible Automation Platform instance.
#!
#! @input ansible_automation_platform_url: Ansible automation platform API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input ansible_automation_platform_username: Username to connect to Ansible automation platform.
#! @input ansible_automation_platform_password: Password used to connect to Ansible automation platform.
#! @input proxy_host: Optional - Proxy server used to access the Ansible automation platform.
#! @input proxy_port: Optional - Proxy server port used to access the Ansible automation platform.
#! @input proxy_username: Optional - Proxy server user name.
#! @input proxy_password: Optional - Proxy server password associated with the proxy_username input value.
#! @input worker_group: Optional - A worker group is a logical collection of workers.A worker may belong to more thanone group simultaneously.Default: 'RAS_Operator_Path'
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if notrusted certification authority issued it.Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject'sCommon Name (CN) or subjectAltName field of the X.509 certificate. Set this to"allow_all" to skip any checking. For the value "browser_compatible" the hostnameverifier works the same way as Curl and Firefox. The hostname must match either thefirst CN, or any of the subject-alts. A wildcard can occur in the CN, and in any ofthe subject-alts. The only difference between "browser_compatible" and "strict" isthat a wildcard (such as "*.foo.com") with "browser_compatible" matches allsubdomains, including "a.b.foo.com".Default: 'strict'
#! @input trust_keystore: Optional - The pathname of the Java TrustStore file. This contains certificates from other parties thatyou expect to communicate with, or from Certificate Authorities that you trust to identifyother parties.  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is'true' this input is ignored. Format: Java KeyStore (JKS)
#! @input trust_password: Optional - The password associated with the TrustStore file. If trustAllRoots is false and trustKeystoreis empty, trustPassword default will be supplied.
#!
#! @output organization_info: A comma-separated list of Organizations and their id's
#! @output organizations_details: A JSON output containing the list of all organizations.
#! @output organizations_id_list: The list of organization's IDs.
#! @output organizations_name_list: The list of organization's names.
#! @output status_code: status code of the HTTP call
#! @output return_code: '0' if success, '-1' otherwise
#!
#! @result FAILURE: There was an error while executing the request.
#! @result SUCCESS: The request was successfully executed.
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.automation_platform.organizations
flow:
  name: list_organizations
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
    - worker_group:
        default: RAS_Operator_Path
        required: false
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
    - get_all_organizations:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${ansible_automation_platform_url+'/organizations/'}"
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
            - worker_group: '${worker_group}'
        publish:
          - organizations_details: '${return_result}'
        navigate:
          - SUCCESS: get_list_of_organization_id
          - FAILURE: on_failure
    - get_list_of_organization_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${organizations_details}'
            - json_path: '$.results[*].id'
        publish:
          - organizations_id_list: "${return_result.strip('[').strip(']')}"
          - organization_info: ''
        navigate:
          - SUCCESS: get_list_of_organization_name
          - FAILURE: on_failure
    - Iterate_trough_organization_ids:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${organizations_id_list}'
        publish:
          - organization_id: '${result_string}'
        navigate:
          - HAS_MORE: get_organization_name_from_ID
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - get_organization_name_from_ID:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${ansible_automation_platform_url+'/organizations/'+organization_id}"
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
            - worker_group: '${worker_group}'
        publish:
          - organization_output: '${return_result}'
          - status_code
          - return_code
        navigate:
          - SUCCESS: filter_organization_name_from_JSON
          - FAILURE: on_failure
    - filter_organization_name_from_JSON:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${organization_output}'
            - json_path: $.name
        publish:
          - organization_name: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: is_organization_info_empty
          - FAILURE: on_failure
    - Add_items_to_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${organization_info}'
            - text: "${'|'+organization_id+','+organization_name}"
        publish:
          - organization_info: '${new_string}'
        navigate:
          - SUCCESS: Iterate_trough_organization_ids
    - is_organization_info_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${organization_info}'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: Add_first_item_to_list
          - FAILURE: Add_items_to_list
    - Add_first_item_to_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${organization_info}'
            - text: "${organization_id+','+organization_name}"
        publish:
          - organization_info: '${new_string}'
        navigate:
          - SUCCESS: Iterate_trough_organization_ids
    - get_list_of_organization_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${organizations_details}'
            - json_path: '$.results[*].name'
        publish:
          - organizations_name_list: "${return_result.strip('[').strip(']')}"
        navigate:
          - SUCCESS: Iterate_trough_organization_ids
          - FAILURE: on_failure
  outputs:
    - organization_info
    - organizations_details
    - organizations_id_list
    - organizations_name_list
    - status_code
    - return_code
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Iterate_trough_organization_ids:
        x: 520
        'y': 80
        navigate:
          9b32e6af-61d5-f3b4-fe30-d5b72a38f613:
            targetId: 1ffd07c0-d987-2eba-f0d9-4112d7ba96e4
            port: NO_MORE
      Add_first_item_to_list:
        x: 680
        'y': 400
        navigate:
          68f477b0-1c5f-3820-f3fb-70351839080b:
            vertices:
              - x: 720
                'y': 200
            targetId: Iterate_trough_organization_ids
            port: SUCCESS
      Add_items_to_list:
        x: 520
        'y': 240
      get_list_of_organization_name:
        x: 360
        'y': 80
      filter_organization_name_from_JSON:
        x: 360
        'y': 400
      is_organization_info_empty:
        x: 520
        'y': 400
      get_list_of_organization_id:
        x: 200
        'y': 80
      get_all_organizations:
        x: 40
        'y': 80
      get_organization_name_from_ID:
        x: 360
        'y': 240
    results:
      SUCCESS:
        1ffd07c0-d987-2eba-f0d9-4112d7ba96e4:
          x: 680
          'y': 80
