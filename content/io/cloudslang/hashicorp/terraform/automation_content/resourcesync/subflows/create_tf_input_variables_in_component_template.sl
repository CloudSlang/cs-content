#   Copyright 2023 Open Text
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
#! @description: This flow is used to create the component properties using the terraform input variables list.
#!
#! @input tf_variables_list: The list of  terraform input variables.
#! @input component_template_id: The ID of the terraform component template.
#! @input dnd_host: The hostname of the DND.
#! @input tenant_id: The tenant ID of the DND.
#! @input x_auth_token: The auth token of the DND.
#! @input tf_template_workspace_id: The terraform workspace ID.
#! @input tf_user_auth_token: The user authorization token for terraform.
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
#! @output return_result: It holds the information about the component properties creation.
#! @output return_code: 0 if success, -1 if failure
#! @output error_message: If there is any error while running the flow, it will be populated, empty otherwise
#!
#! @result FAILURE: There was an error while creating the component properties using terraform variables.
#! @result SUCCESS: The component properties are successfully created.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows
flow:
  name: create_tf_input_variables_in_component_template
  inputs:
    - tf_variables_list
    - component_template_id
    - dnd_host
    - tenant_id
    - x_auth_token:
        sensitive: true
    - tf_template_workspace_id
    - tf_user_auth_token:
        sensitive: true
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
    - input_variable_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows.input_variable_list:
            - data: '${tf_variables_list}'
        publish:
          - input_variable_list_return_result: '${return_result}'
        navigate:
          - SUCCESS: list_iterator
    - create_component_template_property:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${'https://'+dnd_host+'/dnd/api/v1/'+tenant_id+'/property'}"
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
            - headers: "${'content-type: application/json\\n'+'Accept: application/json\\n'+'X-Auth-Token:'+x_auth_token}"
            - body: "${'{\"global_id\":\"\",\"@type\":\"\",\"name\": \"tf_input_'+key_name+'\",\"description\":null,\"property_type\":\"STRING\",\"property_value\":\"'+key_value+'\",\"ownership\": null,\"owner\":{\"global_id\":\"'+component_template_id+'\"},\"upgradeLocked\":false,\"bindings\":[],\"ext\":{\"csa_critical_system_object\":false,\"csa_name_key\":\"tf_input_'+key_name+'\",\"csa_consumer_visible\":false,\"csa_confidential\":'+csa_confidential+'},\"visibleWhenDeployDesign\":true,\"requiredWhenDeployDesign\": false}'}"
            - content_type: application/json
            - worker_group: '${worker_group}'
        publish:
          - return_code
          - error_message
          - return_result
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - check_property_key_is_sensitive:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${is_sensitive}'
            - second_string: 'True'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: set_csa_confidential_value_true
          - FAILURE: set_csa_confidential_value_false
    - get_sensitive_input:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows.get_sensitive_input_var_value:
            - tf_template_workspace_id: '${tf_template_workspace_id}'
            - tf_user_auth_token: '${tf_user_auth_token}'
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
          - input_results_keyname
          - input_keyname_keyvalue_list
        navigate:
          - SUCCESS: get_sensitive_value
          - FAILURE: on_failure
    - set_csa_confidential_value_true:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - csa_confidential: 'true'
        publish:
          - csa_confidential
        navigate:
          - SUCCESS: get_sensitive_input
          - FAILURE: on_failure
    - set_csa_confidential_value_false:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - csa_confidential: 'false'
        publish:
          - csa_confidential
        navigate:
          - SUCCESS: create_component_template_property
          - FAILURE: on_failure
    - get_sensitive_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows.get_sensitive_value_python:
            - input_results_keyname: '${input_results_keyname}'
            - input_keyname_keyvalue_list: '${input_keyname_keyvalue_list}'
            - original_keyname: '${key_name}'
        publish:
          - key_value: '${retrieved_keyvalue}'
        navigate:
          - SUCCESS: create_component_template_property
    - list_iterator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${input_variable_list_return_result}'
        publish:
          - result_string
        navigate:
          - HAS_MORE: get_property_key_and_value
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - check_key_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${key_value}'
            - second_string: empty
        navigate:
          - SUCCESS: set_key_value_empty
          - FAILURE: check_property_key_is_sensitive
    - set_key_value_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - key_value: ''
        publish:
          - key_value
        navigate:
          - SUCCESS: check_property_key_is_sensitive
          - FAILURE: on_failure
    - get_property_key_and_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - key_name: '${result_string.split(":::")[0]}'
            - key_value: '${result_string.split(":::")[1]}'
            - is_sensitive: '${result_string.split(":::")[2]}'
        publish:
          - key_name
          - key_value
          - is_sensitive
        navigate:
          - SUCCESS: check_key_value
          - FAILURE: on_failure
  outputs:
    - return_code
    - return_result
    - error_message
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      set_key_value_empty:
        x: 40
        'y': 480
      set_csa_confidential_value_true:
        x: 200
        'y': 480
      get_property_key_and_value:
        x: 200
        'y': 160
      set_csa_confidential_value_false:
        x: 360
        'y': 240
      input_variable_list:
        x: 40
        'y': 80
      list_iterator:
        x: 360
        'y': 80
        navigate:
          83ddc624-d1ca-5e2e-ed87-27bde196c653:
            targetId: c24137a6-111f-83a4-cb98-ee4ece4c1920
            port: NO_MORE
      check_property_key_is_sensitive:
        x: 200
        'y': 320
      create_component_template_property:
        x: 520
        'y': 240
      get_sensitive_input:
        x: 360
        'y': 480
      check_key_value:
        x: 40
        'y': 240
      get_sensitive_value:
        x: 520
        'y': 480
    results:
      SUCCESS:
        c24137a6-111f-83a4-cb98-ee4ece4c1920:
          x: 520
          'y': 80
