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
#! @description: This flow is used to get the list of variables with updated values.
#!
#! @input user_identifier: The user identifier value.
#! @input property_value_list: The list of property values.
#! @input state_version_id: The ID of the desired state version.
#! @input hosted_state_download_url: A url from which you can download the raw state.
#! @input service_component_id: The ID of the service component id.
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
#!
#! @output striped_output_keyname: The output key name.
#! @output updated_keyvalue: The updated key value.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.automation_content.utils
flow:
  name: list_output_variables
  inputs:
    - user_identifier
    - property_value_list
    - state_version_id
    - hosted_state_download_url
    - service_component_id
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
  workflow:
    - extract_state_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: '${hosted_state_download_url}'
            - auth_type: anonymous
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
        publish:
          - state_result: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - list_iterator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${tf_output_list}'
            - separator: ','
        publish:
          - list_items: '${result_string}'
        navigate:
          - HAS_MORE: get_keyname_and_keyvalue
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - remove_tf_output:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.remove:
            - origin_string: '${striped_key_name}'
            - text: tf_output_
        publish:
          - striped_output_keyname: '${new_string}'
        navigate:
          - SUCCESS: get_values_v2
    - json_path_query:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${state_result}'
            - json_path: $.outputs
        publish:
          - output_results: '${return_result}'
        navigate:
          - SUCCESS: get_output_keyname_python
          - FAILURE: on_failure
    - get_values_v2:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.maps.get_values_v2:
            - map: '${state_output_variables_list}'
            - key: '${striped_output_keyname}'
            - pair_delimiter: ':'
            - entry_delimiter: ','
            - map_start: '{'
            - map_end: '}'
            - element_wrapper: "'"
            - strip_whitespaces: 'true'
        publish:
          - updated_keyvalue: '${return_result}'
        navigate:
          - SUCCESS: add_or_update_service_component_property
          - FAILURE: on_failure
    - get_output_keyname_python:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.automation_content.utils.get_output_keyname_python:
            - output_results: '${output_results}'
        publish:
          - state_output_variables_list: '${result}'
        navigate:
          - SUCCESS: get_tf_output_list_python
    - get_tf_output_list_python:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.automation_content.utils.get_tf_output_list_python:
            - property_value_list: '${property_value_list}'
        publish:
          - tf_output_list
        navigate:
          - SUCCESS: list_iterator
    - get_keyname_and_keyvalue:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - key_name: '${list_items.split(";")[0]}'
            - key_value: '${list_items.split(";")[1]}'
            - is_confidential: '${list_items.split(";")[2]}'
        publish:
          - striped_key_name: "${key_name.strip(' ')}"
          - key_value
        navigate:
          - SUCCESS: remove_tf_output
          - FAILURE: on_failure
    - add_or_update_service_component_property:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microfocus.content.add_or_update_service_component_property:
            - component_id: '${service_component_id}'
            - user_identifier: '${user_identifier}'
            - property_name: '${striped_key_name}'
            - property_values: '${updated_keyvalue}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: list_iterator
  outputs:
    - striped_output_keyname
    - updated_keyvalue
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_tf_output_list_python:
        x: 400
        'y': 80
      json_path_query:
        x: 160
        'y': 80
      get_output_keyname_python:
        x: 280
        'y': 80
      list_iterator:
        x: 560
        'y': 80
        navigate:
          c86dc5bc-eff5-a254-f234-044952b4e3ec:
            targetId: f30f1fa9-eca1-283d-7473-5ed1ea062825
            port: NO_MORE
      get_values_v2:
        x: 480
        'y': 280
      remove_tf_output:
        x: 320
        'y': 280
      extract_state_details:
        x: 40
        'y': 80
      get_keyname_and_keyvalue:
        x: 160
        'y': 280
      add_or_update_service_component_property:
        x: 640
        'y': 280
    results:
      SUCCESS:
        f30f1fa9-eca1-283d-7473-5ed1ea062825:
          x: 840
          'y': 80
