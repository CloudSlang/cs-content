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
#! @description: Loop through a job status until either failed or successful and reports back the final status
#!
#! @input ansible_automation_platform_url: Ansible Automation Platform API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input ansible_automation_platform_username: Username to connect to Ansible Automation Platform
#! @input ansible_automation_platform_password: Password used to connect to Ansible Automation Platform
#! @input job_id: The id(integer) of the job to watch
#! @input loops: Amount of 10-seconds loops to watch for a final jab status
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input trust_password: Optional - The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input trust_keystore: Optional - The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Default value: ''
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input proxy_username: Optional - User name used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output job_status: The final job status
#!
#! @result FAILURE: There was an error while looping through the job status.
#! @result SUCCESS: The job final status has been fetched successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.automation_platform.jobs
flow:
  name: wait_for_final_job_result
  inputs:
    - ansible_automation_platform_url
    - ansible_automation_platform_username
    - ansible_automation_platform_password:
        sensitive: true
    - job_id:
        required: true
    - loops: '10'
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - trust_keystore:
        required: false
    - x_509_hostname_verifier:
        default: strict
        required: false
    - trust_all_roots:
        default: 'false'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - job_status:
        worker_group:
          value: '${worker_group}'
          override: true
        loop:
          for: i in loops
          do:
            io.cloudslang.redhat.ansible.automation_platform.jobs.job_status:
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
          break:
            - FAILURE
          publish:
            - job_status
            - return_result
        navigate:
          - FAILURE: on_failure
          - SUCCESS: Is_status_successful
    - Is_status_successful:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${job_status}'
            - second_string: successful
            - ignore_case: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: Is_status_failed
    - Is_status_failed:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${job_status}'
            - second_string: failed
            - ignore_case: 'true'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: Is_status_pending
    - Is_status_pending:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${job_status}'
            - second_string: pending
            - ignore_case: 'true'
        navigate:
          - SUCCESS: sleep
          - FAILURE: Is_status_runnning
    - Is_status_runnning:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${job_status}'
            - second_string: running
            - ignore_case: 'true'
        navigate:
          - SUCCESS: sleep
          - FAILURE: on_failure
    - sleep:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '10'
        navigate:
          - SUCCESS: job_status
          - FAILURE: on_failure
  outputs:
    - job_status: '${job_status}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      job_status:
        x: 160
        'y': 160
      Is_status_successful:
        x: 400
        'y': 160
        navigate:
          b4a458d2-013b-70e7-eca1-a8f28f2d8794:
            targetId: 16669dff-554d-a24f-6d6f-39e30c8c1c8d
            port: SUCCESS
      Is_status_failed:
        x: 400
        'y': 360
        navigate:
          99d177f2-d2f1-fbf6-c6b9-e23b86005560:
            targetId: bb28f55c-281b-8d13-71da-cec8a32fa709
            port: SUCCESS
      Is_status_pending:
        x: 400
        'y': 560
      Is_status_runnning:
        x: 160
        'y': 560
      sleep:
        x: 160
        'y': 360
    results:
      FAILURE:
        bb28f55c-281b-8d13-71da-cec8a32fa709:
          x: 640
          'y': 360
      SUCCESS:
        16669dff-554d-a24f-6d6f-39e30c8c1c8d:
          x: 656
          'y': 159

