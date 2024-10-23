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
#! @description: This flow will look up the given Organization name and return its id.
#!
#! @input ansible_automation_platform_url: Ansible automation platform API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input ansible_automation_platform_username: Username to connect to Ansible automation platform.
#! @input ansible_automation_platform_password: Password used to connect to Ansible automation platform.
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
#! @output organization_id: The value of the "id" property of the organization.
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
  name: get_organization_id
  inputs:
    - ansible_automation_platform_url
    - ansible_automation_platform_username
    - ansible_automation_platform_password:
        sensitive: true
    - organization_name
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
    - convert_whitespaces:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.redhat.ansible_tower.utils.search_and_replace:
            - origin_string: '${organization_name}'
            - text_to_replace: ' '
            - replace_with: '%20'
        publish:
          - organization_name: '${replaced_string}'
        navigate:
          - SUCCESS: get_organization_details
    - get_organization_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${ansible_automation_platform_url+'/organizations?name='+organization_name}"
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
          - organization_details: '${return_result}'
          - status_code
          - return_code
        navigate:
          - SUCCESS: filter_count_from_JSON
          - FAILURE: on_failure
    - filter_ID_from_JSON:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${organization_details}'
            - json_path: '$.results[*].id'
        publish:
          - organization_id: "${return_result.strip('[').strip(']')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - filter_count_from_JSON:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${organization_details}'
            - json_path: $.count
        publish:
          - count: "${return_result.strip('[').strip(']')}"
        navigate:
          - SUCCESS: check_count_is_1
          - FAILURE: on_failure
    - check_count_is_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${count}'
            - second_string: '1'
        navigate:
          - SUCCESS: filter_ID_from_JSON
          - FAILURE: FAILURE
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
      get_organization_details:
        x: 40
        'y': 240
      convert_whitespaces:
        x: 40
        'y': 80
      filter_count_from_JSON:
        x: 200
        'y': 240
      check_count_is_1:
        x: 200
        'y': 80
        navigate:
          754bef08-5d3c-d689-923a-45e2754b90d6:
            targetId: d55d7b8d-f0b6-a820-b28e-797a1d141a77
            port: FAILURE
      filter_ID_from_JSON:
        x: 360
        'y': 80
        navigate:
          1931d9dd-3a25-7ed5-85e5-9275a2b4b549:
            targetId: 2e398679-49d5-534e-8413-f1f4e46f370a
            port: SUCCESS
    results:
      FAILURE:
        d55d7b8d-f0b6-a820-b28e-797a1d141a77:
          x: 360
          'y': 240
      SUCCESS:
        2e398679-49d5-534e-8413-f1f4e46f370a:
          x: 520
          'y': 80
