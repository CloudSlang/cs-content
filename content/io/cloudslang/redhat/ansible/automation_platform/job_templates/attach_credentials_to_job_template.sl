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
#! @description: Attach a Credential component to a Job Template component. Use id (integer) for both.
#!
#! @input ansible_automation_platform_url: Ansible Automation Platform API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input ansible_automation_platform_username: Username to connect to Ansible Automation Platform
#! @input ansible_automation_platform_password: Password used to connect to Ansible Automation Platform
#! @input template_id: Enter the Job Template ID (integer)
#! @input credential_id: Enter the Credential ID (integer)
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
#! @result FAILURE: Credential component has not been attached to a job template component.
#! @result SUCCESS: Credential component has been attached to a job template component successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.automation_platform.job_templates
flow:
  name: attach_credentials_to_job_template
  inputs:
    - ansible_automation_platform_url
    - ansible_automation_platform_username
    - ansible_automation_platform_password:
        sensitive: true
    - template_id
    - credential_id
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
    - attach_credential_id_to_job_template_id:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${ansible_automation_platform_url+'/job_templates/'+template_id+'/credentials/'}"
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
            - body: "${'{'+\\\n'   \"id\": '+credential_id+\\\n'}'}"
            - worker_group: '${worker_group}'
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      attach_credential_id_to_job_template_id:
        x: 120
        'y': 160
        navigate:
          a7aadae2-791e-76fa-cafe-81311af1a021:
            targetId: 1443236e-9882-ab05-5df0-9d94dd8b32ab
            port: SUCCESS
    results:
      SUCCESS:
        1443236e-9882-ab05-5df0-9d94dd8b32ab:
          x: 350
          'y': 155

