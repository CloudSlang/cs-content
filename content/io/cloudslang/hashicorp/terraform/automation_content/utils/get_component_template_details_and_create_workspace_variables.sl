#   (c) Copyright 2022 Micro Focus, L.P.
#   All rights reserved. This program and the accompanying materials
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
#! @description: This flow is used to terraform workspace variables in the given organization.
#!
#! @input component_template_id: The component template id.
#! @input tf_user_auth_token: The authorization token for terraform.
#! @input tf_instance_workspace_id: The terraform workspace ID of the instance org.
#! @input dnd_username: The user name of DND.
#! @input user_identifier: The user identifier value.
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input proxy_host: Proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: Proxy server port.
#!                    Optional
#! @input proxy_username: Username used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#!                                 Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#!
#! @output property_value_list: The list of property values.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.automation_content.utils.final
flow:
  name: get_component_template_details_and_create_workspace_variables
  inputs:
    - component_template_id
    - tf_user_auth_token:
        required: true
        sensitive: true
    - tf_instance_workspace_id
    - dnd_username
    - user_identifier
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
  workflow:
    - get_artifact_properties:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.hashicorp.terraform.automation_content.utils.get_template_properties:
            - user_identifier: '${user_identifier}'
            - artifact_id: '${component_template_id}'
        publish:
          - property_value_list
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_variables_json_python
    - create_variables_json_python:
        worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        do:
          io.cloudslang.hashicorp.terraform.automation_content.utils.create_variables_json_python:
            - property_value_list: '${property_value_list}'
        publish:
          - sensitive_json
          - non_sensitive_json
        navigate:
          - SUCCESS: create_workspace_variables_v2
    - create_workspace_variables_v2:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.hashicorp.terraform.workspaces.variables.create_workspace_variables_v2:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - workspace_id:
                value: '${tf_instance_workspace_id}'
                sensitive: true
            - sensitive_workspace_variables_json: '${sensitive_json}'
            - workspace_variables_json: '${non_sensitive_json}'
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
        publish:
          - create_workspace_variables_output
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - property_value_list
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_artifact_properties:
        x: 80
        'y': 160
      create_variables_json_python:
        x: 200
        'y': 160
      create_workspace_variables_v2:
        x: 320
        'y': 160
        navigate:
          f5ffce52-1899-2975-52db-d10900ad6a81:
            targetId: 8a42da71-eff6-fb01-3900-cb40d2bc4e36
            port: SUCCESS
    results:
      SUCCESS:
        8a42da71-eff6-fb01-3900-cb40d2bc4e36:
          x: 480
          'y': 160
