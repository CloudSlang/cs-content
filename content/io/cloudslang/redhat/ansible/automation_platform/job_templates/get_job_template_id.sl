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
#! @description: This flow will lookup the given Job Template name and return its id.
#!
#! @input ansible_automation_platform_url: Ansible Automation Platform API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input ansible_automation_platform_username: Username to connect to Ansible Automation Platform
#! @input ansible_automation_platform_password: Password used to connect to Ansible Automation Platform
#! @input template_name: The exact Job Template name of the Ansible Automation Platform Job Template component that you want to lookup the id for (example: "Demo Job Template").
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
#! @output template_id: Value of the "id" property of this Ansible Automation Platform component (integer).
#! @output json_output: The response of the Ansible Automation Platform API request in case of success or the error message otherwise.
#! @output status_code: The HTTP status code of the Ansible Automation Platform API request.
#! @output error_message: An error message in case there was an error.
#!
#! @result FAILURE: The template has not been retrieved
#! @result SUCCESS: The job template has been successfully retrieved
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.automation_platform.job_templates
flow:
  name: get_job_template_id
  inputs:
    - ansible_automation_platform_url
    - ansible_automation_platform_username
    - ansible_automation_platform_password:
        sensitive: true
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
    - convert_whitespaces:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.redhat.ansible_tower.utils.search_and_replace:
            - origin_string: '${template_name}'
            - text_to_replace: ' '
            - replace_with: '%20'
        publish:
          - TemplateName: '${replaced_string}'
        navigate:
          - SUCCESS: connect_to_ansible_tower
    - connect_to_ansible_tower:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${ansible_automation_platform_url+'/job_templates?name='+template_name}"
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
          - json_output: '${return_result}'
          - error_message
          - status_code
        navigate:
          - SUCCESS: filter_count_from_json
          - FAILURE: on_failure
    - filter_id_from_json:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: '$.results[*].id'
        publish:
          - template_id: "${return_result.strip('[').strip(']')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - filter_count_from_json:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
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
          - SUCCESS: filter_id_from_json
          - FAILURE: FAILURE
  outputs:
    - template_id
    - json_output: '${json_output}'
    - status_code
    - error_message
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      convert_whitespaces:
        x: 57
        'y': 79
      connect_to_ansible_tower:
        x: 51
        'y': 272
      filter_id_from_json:
        x: 482
        'y': 75
        navigate:
          1931d9dd-3a25-7ed5-85e5-9275a2b4b549:
            targetId: 2e398679-49d5-534e-8413-f1f4e46f370a
            port: SUCCESS
      filter_count_from_json:
        x: 265
        'y': 266
      check_count_is_1:
        x: 263
        'y': 77
        navigate:
          754bef08-5d3c-d689-923a-45e2754b90d6:
            targetId: d55d7b8d-f0b6-a820-b28e-797a1d141a77
            port: FAILURE
    results:
      FAILURE:
        d55d7b8d-f0b6-a820-b28e-797a1d141a77:
          x: 474
          'y': 260
      SUCCESS:
        2e398679-49d5-534e-8413-f1f4e46f370a:
          x: 668
          'y': 83

