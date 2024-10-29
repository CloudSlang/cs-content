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
#! @description: This flow will delete a Job Template object in your Ansible Automation Platform system
#!
#! @input ansible_automation_platform_url: Ansible Automation Platform API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input ansible_automation_platform_username: Username to connect to Ansible Automation Platform
#! @input ansible_automation_platform_password: Password used to connect to Ansible Automation Platform
#! @input template_id: The ID (integrer) of the Ansible Automation Platform Job Template component that you want to delete (example: "15").
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
#! @output return_result: The response of the Ansible Automation Platform API request in case of success or the error message otherwise.
#! @output error_message: An error message in case there was an error.
#! @output status_code: The HTTP status code of the Ansible Automation Platform API request.
#!
#! @result FAILURE: The Deletion of Job tempaltes has been failed.
#! @result SUCCESS: The Job templates has been deleted successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.automation_platform.job_templates
flow:
  name: delete_job_template
  inputs:
    - ansible_automation_platform_url
    - ansible_automation_platform_username
    - ansible_automation_platform_password:
        sensitive: true
    - template_id
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
    - delete_job_template:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_delete:
            - url: "${ansible_automation_platform_url+'/job_templates/'+template_id+'/'}"
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
            - worker_group: '${worker_group}'
        publish:
          - return_result
          - error_message
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result
    - error_message
    - status_code
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      delete_job_template:
        x: 80
        'y': 80
        navigate:
          74804904-02f4-ef09-6abe-63c4c06d0e39:
            targetId: 981d4b12-5e7d-e856-ca53-3eb4619daa0e
            port: SUCCESS
    results:
      SUCCESS:
        981d4b12-5e7d-e856-ca53-3eb4619daa0e:
          x: 339
          'y': 77

