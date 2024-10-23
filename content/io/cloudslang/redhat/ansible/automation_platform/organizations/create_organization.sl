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
#! @description: This flow will create a new organization object in the given Ansible Automation Platform instance.
#!
#! @input ansible_automation_platform_url: Ansible Automation Platform API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input ansible_automation_platform_username: Username to connect to Ansible Automation Platform
#! @input ansible_automation_platform_password: Password used to connect to Ansible Automation Platform
#! @input organization_name: The name (string) of the Ansible Automation Platform Organization component that you want to create (example: "Demo Organization").
#! @input description: Optional - The description of this new Organization
#! @input max_hosts: Optional - The maximum amount of allowed hosts.
#! @input custom_virtual_env: Optional - The virtual env for a the organization.
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
#! @output organization_id: The id of newly created organization.
#! @output organization_details: A JSON output containing details of the organization.
#! @output status_code: status code of the HTTP call
#! @output return_code: '0' if success, '-1' otherwise
#!
#! @result FAILURE: There was an error while executing the request.
#! @result SUCCESS: The request was successfully executed.
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.automation_platform.organizations
flow:
  name: create_organization
  inputs:
    - ansible_automation_platform_url
    - ansible_automation_platform_username
    - ansible_automation_platform_password:
        sensitive: true
    - organization_name
    - description:
        default: ' '
        required: false
    - max_hosts:
        default: '0'
        required: false
    - custom_virtual_env:
        default: 'null'
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
    - worker_group:
        default: RAS_Operator_Path
        required: false
    - trust_all_roots: 'false'
    - x_509_hostname_verifier: strict
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
  workflow:
    - create_new_organization:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${ansible_automation_platform_url+'/organizations/'}"
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
            - body: "${'{'+\\\n'   \"name\": \"'+organization_name+'\",'+\\\n'   \"description\": \"'+description+'\",'+\\\n'   \"max_hosts\": '+max_hosts+','+\\\n'   \"custom_virtualenv\": '+custom_virtual_env+\\\n'}'}"
            - worker_group: '${worker_group}'
        publish:
          - organization_details: '${return_result}'
          - status_code
          - return_code
        navigate:
          - SUCCESS: get_organization_id
          - FAILURE: on_failure
    - get_organization_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.id
        publish:
          - organization_id: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - organization_id: '${organization_id}'
    - organization_details: '${organization_details}'
    - status_code
    - return_code
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_new_organization:
        x: 80
        'y': 80
      get_organization_id:
        x: 280
        'y': 80
        navigate:
          d3f16ba3-4c0c-1dda-bf12-eb90216243c3:
            targetId: 9a4e8453-d8e7-362e-6069-e90dc4da4657
            port: SUCCESS
    results:
      SUCCESS:
        9a4e8453-d8e7-362e-6069-e90dc4da4657:
          x: 480
          'y': 80
