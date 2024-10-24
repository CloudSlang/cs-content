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
#! @description: This flow will create a new host, add it to an existing inventory in Ansible Automation Platform. It will then run the given job template against the set inventory, containing the new host.
#!
#! @input ansible_automation_platform_url: Ansible Tower API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input ansible_automation_platform_username: Username to connect to Ansible Automation Platform.
#! @input ansible_automation_platform_password: Password used to connect to Ansible Automation Platform.
#! @input host_name: FQDN or ip address if the host to add.
#! @input inventory_id: ID of the inventory to add the host to.
#! @input host_description: Optional - Description of the host.
#! @input template_id: ID of the Job Template to execute.
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
#! @output host_id: The id (integer) of the new host.
#! @output job_id: The id (integer) of the job.
#! @output job_status: The id (integer) of the job status.
#!
#! @result SUCCESS: The flow was executed successfully.
#! @result FAILURE: There was an error while executing the flow.
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.core.automation_platform.samples
flow:
  name: add_new_host_and_run_existing_job_template
  inputs:
    - ansible_automation_platform_url
    - ansible_automation_platform_username
    - ansible_automation_platform_password:
        sensitive: true
    - host_name
    - inventory_id
    - host_description:
        required: false
    - template_id
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
            - host_description: '${host_description}'
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
                value: '${proxy_password}'
                sensitive: true
            - worker_group: '${worker_group}'
        publish:
          - job_id
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
  outputs:
    - host_id: '${host_id}'
    - job_id: '${job_id}'
    - job_status: '${job_status}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_host:
        x: 80
        'y': 80
      run_job_with_template:
        x: 280
        'y': 80
      wait_for_final_job_result:
        x: 480
        'y': 80
        navigate:
          78650b63-6e7c-3110-dc6a-084e22fc28da:
            targetId: a242faa9-045a-0cf9-b29c-f13214ea7857
            port: SUCCESS
    results:
      SUCCESS:
        a242faa9-045a-0cf9-b29c-f13214ea7857:
          x: 480
          'y': 280

