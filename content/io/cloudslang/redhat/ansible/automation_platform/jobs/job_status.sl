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
#! @description: Check the Job status, based on the job id.
#!
#! @input ansible_automation_platform_url: Ansible Automation Platform API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input ansible_automation_platform_username: Username to connect to Ansible Automation Platform
#! @input ansible_automation_platform_password: Password used to connect to Ansible Automation Platform
#! @input job_id: The id (integer) of the job you want the check the status for
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
#! @input trust_keystore: Optional - The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Default value: ''
#! @input trust_password: Optional - The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output job_status: The status of the job. Possible values: Pending, Running, Failed, Successful
#! @output return_result: The response of the Ansible Automation Platform API request in case of success or the error message otherwise.
#! @output status_code: The HTTP status code of the Ansible Automation Platform API request.
#! @output error_message: An error message in case there was an error while fetching job status.
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.automation_platform.jobs
flow:
  name: job_status
  inputs:
    - ansible_automation_platform_url
    - ansible_automation_platform_username
    - ansible_automation_platform_password:
        sensitive: true
    - job_id
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
    - Get_information_for_JobID:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${ansible_automation_platform_url+'/jobs/'+job_id}"
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
          - json_output: '${return_result}'
          - status_code
          - error_message
        navigate:
          - SUCCESS: Extract_status_from_JSON
          - FAILURE: on_failure
    - Extract_status_from_JSON:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.status
        publish:
          - status: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - job_status: '${status}'
    - return_result: '${json_output}'
    - status_code: '${status_code}'
    - error_message: '${error_message}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Get_information_for_JobID:
        x: 63
        'y': 92
      Extract_status_from_JSON:
        x: 306
        'y': 97
        navigate:
          c9d9758d-6c23-0e02-3492-2e197e1854e9:
            targetId: 8ebb9e4e-6057-7dd1-a67a-a81f4a40147f
            port: SUCCESS
    results:
      SUCCESS:
        8ebb9e4e-6057-7dd1-a67a-a81f4a40147f:
          x: 538
          'y': 104

