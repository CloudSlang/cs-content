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
#! @description: This flow will create a new Credential object in your Ansible Automation Platform system
#!
#! @input ansible_automation_platform_url: Ansible Automation Platform API URL to connect to (example: https://192.168.10.10/api/v2)
#! @input ansible_automation_platform_username: Username to connect to Ansible Automation Platform
#! @input ansible_automation_platform_password: Password used to connect to Ansible Automation Platform
#! @input credential_name: The name (string) of the Ansible Automation Platform Credential component that you want to create (example: "Demo Credential").
#! @input credential_type: The type (integer) of the new Credential (example: "1" for "Machine", "2" for "scm" etc). To get a list of credential_types, access https://your.ansibleserver.org/api/v2/credential_types
#! @input credential_description: The description of this new Credential (optional)
#! @input org_id: The Organization id (integer) for the Organization to create the new Credential into
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
#! @output CredentialID: The id (integer) of the newly created Credential
#!
#! @result FAILURE: Error in creating Credential in Ansible Automation Platform.
#! @result SUCCESS: The  Credential has been successfully created in Ansible Automation Platform .
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.automation_platform.credentials
flow:
  name: create_credential
  inputs:
    - ansible_automation_platform_url
    - ansible_automation_platform_username
    - ansible_automation_platform_password:
        sensitive: true
    - credential_name
    - credential_type
    - credential_description:
        default: ' '
        required: false
    - org_id
    - proxy_host:
        required: false
    - proxy_port:
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
    - Create_new_Credential:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${ansible_automation_platform_url+'/credentials/'}"
            - auth_type: basic
            - username: "${ansible_automation_platform_username}"
            - password:
                value: "${ansible_automation_platform_password}"
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
            - keystore: null
            - headers: 'Content-Type:application/json'
            - body: "${'{'+\\\n'   \"name\": \"'+credential_name+'\",'+\\\n'   \"description\": \"'+credential_description+'\",'+\\\n'   \"organization\": '+org_id+','+\\\n'   \"credential_type\": '+credential_type+','+\\\n'   \"inputs\": {},'+\\\n'   \"user\": null,'+\\\n'   \"team\": null'+\\\n'}'}"
            - worker_group: '${worker_group}'
        publish:
          - json_output: '${return_result}'
        navigate:
          - SUCCESS: Get_new_Credential_ID
          - FAILURE: on_failure
    - Get_new_Credential_ID:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_output}'
            - json_path: $.id
        publish:
          - CredentialID: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - CredentialID: '${CredentialID}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      Create_new_Credential:
        x: 97
        'y': 91
      Get_new_Credential_ID:
        x: 319
        'y': 92
        navigate:
          d3f16ba3-4c0c-1dda-bf12-eb90216243c3:
            targetId: 9a4e8453-d8e7-362e-6069-e90dc4da4657
            port: SUCCESS
    results:
      SUCCESS:
        9a4e8453-d8e7-362e-6069-e90dc4da4657:
          x: 522
          'y': 95

