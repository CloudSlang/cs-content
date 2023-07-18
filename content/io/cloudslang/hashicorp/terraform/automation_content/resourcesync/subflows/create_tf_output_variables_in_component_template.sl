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
#! @description: This flow is used to create the component properties using the terraform output variables list.
#!
#! @input tf_output_variable_key_list: The list of  terraform output variables.
#! @input component_template_id: The ID of the terraform component template.
#! @input dnd_host: The hostname of the DND.
#! @input tenant_id: The tenant ID of the DND.
#! @input x_auth_token: The auth token of the DND.
#! @input tf_template_vcs_repo_identifier: A reference to your VCS repository in the format :org/:repo where :org and :repo refer to the organization and repository in your VCS provider.
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
#!
#! @result FAILURE: There was an error while creating the component properties using terraform output variables.
#! @result SUCCESS: The component properties are successfully created.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows
flow:
  name: create_tf_output_variables_in_component_template
  inputs:
    - tf_output_variable_key_list
    - component_template_id
    - dnd_host
    - tenant_id
    - x_auth_token:
        sensitive: true
    - tf_template_vcs_repo_identifier
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
    - array_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - array_value: '${tf_output_variable_key_list}'
        publish:
          - array_value_output: "${array_value.replace(\"[\",\"\").replace(\"]\",\"\").replace(\"'\",\"\").replace(\" \",\"\")}"
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - set_tf_output_property:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - input_0: "${'tf_output_'+key_name}"
        publish:
          - updated_output_keyname: '${input_0}'
        navigate:
          - SUCCESS: create_component_template_property
          - FAILURE: on_failure
    - list_iterator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${array_value_output}'
        publish:
          - key_name: '${result_string}'
        navigate:
          - HAS_MORE: set_tf_output_property
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - create_component_template_property:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microfocus.content.create_component_template_property:
            - dnd_host: '${dnd_host}'
            - tenant_id: '${tenant_id}'
            - dnd_auth_token:
                value: '${x_auth_token}'
                sensitive: true
            - template_id: '${component_template_id}'
            - property_name: '${updated_output_keyname}'
            - worker_group: '${worker_group}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - return_result
          - return_code
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
  outputs:
    - return_result
    - return_code
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      array_value:
        x: 200
        'y': 40
      set_tf_output_property:
        x: 360
        'y': 240
      list_iterator:
        x: 360
        'y': 40
        navigate:
          8b6965dd-57ad-a18d-07df-d5d132da4710:
            targetId: c24137a6-111f-83a4-cb98-ee4ece4c1920
            port: NO_MORE
      create_component_template_property:
        x: 520
        'y': 240
    results:
      SUCCESS:
        c24137a6-111f-83a4-cb98-ee4ece4c1920:
          x: 520
          'y': 40
