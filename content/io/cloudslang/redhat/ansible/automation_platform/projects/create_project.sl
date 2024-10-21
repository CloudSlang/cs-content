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
#! @description: This flow will create a new project object in the Ansible Automation Platform instance.
#!
#! @input ansible_automation_platform_url: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input ansible_automation_platform_username: Username to connect to Ansible Tower
#! @input ansible_automation_platform_password: Password used to connect to Ansible Tower
#! @input organization_id: The Organization id (integer) for the Organization to create the new Project into (optional) (defaults to id 1)
#! @input project_name: The name (string) of the Ansible Tower Credential component that you want to create (example: "Demo Project").
#! @input description: The description of this new Project
#! @input scm_type: The type of Source Control Manament system to use (example: "manual, ""git", "svn", "hg", "insights")
#! @input local_path: Enter Local_path when scm_type is manual (example: "myfolder")
#! @input scm_url: Enter the scm url (leave empty if scm_type is manual) (example: "https://github.com/ansible/ansible-tower-samples")
#! @input credential_id: The Credential id (integer) for the Credential to link this Project to (optional) (defaults to id 1)
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
#! @output project_id: The id (integer) of the newly created Project
#! @output project_details: A JSON output containing details of the project.
#!
#! @result SUCCESS: The project created successfully.
#! @result FAILURE: There was an error while creating the project.
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.automation_platform.projects
flow:
  name: create_project
  inputs:
    - ansible_automation_platform_url
    - ansible_automation_platform_username
    - ansible_automation_platform_password:
        sensitive: true
    - organization_id:
        required: true
    - project_name
    - description:
        required: true
    - scm_type:
        default: git
        required: true
    - local_path:
        required: false
    - scm_url:
        required: false
    - credential_id:
        default: 'null'
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
        sensitive: true
    - proxy_password:
        required: false
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
    - Set_local_path_if_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.default_if_empty:
            - initial_value: '${local_path}'
            - default_value: project1
        publish:
          - local_path: '${return_result}'
        navigate:
          - SUCCESS: Set_scm_url_if_empty
          - FAILURE: on_failure
    - string_equals:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${scm_type}'
            - second_string: manual
            - ignore_case: 'true'
        navigate:
          - SUCCESS: set_scm_type_variable_manual
          - FAILURE: Set_scm_type_variable
    - Create_new_Project:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
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
            - headers: 'Content-Type:application/json'
            - body: "${'{'+\\\n'   \"name\": \"'+project_name+'\",'+\\\n'   \"description\": \"'+description+'\",'+\\\n'   \"local_path\": \"'+local_path+'\",'+scm_type+','+\\\n'   \"scm_url\": \"'+scm_url+'\",'+\\\n'   \"scm_branch\": \"\",'+\\\n'   \"scm_refspec\": \"\",'+\\\n'   \"scm_clean\": false,'+\\\n'   \"scm_delete_on_update\": false,'+\\\n'   \"credential\": '+credential_id+','+\\\n'   \"timeout\": 0,'+\\\n'   \"organization\": '+organization_id+','+\\\n'   \"scm_update_on_launch\": false,'+\\\n'   \"scm_update_cache_timeout\": 0,'+\\\n'   \"allow_override\": false,'+\\\n'   \"custom_virtualenv\": null'+\\\n'}'}"
        publish:
          - project_details: '${return_result}'
        navigate:
          - SUCCESS: Get_new_ProjectID
          - FAILURE: on_failure
    - Get_new_ProjectID:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${project_details}'
            - json_path: $.id
        publish:
          - project_id: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - Set_scm_type_variable:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${scm_type}'
            - text_to_replace: '${scm_type}'
            - replace_with: "${'\"scm_type\" : \"'+scm_type+'\"'}"
        publish:
          - scm_type: '${replaced_string}'
        navigate:
          - SUCCESS: Create_new_Project
          - FAILURE: on_failure
    - set_scm_type_variable_manual:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${scm_type}'
            - text_to_replace: '${scm_type}'
            - replace_with: '"scm_type" : ""'
        publish:
          - scm_type: '${replaced_string}'
        navigate:
          - SUCCESS: Create_new_Project
          - FAILURE: on_failure
    - Set_scm_url_if_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.default_if_empty:
            - initial_value: '${scm_url}'
            - default_value: 'https://github.com/ansible/ansible-tower-samples'
        publish:
          - scm_url: '${return_result}'
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
  outputs:
    - project_id
    - project_details
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      Set_local_path_if_empty:
        x: 80
        'y': 80
      string_equals:
        x: 241
        'y': 287
      Create_new_Project:
        x: 400
        'y': 80
      Get_new_ProjectID:
        x: 560
        'y': 80
        navigate:
          c218684a-b815-9d80-fb21-a28868518c5e:
            targetId: ad9feb36-6ddc-9e46-5429-4db8d8719bd2
            port: SUCCESS
      Set_scm_type_variable:
        x: 240
        'y': 80
      set_scm_type_variable_manual:
        x: 400
        'y': 280
      Set_scm_url_if_empty:
        x: 80
        'y': 280
    results:
      SUCCESS:
        ad9feb36-6ddc-9e46-5429-4db8d8719bd2:
          x: 560
          'y': 280
