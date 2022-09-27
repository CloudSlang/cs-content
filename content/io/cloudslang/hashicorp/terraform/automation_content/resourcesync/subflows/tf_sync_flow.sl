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
#! @description: This flow is used to create templates from terraform workspace.
#!
#! @input host: DND host.
#! @input tenant_id: DND tenant id
#! @input dnd_user: The DND username.
#! @input dnd_password: The DND password.
#! @input tf_user_auth_token: The terraform user token.
#! @input tf_template_organization_name: The terraform organization name.
#! @input tf_component_id: Component id.
#!                         Default: 'bb9cb58417414d618ece96e43911dba2'
#! @input proxy_host: Proxy server used to access the Terraform service.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Terraform service.
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no
#!                         trusted certification authority issued it.
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to
#!                                 "allow_all" to skip any checking. For the value "browser_compatible" the hostname
#!                                 verifier works the same way as Curl and Firefox. The hostname must match either the
#!                                 first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of
#!                                 the subject-alts. The only difference between "browser_compatible" and "strict" is
#!                                 that a wildcard (such as "*.foo.com") with "browser_compatible" matches all
#!                                 subdomains, including "a.b.foo.com".
#!                                 Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that
#!                        you expect to communicate with, or from Certificate Authorities that you trust to identify
#!                        other parties.  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is
#!                        'true' this input is ignored. Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystore
#!                        is empty, trustPassword default will be supplied.
#!                        Optional
#!
#! @output output_variable_key_list: It holds the information about the component properties creation.
#!
#! @result FAILURE: There was an error while creating the component properties using terraform variables.
#! @result SUCCESS: The component properties are successfully created.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows
flow:
  name: tf_sync_flow
  inputs:
    - host
    - tenant_id
    - dnd_username
    - dnd_password:
        sensitive: true
    - tf_user_auth_token:
        sensitive: true
    - tf_template_organization_name
    - component_id: bb9cb58417414d618ece96e43911dba2
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
    - create_dnd_auth_token:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.microfocus.content.create_dnd_auth_token:
            - dnd_host: '${host}'
            - dnd_username: '${dnd_username}'
            - dnd_password:
                value: '${dnd_password}'
                sensitive: true
            - tenant_id: '${tenant_id}'
        publish:
          - dnd_auth_token
        navigate:
          - SUCCESS: list_all_resource_offering_details
          - FAILURE: on_failure
    - get_tf_variables:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows.get_tf_variables:
            - tf_user_auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - tf_template_organization_name: '${tf_template_organization_name}'
            - tf_template_workspace_name: '${workspace_name}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - worker_group: '${worker_group}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - tf_variables_list: '${tf_variables_list}'
          - tf_template_workspace_id
          - tf_template_vcs_repo_identifier
          - tf_output_variable_key_list: '${output_variable_key_list}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_component_template
    - list_workspaces:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.workspaces.list_workspaces:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - organization_name: '${tf_template_organization_name}'
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
          - workspace_list
        navigate:
          - SUCCESS: list_templates_in_component
          - FAILURE: on_failure
    - list_iterator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${workspace_list}'
        publish:
          - workspace_name: '${result_string}'
        navigate:
          - HAS_MORE: string_equals
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - create_component_template:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.microfocus.content.create_component_template:
            - dnd_host: '${host}'
            - tenant_id: '${tenant_id}'
            - dnd_auth_token:
                value: '${dnd_auth_token}'
                sensitive: true
            - component_id: '${component_id}'
            - template_name: '${tf_template_workspace_id}'
            - template_display_name: '${workspace_name}'
            - template_icon: terraform.png?tag=library
        publish:
          - component_template_id
        navigate:
          - SUCCESS: create_component_template_property_template_workspace_is
          - FAILURE: on_failure
    - create_component_template_property_template_workspace_is:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.microfocus.content.create_component_template_property:
            - dnd_host: '${host}'
            - tenant_id: '${tenant_id}'
            - dnd_auth_token:
                value: '${dnd_auth_token}'
                sensitive: true
            - template_id: '${component_template_id}'
            - property_name: tf_template_workspace_id
            - property_value: '${tf_template_workspace_id}'
        navigate:
          - SUCCESS: create_component_template_property_instance_workspace_is
          - FAILURE: on_failure
    - create_component_template_property_instance_workspace_is:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.microfocus.content.create_component_template_property:
            - dnd_host: '${host}'
            - tenant_id: '${tenant_id}'
            - dnd_auth_token:
                value: '${dnd_auth_token}'
                sensitive: true
            - template_id: '${component_template_id}'
            - property_name: tf_instance_workspace_id
        navigate:
          - SUCCESS: create_component_template_property_templ_workspace_name
          - FAILURE: on_failure
    - create_tf_input_variables_in_component_template:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows.create_tf_input_variables_in_component_template:
            - tf_variables_list: '${tf_variables_list}'
            - component_template_id: '${component_template_id}'
            - dnd_host: '${host}'
            - tenant_id: '${tenant_id}'
            - x_auth_token: '${dnd_auth_token}'
            - tf_template_workspace_id: '${tf_template_workspace_id}'
            - tf_user_auth_token: '${tf_user_auth_token}'
            - proxy_host: "${get_sp('io.cloudslang.microfocus.content.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.microfocus.content.proxy_port')}"
            - proxy_username: "${get_sp('io.cloudslang.microfocus.content.proxy_username')}"
            - proxy_password:
                value: "${get_sp('io.cloudslang.microfocus.content.proxy_password')}"
                sensitive: true
            - trust_all_roots: "${get_sp('io.cloudslang.microfocus.content.trust_all_roots')}"
            - x_509_hostname_verifier: "${get_sp('io.cloudslang.microfocus.content.x_509_hostname_verifier')}"
            - trust_keystore: "${get_sp('io.cloudslang.microfocus.content.trust_keystore')}"
            - trust_password:
                value: "${get_sp('io.cloudslang.microfocus.content.trust_password')}"
                sensitive: true
            - worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_tf_output_variables_in_component_template
    - create_tf_output_variables_in_component_template:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows.create_tf_output_variables_in_component_template:
            - tf_output_variable_key_list: '${tf_output_variable_key_list}'
            - component_template_id: '${component_template_id}'
            - dnd_host: '${host}'
            - tenant_id: '${tenant_id}'
            - x_auth_token: '${dnd_auth_token}'
            - proxy_host: "${get_sp('io.cloudslang.microfocus.content.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.microfocus.content.proxy_port')}"
            - tf_template_vcs_repo_identifier: '${tf_template_vcs_repo_identifier}'
            - proxy_username: "${get_sp('io.cloudslang.microfocus.content.proxy_username')}"
            - proxy_password:
                value: "${get_sp('io.cloudslang.microfocus.content.proxy_password')}"
                sensitive: true
            - trust_all_roots: "${get_sp('io.cloudslang.microfocus.content.trust_all_roots')}"
            - x_509_hostname_verifier: "${get_sp('io.cloudslang.microfocus.content.x_509_hostname_verifier')}"
            - trust_keystore: "${get_sp('io.cloudslang.microfocus.content.trust_keystore')}"
            - trust_password:
                value: "${get_sp('io.cloudslang.microfocus.content.trust_password')}"
                sensitive: true
            - worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: associate_ro_in_template
    - associate_ro_in_template:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.microfocus.content.associate_ro_in_template:
            - dnd_host: '${host}'
            - tenant_id: '${tenant_id}'
            - dnd_auth_token:
                value: '${dnd_auth_token}'
                sensitive: true
            - template_id: '${component_template_id}'
            - resource_offering_id: '${ro_id}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - list_all_resource_offering_details:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.microfocus.content.list_all_resource_offering_details:
            - dnd_host: '${host}'
            - tenant_id: '${tenant_id}'
            - x_auth_token: '${dnd_auth_token}'
        publish:
          - return_result
          - status_code
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_ro_id
    - get_ro_id:
        worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        do:
          io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows.get_ro_id_python:
            - ro_list: '${return_result}'
        publish:
          - ro_id: '${ro_id.split("/resource/offering/")[1]}'
        navigate:
          - SUCCESS: list_workspaces
    - create_component_template_property_templ_workspace_name:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.microfocus.content.create_component_template_property:
            - dnd_host: '${host}'
            - tenant_id: '${tenant_id}'
            - dnd_auth_token:
                value: '${dnd_auth_token}'
                sensitive: true
            - template_id: '${component_template_id}'
            - property_name: tf_template_workspace_name
            - property_value: '${workspace_name}'
        navigate:
          - SUCCESS: create_tf_input_variables_in_component_template
          - FAILURE: on_failure
    - get_workspace_details:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.workspaces.get_workspace_details:
            - auth_token:
                value: '${tf_user_auth_token}'
                sensitive: true
            - organization_name: '${tf_template_organization_name}'
            - workspace_name: '${workspace_name}'
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
          - workspace_id
        navigate:
          - SUCCESS: check_template_exists
          - FAILURE: on_failure
    - list_templates_in_component:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.microfocus.content.list_templates_in_component:
            - dnd_host: '${host}'
            - tenant_id: '${tenant_id}'
            - dnd_auth_token:
                value: '${dnd_auth_token}'
                sensitive: true
            - component_id: '${component_id}'
        publish:
          - templates_result: '${return_result}'
          - template_count
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${template_count}'
            - second_string: '0'
        navigate:
          - SUCCESS: get_tf_variables
          - FAILURE: get_workspace_details
    - check_template_exists:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.microfocus.content.utils.check_template_exists:
            - template_list_json: '${templates_result}'
            - template_name: '${workspace_name}'
            - template_key: '${workspace_id}'
        publish:
          - template_id
          - result_string
        navigate:
          - SUCCESS: check_template_id_empty
    - check_template_id_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${template_id}'
        navigate:
          - SUCCESS: get_tf_variables
          - FAILURE: check_template_display_name
    - check_template_display_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${result_string}'
            - second_string: same
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: update_component_template
    - update_component_template:
        worker_group:
          value: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
          override: true
        do:
          io.cloudslang.microfocus.content.update_component_template:
            - dnd_host: '${host}'
            - tenant_id: '${tenant_id}'
            - dnd_auth_token:
                value: '${dnd_auth_token}'
                sensitive: true
            - template_id: '${template_id}'
            - request_body: "${'{\"name\": \"'+workspace_name+'\"}'}"
        publish:
          - return_result
          - status_code
          - return_code
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
  outputs:
    - component_template_id: '${component_template_id}'
    - tf_source_vcs_repo_identifier: '${tf_source_vcs_repo_identifier}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_component_template_property_templ_workspace_name:
        x: 720
        'y': 480
      list_templates_in_component:
        x: 760
        'y': 80
      check_template_exists:
        x: 280
        'y': 400
      create_dnd_auth_token:
        x: 80
        'y': 80
      string_equals:
        x: 80
        'y': 280
      create_component_template_property_template_workspace_is:
        x: 400
        'y': 640
      create_tf_input_variables_in_component_template:
        x: 720
        'y': 640
      list_iterator:
        x: 400
        'y': 280
        navigate:
          50aa2f9d-51db-6a5a-1d58-f5ca92e97cc0:
            targetId: b79ac630-86cf-5ab0-94c1-93de1aa81b22
            port: NO_MORE
      get_workspace_details:
        x: 160
        'y': 400
      update_component_template:
        x: 640
        'y': 360
      get_tf_variables:
        x: 80
        'y': 640
      associate_ro_in_template:
        x: 880
        'y': 280
      create_component_template_property_instance_workspace_is:
        x: 560
        'y': 640
      get_ro_id:
        x: 400
        'y': 80
      check_template_display_name:
        x: 520
        'y': 480
      check_template_id_empty:
        x: 400
        'y': 480
      create_tf_output_variables_in_component_template:
        x: 880
        'y': 640
      list_all_resource_offering_details:
        x: 240
        'y': 80
      list_workspaces:
        x: 560
        'y': 80
      create_component_template:
        x: 240
        'y': 640
    results:
      SUCCESS:
        b79ac630-86cf-5ab0-94c1-93de1aa81b22:
          x: 640
          'y': 200
