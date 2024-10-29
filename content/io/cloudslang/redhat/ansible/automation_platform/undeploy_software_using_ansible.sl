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
#! @description: This flow will uninstall software from the Ansible Automation Platform.
#!
#! @input ansible_automation_platform_url: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input ansible_automation_platform_username: Username to connect to Ansible Tower
#! @input ansible_automation_platform_password: Password used to connect to Ansible Automation Platform.
#! @input job_id: Id (integer) of the Job to delete.
#! @input inventory_id: Id (integer) of the Inventory to delete.
#! @input template_id: Id (integer) of the Job Template to delete.
#! @input host_id: Id (integer) of the Host to delete.
#! @input project_id: Enter the project ID number (integer)
#! @input credential_id: Enter the Id of the credentials store (integer)
#! @input playbook: Enter the name of the playbook to run (string)
#! @input template_name: The name (string) of the Ansible Automation Platform Job Template component that you want to create (example: "Demo Template")
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
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @result FAILURE: There was an error while executing the flow.
#! @result SUCCESS: The flow was executed successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.automation_platform
flow:
  name: undeploy_software_using_ansible
  inputs:
    - ansible_automation_platform_url
    - ansible_automation_platform_username
    - ansible_automation_platform_password:
        sensitive: true
    - job_id
    - inventory_id
    - template_id
    - host_id
    - project_id
    - credential_id:
        required: true
    - playbook
    - template_name
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
    - append_inventory_name_prefix:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${template_name}'
            - text: '${random_number}'
        publish:
          - final_template_name: '${new_string}'
        navigate:
          - SUCCESS: create_job_template
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
          - template_id_new: '${template_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: run_job_with_template
    - delete_host:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.redhat.ansible.automation_platform.hosts.delete_host:
            - ansible_automation_platform_url: '${ansible_automation_platform_url}'
            - ansible_automation_platform_username: '${ansible_automation_platform_username}'
            - ansible_automation_platform_password:
                value: '${ansible_automation_platform_password}'
                sensitive: true
            - host_id: '${host_id}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - worker_group: '${worker_group}'
            - trust_keystore: '${trust_keystore}'
            - trust_password: '${trust_password}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: delete_job_template
    - delete_inventory:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.redhat.ansible.automation_platform.inventories.delete_inventory:
            - ansible_automation_platform_url: '${ansible_automation_platform_url}'
            - ansible_automation_platform_username: '${ansible_automation_platform_username}'
            - ansible_automation_platform_password:
                value: '${ansible_automation_platform_password}'
                sensitive: true
            - inventory_id: '${inventory_id}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - worker_group: '${worker_group}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: remove_job
    - delete_job_template:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.redhat.ansible.automation_platform.job_templates.delete_job_template:
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
        navigate:
          - FAILURE: on_failure
          - SUCCESS: remove_job_template
    - remove_job:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.redhat.ansible.automation_platform.jobs.remove_job:
            - ansible_automation_platform_url: '${ansible_automation_platform_url}'
            - ansible_automation_platform_username: '${ansible_automation_platform_username}'
            - ansible_automation_platform_password:
                value: '${ansible_automation_platform_password}'
                sensitive: true
            - job_id: '${job_id}'
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
        navigate:
          - FAILURE: on_failure
          - SUCCESS: delete_job
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
          - SUCCESS: sleep
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
          - final_job_id: '${job_id}'
          - return_result
          - error_message
          - status_code
        navigate:
          - FAILURE: on_failure
          - SUCCESS: wait_for_final_job_result
    - delete_job:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.redhat.ansible.automation_platform.jobs.remove_job:
            - ansible_automation_platform_url: '${ansible_automation_platform_url}'
            - ansible_automation_platform_username: '${ansible_automation_platform_username}'
            - ansible_automation_platform_password:
                value: '${ansible_automation_platform_password}'
                sensitive: true
            - job_id: '${final_job_id}'
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
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - remove_job_template:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.redhat.ansible.automation_platform.job_templates.delete_job_template:
            - ansible_automation_platform_url: '${ansible_automation_platform_url}'
            - ansible_automation_platform_username: '${ansible_automation_platform_username}'
            - ansible_automation_platform_password:
                value: '${ansible_automation_platform_password}'
                sensitive: true
            - template_id: '${template_id_new}'
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
        navigate:
          - FAILURE: on_failure
          - SUCCESS: delete_inventory
    - sleep:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '60'
        navigate:
          - SUCCESS: delete_host
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      remove_job:
        x: 720
        'y': 120
      wait_for_final_job_result:
        x: 240
        'y': 480
      delete_inventory:
        x: 600
        'y': 120
      delete_job:
        x: 880
        'y': 120
        navigate:
          be9d2db4-1e06-ac4a-6b6b-376e427406b6:
            targetId: d07b125f-d315-af3c-906d-19c62dc2197a
            port: SUCCESS
      delete_job_template:
        x: 760
        'y': 480
      remove_job_template:
        x: 600
        'y': 280
      sleep:
        x: 400
        'y': 480
      random_number_generator:
        x: 80
        'y': 120
      delete_host:
        x: 600
        'y': 480
      run_job_with_template:
        x: 80
        'y': 480
      append_inventory_name_prefix:
        x: 280
        'y': 120
      create_job_template:
        x: 480
        'y': 120
    results:
      SUCCESS:
        d07b125f-d315-af3c-906d-19c62dc2197a:
          x: 1120
          'y': 120

