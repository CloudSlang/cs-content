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
#! @description: This flow will display a list of all projects in the given Ansible Automation Platform instance.
#!
#! @input ansible_automation_platform_url: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input ansible_automation_platform_username: Username to connect to Ansible Tower
#! @input ansible_automation_platform_password: Password used to connect to Ansible Tower
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
#! @output projects_details: A JSON output containing the list of all projects.
#! @output project_name_list: The list of project names.
#! @output project_id_list: The list of project IDs.
#! @output project_info: A comma-separated list of projects and their id's.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: status code of the HTTP call.
#!
#! @result FAILURE: There was an error while executing the request.
#! @result SUCCESS: The request was successfully executed.
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.automation_platform.projects
flow:
  name: list_projects
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
    - trust_all_roots: 'false'
    - x_509_hostname_verifier: strict
    - trust_keystore:
        required: false
    - trust_password:
        required: false
  workflow:
    - get_all_projects:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${ansible_automation_platform_url+'/projects/'}"
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
          - projects_details: '${return_result}'
          - return_code
          - status_code
        navigate:
          - SUCCESS: get_array_of_project_IDs
          - FAILURE: on_failure
    - get_array_of_project_IDs:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${projects_details}'
            - json_path: '$.results[*].id'
        publish:
          - project_id_list: "${return_result.strip('[').strip(']')}"
          - project_info: ''
        navigate:
          - SUCCESS: get_array_of_project_name
          - FAILURE: on_failure
    - Iterate_trough_IDs:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${project_id_list}'
        publish:
          - project_id: "${result_string.strip('\"')}"
        navigate:
          - HAS_MORE: Get_ProjectName_from_ID
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - Get_ProjectName_from_ID:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${ansible_automation_platform_url+'/projects/'+project_id}"
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
          - project_json: '${return_result}'
        navigate:
          - SUCCESS: Filter_ProjectName_from_JSON
          - FAILURE: on_failure
    - Filter_ProjectName_from_JSON:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${project_json}'
            - json_path: $.name
        publish:
          - project_name: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: Add_items_to_list
          - FAILURE: on_failure
    - Add_items_to_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${project_info}'
            - text: "${project_id+','+project_name+\"\\n\"}"
        publish:
          - project_info: '${new_string}'
        navigate:
          - SUCCESS: Iterate_trough_IDs
    - get_array_of_project_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${projects_details}'
            - json_path: '$.results[*].name'
        publish:
          - project_name_list: "${return_result.strip('[').strip(']').replace('\"','')}"
        navigate:
          - SUCCESS: Iterate_trough_IDs
          - FAILURE: on_failure
  outputs:
    - projects_details
    - project_name_list
    - project_id_list
    - project_info
    - return_code
    - status_code
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Add_items_to_list:
        x: 680
        'y': 240
      get_all_projects:
        x: 40
        'y': 80
      Iterate_trough_IDs:
        x: 520
        'y': 80
        navigate:
          9b32e6af-61d5-f3b4-fe30-d5b72a38f613:
            targetId: 1ffd07c0-d987-2eba-f0d9-4112d7ba96e4
            port: NO_MORE
      Get_ProjectName_from_ID:
        x: 520
        'y': 240
      Filter_ProjectName_from_JSON:
        x: 520
        'y': 400
      get_array_of_project_IDs:
        x: 200
        'y': 80
      get_array_of_project_name:
        x: 360
        'y': 80
    results:
      SUCCESS:
        1ffd07c0-d987-2eba-f0d9-4112d7ba96e4:
          x: 720
          'y': 80
