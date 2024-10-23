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
#! @description: This flow will create a new Job Template object in your Ansible Automation Platform system
#!
#! @input ansible_automation_platform_url: Ansible Automation Platform API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input ansible_automation_platform_username: Username to connect to Ansible Automation Platform
#! @input ansible_automation_platform_password: Password used to connect to Ansible Automation Platform
#! @input template_name: The name (string) of the Ansible Automation Platform Job Template component that you want to create (example: "Demo Template")
#! @input project_id: The Projct id (integer) that this new Job Template is going to use (example: "6")
#! @input playbook: The name of the playbook (string) that you want this Job Template to run (example: hello_world.yml)
#! @input inventory_id: The Inventory id (integer) that you want to associate with this Job Template (example: "1")
#! @input extra_vars: The extra variables (string) that you want to attach to this Job Template (optional) (example: "tipo: /val/lib/ansib_vars")
#! @input proxy_host: Proxy server used to access the web site. Optional
#! @input proxy_port: Proxy server port. Default: '8080' Optional
#! @input proxy_username: Username used when connecting to the proxy. Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value. Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL. Default: 'false' Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all' Default: 'strict' Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that you expect to communicate with, or from Certificate Authorities that you trust to identify other parties. If the protocol (specified by the 'url') is not 'https' or if trust_all_roots is 'true' this input is ignored. Default value: ..JAVA_HOME/java/lib/security/cacerts Format: Java KeyStore (JKS) Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false and trust_keystore is empty, trust_password default will be supplied. Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group simultaneously. Default: 'RAS_Operator_Path' Optional
#!
#! @output template_id: The id (integer) of the newly created Job Template
#!
#! @result FAILURE: New Job Template has been failed.
#! @result SUCCESS: New Job Template has been created successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.automation_platform.job_templates
flow:
  name: create_job_template
  inputs:
    - ansible_automation_platform_url
    - ansible_automation_platform_username
    - ansible_automation_platform_password:
        sensitive: true
    - template_name
    - project_id
    - playbook:
        required: true
    - inventory_id
    - extra_vars:
        default: ' '
        required: true
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
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - create_new_job_template:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${ansible_automation_platform_url+'/job_templates/'}"
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
            - body: "${'{'+\\\n'   \"name\": \"'+template_name+'\",'+\\\n'   \"description\": \"'+template_name+'\",'+\\\n'   \"job_type\": \"run\",'+\\\n'   \"inventory\": '+inventory_id+','+\\\n'   \"project\": '+project_id+','+\\\n'   \"playbook\": \"'+playbook+'\",'+\\\n'   \"scm_branch\": \"\",'+\\\n'   \"forks\": 0,'+\\\n'   \"limit\": \"\",'+\\\n'   \"verbosity\": 0,'+\\\n'   \"extra_vars\": \"'+extra_vars+'\",'+\\\n'   \"job_tags\": \"\",'+\\\n'   \"force_handlers\": false,'+\\\n'   \"skip_tags\": \"\",'+\\\n'   \"start_at_task\": \"\",'+\\\n'   \"timeout\": 0,'+\\\n'   \"use_fact_cache\": false,'+\\\n'   \"host_config_key\": \"\",'+\\\n'   \"ask_scm_branch_on_launch\": false,'+\\\n'   \"ask_diff_mode_on_launch\": false,'+\\\n'   \"ask_variables_on_launch\": false,'+\\\n'   \"ask_limit_on_launch\": false,'+\\\n'   \"ask_tags_on_launch\": false,'+\\\n'   \"ask_skip_tags_on_launch\": false,'+\\\n'   \"ask_job_type_on_launch\": false,'+\\\n'   \"ask_verbosity_on_launch\": false,'+\\\n'   \"ask_inventory_on_launch\": false,'+\\\n'   \"ask_credential_on_launch\": false,'+\\\n'   \"survey_enabled\": false,'+\\\n'   \"become_enabled\": false,'+\\\n'   \"diff_mode\": false,'+\\\n'   \"allow_simultaneous\": false,'+\\\n'   \"custom_virtualenv\": null,'+\\\n'   \"job_slice_count\": 1,'+\\\n'   \"webhook_service\": null,'+\\\n'   \"webhook_credential\": null'+\\\n'}'}"
            - worker_group: '${worker_group}'
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: get_new_job_template_id
          - FAILURE: on_failure
    - get_new_job_template_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.id
        publish:
          - template_id: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - template_id
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_new_job_template:
        x: 97
        'y': 91
      get_new_job_template_id:
        x: 320
        'y': 80
        navigate:
          d3f16ba3-4c0c-1dda-bf12-eb90216243c3:
            targetId: 9a4e8453-d8e7-362e-6069-e90dc4da4657
            port: SUCCESS
    results:
      SUCCESS:
        9a4e8453-d8e7-362e-6069-e90dc4da4657:
          x: 522
          'y': 95

