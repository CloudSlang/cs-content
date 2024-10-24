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
#! @description: This flow will remove a host, inventory, job template and job in Ansible Automation Platform.
#!
#! @input ansible_automation_platform_url: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input ansible_automation_platform_username: Username to connect to Ansible Tower
#! @input ansible_automation_platform_password: Password used to connect to Ansible Automation Platform.
#! @input job_id: Id (integer) of the Job to delete.
#! @input inventory_id: Id (integer) of the Inventory to delete.
#! @input template_id: Id (integer) of the Job Template to delete.
#! @input host_id: Id (integer) of the Host to delete.
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
#! @result SUCCESS: The flow was executed successfully.
#! @result FAILURE: There was an error while executing the flow.
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.core.automation_platform.samples
flow:
  name: remove_host_job_template_and_inventory
  inputs:
    - ansible_automation_platform_url
    - ansible_automation_platform_username
    - ansible_automation_platform_password:
        sensitive: true
    - job_id
    - inventory_id
    - template_id
    - host_id
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
          - SUCCESS: delete_inventory
    - remove_job:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.redhat.ansible.automation_platform.jobs.remove_job:
            - ansible_automation_platform_url: '${ansible_automation_platform_username}'
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
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      delete_inventory:
        x: 400
        'y': 80
      delete_host:
        x: 80
        'y': 80
      delete_job_template:
        x: 240
        'y': 80
      remove_job:
        x: 560
        'y': 80
        navigate:
          fecd22d1-dc24-ce2b-975d-1f4593f2b5f4:
            targetId: d07b125f-d315-af3c-906d-19c62dc2197a
            port: SUCCESS
    results:
      SUCCESS:
        d07b125f-d315-af3c-906d-19c62dc2197a:
          x: 560
          'y': 280

