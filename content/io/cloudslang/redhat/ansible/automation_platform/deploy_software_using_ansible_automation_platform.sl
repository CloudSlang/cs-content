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
#! @description: This flow will deploy software on Ansible Automation Platform.
#!
#! @input ansible_automation_platform_url: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input ansible_automation_platform_username: Username to connect to Ansible Tower
#! @input ansible_automation_platform_password: Password used to connect to Ansible Tower
#! @input org_id: Organization ID (Integer)
#! @input inventory_name: Name of the new inventory to create (string)
#! @input host_name: FQDN or ip address if the host to add (string)
#! @input host_description: Description of the host (optional)
#! @input credential_id: Optional - Enter the Id of the credentials store (integer)
#! @input target_user: Optional - The username of instance or virtual machine.
#! @input target_password: Optional - The password of instance or virtual machine.
#! @input project_id: Enter the project ID number (integer)
#! @input template_name: Enter the name of the job template to create (string)
#! @input playbook: Enter the name of the playbook to run (string)
#! @input extra_vars: (optional) Enter extra vars (example: tipo: /ansible/prodotti/F_Tomcat-9)
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - User name used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the proxy_username input value.
#! @input trust_keystore: Optional - The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ''
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output inventory_id: The id (integer) of the inventory_id.
#! @output job_id: The id (integer) of the job.
#! @output job_status: The id (integer) of the job status.
#! @output template_id: The id (integer) of the template_id.
#! @output host_id: The id (integer) of the new host.
#! @output new_credential_id: The id (integer) of the new credential.
#!
#! @result FAILURE: There was an error while executing the flow.
#! @result SUCCESS: The flow was executed successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.automation_platform
flow:
  name: deploy_software_using_ansible_automation_platform
  inputs:
    - ansible_automation_platform_url
    - ansible_automation_platform_username
    - ansible_automation_platform_password:
        sensitive: true
    - org_id
    - inventory_name
    - host_name
    - host_description:
        default: ' '
        required: false
    - credential_id:
        required: false
    - target_user:
        required: false
    - target_password:
        required: false
        sensitive: true
    - project_id
    - template_name
    - playbook
    - extra_vars:
        default: ' '
        required: false
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
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
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - random_number_generator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.math.random_number_generator:
            - min: '10000'
            - max: '99999'
        publish:
          - random_number: '${random_number}'
        navigate:
          - SUCCESS: append_inventory_name_prefix
          - FAILURE: on_failure
    - create_inventory:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.redhat.ansible.automation_platform.inventories.create_inventory:
            - ansible_automation_platform_url: '${ansible_automation_platform_url}'
            - ansible_automation_platform_username: '${ansible_automation_platform_username}'
            - ansible_automation_platform_password:
                value: '${ansible_automation_platform_password}'
                sensitive: true
            - inventory_name: '${inventory_name_number}'
            - org_id: '${org_id}'
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
          - inventory_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: append_inventory_name_prefix_1
    - create_job_template:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.redhat.ansible.automation_platform.job_templates.create_job_template:
            - ansible_automation_platform_url: '${ansible_automation_platform_url}'
            - ansible_automation_platform_username: '${ansible_automation_platform_username}'
            - ansible_automation_platform_password:
                value: '${ansible_automation_platform_password}'
                sensitive: true
            - template_name: '${final_template_name}'
            - project_id: '${project_id}'
            - playbook: '${playbook}'
            - inventory_id: '${inventory_id}'
            - extra_vars: '${extra_vars}'
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
          - template_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_credential_id_empty
    - attach_credentials_to_job_template:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.redhat.ansible.automation_platform.job_templates.attach_credentials_to_job_template:
            - ansible_automation_platform_url: '${ansible_automation_platform_url}'
            - ansible_automation_platform_username: '${ansible_automation_platform_username}'
            - ansible_automation_platform_password:
                value: '${ansible_automation_platform_password}'
                sensitive: true
            - template_id: '${template_id}'
            - credential_id: '${credential_id}'
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
          - credential_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_host
    - create_host:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.redhat.ansible.automation_platform.hosts.create_host:
            - ansible_automation_platform_url: '${ansible_automation_platform_url}'
            - ansible_automation_platform_username: '${ansible_automation_platform_username}'
            - ansible_automation_platform_password:
                value: '${ansible_automation_platform_password}'
                sensitive: true
            - host_name: '${host_name}'
            - inventory: '${inventory_id}'
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
          - host_id
        navigate:
          - FAILURE: on_failure
          - SUCCESS: run_job_with_template
    - run_job_with_template:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.redhat.ansible.automation_platform.jobs.run_job_with_template:
            - ansible_automation_platform_url: '${ansible_automation_platform_url}'
            - ansible_automation_platform_username: '${ansible_automation_platform_username}'
            - ansible_automation_platform_password:
                value: '${ansible_automation_platform_password}'
                sensitive: true
            - template_id: '${template_id}'
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
          - job_id
          - return_result
          - error_message
          - status_code
        navigate:
          - FAILURE: on_failure
          - SUCCESS: wait_for_final_job_result
    - wait_for_final_job_result:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.redhat.ansible.automation_platform.jobs.wait_for_final_job_result:
            - ansible_automation_platform_url: '${ansible_automation_platform_url}'
            - ansible_automation_platform_username: '${ansible_automation_platform_username}'
            - ansible_automation_platform_password:
                value: '${ansible_automation_platform_password}'
                sensitive: true
            - job_id: '${job_id}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - trust_keystore: '${trust_keystore}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_all_roots: '${trust_all_roots}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - worker_group: '${worker_group}'
        publish:
          - job_status
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - append_inventory_name_prefix:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${inventory_name}'
            - text: '${random_number}'
        publish:
          - inventory_name_number: '${new_string}'
        navigate:
          - SUCCESS: create_inventory
    - append_inventory_name_prefix_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${template_name}'
            - text: '${random_number}'
        publish:
          - final_template_name: '${new_string}'
        navigate:
          - SUCCESS: is_extra_vars_empty
    - is_credential_id_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${credential_id}'
            - second_string: ''
        navigate:
          - SUCCESS: Create_new_Credential
          - FAILURE: attach_credentials_to_job_template
    - Create_new_Credential:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${ansible_automation_platform_url+'/credentials/'}"
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
            - headers: 'Content-Type:application/json'
            - body: "${'{'+\\\n'   \"name\": \"'+host_name+'_credentials\_'+random_number+','+\\\n'   \"description\": \"\",'+\\\n'   \"organization\": '+org_id+','+\\\n'   \"credential_type\": 1,'+\\\n'   \"inputs\": {\"username\":\"'+target_user+'\",\"password\":\"'+target_password+'\"},'+\\\n'   \"user\": null,'+\\\n'   \"team\": null'+\\\n'}'}"
            - worker_group: '${worker_group}'
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: get_new_credential_id
          - FAILURE: on_failure
    - get_new_credential_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.id
        publish:
          - credential_id: '${return_result}'
        navigate:
          - SUCCESS: attach_credentials_to_job_template
          - FAILURE: on_failure
    - convert_json_to_string:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.redhat.ansible.automation_platform.samples.convert_json_to_string:
            - extra_vars: '${extra_vars}'
        publish:
          - extra_vars: "${extra_variables.strip('\"')}"
        navigate:
          - SUCCESS: create_job_template
    - is_extra_vars_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${extra_vars}'
            - second_string: ''
        navigate:
          - SUCCESS: create_job_template
          - FAILURE: convert_json_to_string
  outputs:
    - inventory_id: '${inventory_id}'
    - job_id: '${job_id}'
    - job_status: '${job_status}'
    - template_id: '${template_id}'
    - host_id: '${host_id}'
    - new_credential_id: '${credential_id}'
    - inventory_final_name: '${inventory_name_number}'
    - template_final_name: '${final_template_name}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      attach_credentials_to_job_template:
        x: 720
        'y': 240
      wait_for_final_job_result:
        x: 1000
        'y': 80
        navigate:
          beb94aed-6bd2-9ac3-f564-7ee200e9e014:
            targetId: 9f7dee26-ad4b-d780-a29f-682178d06d70
            port: SUCCESS
      convert_json_to_string:
        x: 240
        'y': 400
      create_host:
        x: 720
        'y': 80
      append_inventory_name_prefix_1:
        x: 560
        'y': 80
      random_number_generator:
        x: 80
        'y': 80
      create_inventory:
        x: 400
        'y': 80
      Create_new_Credential:
        x: 720
        'y': 440
      get_new_credential_id:
        x: 880
        'y': 320
      is_credential_id_empty:
        x: 560
        'y': 440
      run_job_with_template:
        x: 840
        'y': 80
      append_inventory_name_prefix:
        x: 240
        'y': 80
      is_extra_vars_empty:
        x: 240
        'y': 240
      create_job_template:
        x: 560
        'y': 240
    results:
      SUCCESS:
        9f7dee26-ad4b-d780-a29f-682178d06d70:
          x: 1120
          'y': 80
