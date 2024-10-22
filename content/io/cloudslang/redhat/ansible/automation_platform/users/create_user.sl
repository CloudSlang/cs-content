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
#! @description: This flow will create a new User object in your Ansible Automation Platform system.
#!
#! @input ansible_automation_platform_url: Ansible Automation Platform API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input ansible_automation_platform_username: Username to connect to Ansible Automation Platform.
#! @input ansible_automation_platform_password: Password used to connect to Ansible Automation Platform.
#! @input new_username: The name (string) of the Ansible Automation Platform User component that you want to create (example: "Demo User").
#! @input password: Password for the new user.
#! @input first_name: User first name.
#! @input last_name: User last name.
#! @input email: Email address for this user.
#! @input is_superuser: Optional - Is this a super user.
#!                      Default: 'false'
#! @input is_system_auditor: Optional - Is this a system auditor.
#!                           Default: 'false'
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - User name used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input trust_keystore: Optional - The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Default value: ''
#! @input trust_password: Optional - The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no trusted certification authority issued it. Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". Default: 'strict'
#! @input worker_group: Optional - When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output user_id: The id (integer) of the newly created User.
#! @output error_message: An error message in case there was an error while creating the User.
#! @output status_code: The HTTP status code of the Ansible Automation Platform API request.
#!
#! @result SUCCESS: The user created successfully.
#! @result FAILURE: There was an error while creating the user.
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.automation_platform.users
flow:
  name: create_user
  inputs:
    - ansible_automation_platform_url
    - ansible_automation_platform_username
    - ansible_automation_platform_password:
        sensitive: true
    - new_username
    - password:
        sensitive: true
    - first_name
    - last_name
    - email
    - is_superuser: 'false'
    - is_system_auditor: 'false'
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
    - create_new_user:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${ansible_automation_platform_url+'/users/'}"
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
            - body: "${'{'+\\\n'   \"username\": \"'+new_username+'\",'+\\\n'   \"first_name\": \"'+first_name+'\",'+\\\n'   \"last_name\": \"'+last_name+'\",'+\\\n'   \"email\": \"'+email+'\",'+\\\n'   \"is_superuser\": '+is_superuser+','+\\\n'   \"is_system_auditor\": '+is_system_auditor+','+\\\n'   \"password\": \"'+password+'\"'+\\\n'}'}"
            - worker_group:
                value: '${worker_group}'
        publish:
          - json_output: '${return_result}'
          - error_message
          - status_code
        navigate:
          - SUCCESS: get_new_user_id
          - FAILURE: on_failure
    - get_new_user_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.id
            - worker_group:
                value: '${worker_group}'
        publish:
          - user_id: '${return_result}'
          - error_message: '${exception}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - user_id: '${user_id}'
    - error_message: '${error_message}'
    - status_code: '${status_code}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      create_new_user:
        x: 80
        'y': 80
      get_new_user_id:
        x: 280
        'y': 80
        navigate:
          d97a692d-8815-d478-bd73-a5050ce9f5e7:
            targetId: 9e182653-0daf-bc71-edee-760b20147b83
            port: SUCCESS
    results:
      SUCCESS:
        9e182653-0daf-bc71-edee-760b20147b83:
          x: 480
          'y': 80

