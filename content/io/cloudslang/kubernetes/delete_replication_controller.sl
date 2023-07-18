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
#! @description: This flow deletes the kubernetes replication controller.
#!
#! @input kubernetes_provider_sap: The service access point of the kubernetes provider.
#! @input kubernetes_auth_token: The kubernetes service account token that is used for authentication.
#! @input namespace: The name of the kubernetes namespace.
#! @input replication_controller_name: The name of the kubernetes replication controller that needs to be deleted.
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
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output return_result: This will contain the success message.
#!
#! @result FAILURE: The operation failed to delete the kubernetes replication controller.
#! @result SUCCESS: The operation successfully deleted the kubernetes replication controller.
#!!#
########################################################################################################################

namespace: io.cloudslang.kubernetes
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: delete_replication_controller
  inputs:
    - kubernetes_provider_sap
    - kubernetes_auth_token:
        sensitive: true
    - namespace
    - replication_controller_name
    - worker_group:
        default: RAS_Operator_Path
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
    - set_kubernetes_host:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - kubernetes_host_with_port: "${kubernetes_provider_sap.split('//')[1].strip()}"
        publish:
          - kubernetes_host: "${kubernetes_host_with_port.split(':')[0]}"
          - kubernetes_host_with_port
        navigate:
          - SUCCESS: is_port_provided
          - FAILURE: on_failure
    - list_pods:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.pods.list_pods:
            - kubernetes_host: '${kubernetes_host}'
            - kubernetes_port: '${kubernetes_port}'
            - kubernetes_auth_token:
                value: '${kubernetes_auth_token}'
                sensitive: true
            - namespace: '${namespace}'
            - worker_group: '${worker_group}'
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
            - relevant_pod_list: ''
        publish:
          - pods_json
          - pod_list: '${pod_list.strip("[").strip("]")}'
          - relevant_pod_list: '${relevant_pod_list}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: list_iterator
    - delete_replication_controller:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.replication_controllers.delete_replication_controller:
            - kubernetes_host: '${kubernetes_host}'
            - kubernetes_port: '${kubernetes_port}'
            - kubernetes_auth_token:
                value: '${kubernetes_auth_token}'
                sensitive: true
            - namespace: '${namespace}'
            - replication_controller_name: '${replication_controller_name}'
            - worker_group: '${worker_group}'
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
          - replication_controller_json
          - status_code
        navigate:
          - FAILURE: on_failure
          - SUCCESS: read_replication_controller
    - read_replication_controller:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.replication_controllers.read_replication_controller:
            - kubernetes_host: '${kubernetes_host}'
            - kubernetes_port: '${kubernetes_port}'
            - kubernetes_auth_token:
                value: '${kubernetes_auth_token}'
                sensitive: true
            - namespace: '${namespace}'
            - replication_controller_name: '${replication_controller_name}'
            - worker_group: '${worker_group}'
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
          - replication_controller_json
          - status_code
        navigate:
          - FAILURE: check_replication_controller_status_code
          - SUCCESS: counter
    - counter:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.counter:
            - from: '0'
            - to: '30'
            - increment_by: '1'
            - reset: 'false'
        publish:
          - return_result
        navigate:
          - HAS_MORE: sleep
          - NO_MORE: FAILURE
          - FAILURE: FAILURE
    - sleep:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '10'
        navigate:
          - SUCCESS: read_replication_controller
          - FAILURE: FAILURE
    - check_replication_controller_status_code:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '404'
        navigate:
          - SUCCESS: iterate_relevant_pods
          - FAILURE: on_failure
    - string_equals_empty_array:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${return_result}'
            - second_string: '[]'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: is_relevant_pod_list_empty
    - json_path_query:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${pod_json}'
            - json_path: "${\"$.metadata.ownerReferences[?(@.kind=='ReplicationController' && @.name=='\"+replication_controller_name+\"')]\"}"
        publish:
          - return_result
        navigate:
          - SUCCESS: string_equals_empty_array
          - FAILURE: list_iterator
    - list_iterator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${pod_list}'
            - relevant_pod_list: '${relevant_pod_list}'
        publish:
          - pod_name: "${result_string.strip('\"')}"
          - relevant_pod_list
        navigate:
          - HAS_MORE: string_occurrence_counter
          - NO_MORE: delete_replication_controller
          - FAILURE: on_failure
    - string_occurrence_counter:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_occurrence_counter:
            - string_in_which_to_search: '${pod_name}'
            - string_to_find: '${replication_controller_name}'
        publish:
          - return_result
        navigate:
          - SUCCESS: string_equals
          - FAILURE: list_iterator
    - string_equals:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${return_result}'
            - second_string: '1'
        navigate:
          - SUCCESS: get_pod_details
          - FAILURE: list_iterator
    - get_pod_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.pods.get_pod_details:
            - kubernetes_host: '${kubernetes_host}'
            - kubernetes_port: '${kubernetes_port}'
            - kubernetes_auth_token:
                value: '${kubernetes_auth_token}'
                sensitive: true
            - namespace: '${namespace}'
            - pod_name: '${pod_name}'
            - worker_group: '${worker_group}'
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
          - pod_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - is_relevant_pod_list_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${relevant_pod_list}'
            - second_string: ''
        navigate:
          - SUCCESS: append_initial_pod_name
          - FAILURE: append_pod_name
    - append_pod_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${relevant_pod_list+","}'
            - text: '${pod_name}'
        publish:
          - relevant_pod_list: '${new_string}'
        navigate:
          - SUCCESS: list_iterator
    - append_initial_pod_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${relevant_pod_list}'
            - text: '${pod_name}'
        publish:
          - relevant_pod_list: '${new_string}'
        navigate:
          - SUCCESS: list_iterator
    - iterate_relevant_pods:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${pod_list}'
            - relevant_pod_list: '${relevant_pod_list}'
        publish:
          - pod_name: "${result_string.strip('\"')}"
          - relevant_pod_list
        navigate:
          - HAS_MORE: delete_pod
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - is_port_provided:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_occurrence_counter:
            - string_in_which_to_search: '${kubernetes_host_with_port}'
            - string_to_find: ':'
        publish:
          - return_result
        navigate:
          - SUCCESS: compare_numbers
          - FAILURE: set_default_kubernetes_port
    - compare_numbers:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.math.compare_numbers:
            - value1: '${return_result}'
            - value2: '1'
        navigate:
          - GREATER_THAN: set_kubernetes_port
          - EQUALS: set_kubernetes_port
          - LESS_THAN: set_default_kubernetes_port
    - set_kubernetes_port:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - kubernetes_port: "${kubernetes_host_with_port.split(':')[1]}"
        publish:
          - kubernetes_port
        navigate:
          - SUCCESS: list_pods
          - FAILURE: on_failure
    - set_default_kubernetes_port:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - kubernetes_port: '443'
        publish:
          - kubernetes_port
        navigate:
          - SUCCESS: list_pods
          - FAILURE: on_failure
    - delete_pod:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.kubernetes.pods.delete_pod:
            - kubernetes_host: '${kubernetes_host}'
            - kubernetes_port: '${kubernetes_port}'
            - kubernetes_auth_token:
                value: '${kubernetes_auth_token}'
                sensitive: true
            - namespace: '${namespace}'
            - pod_name: '${pod_name}'
            - worker_group: '${worker_group}'
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
        navigate:
          - FAILURE: on_failure
          - SUCCESS: iterate_relevant_pods
  outputs:
    - status_code
    - return_result
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      check_replication_controller_status_code:
        x: 1320
        'y': 120
      delete_replication_controller:
        x: 720
        'y': 120
        navigate:
          cab81cef-21a2-f18a-6a7c-fdb36c8c839b:
            vertices:
              - x: 880
                'y': 80
            targetId: read_replication_controller
            port: SUCCESS
      set_kubernetes_host:
        x: 40
        'y': 120
      append_initial_pod_name:
        x: 920
        'y': 160
      json_path_query:
        x: 720
        'y': 680
        navigate:
          db655ecf-2229-7021-98ab-66c8f066f54c:
            vertices:
              - x: 840
                'y': 600
              - x: 760
                'y': 400
            targetId: list_iterator
            port: FAILURE
      append_pod_name:
        x: 920
        'y': 320
      iterate_relevant_pods:
        x: 1480
        'y': 120
        navigate:
          babcd66e-093e-7220-e18e-245af54844f5:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: NO_MORE
      is_port_provided:
        x: 200
        'y': 120
      string_equals:
        x: 560
        'y': 520
      list_pods:
        x: 560
        'y': 120
      list_iterator:
        x: 560
        'y': 320
      compare_numbers:
        x: 200
        'y': 320
      delete_pod:
        x: 1480
        'y': 320
      is_relevant_pod_list_empty:
        x: 920
        'y': 520
        navigate:
          fed9e19c-65f1-76f6-48e6-5023618d4662:
            vertices:
              - x: 560
                'y': 320
            targetId: append
            port: SUCCESS
      string_equals_empty_array:
        x: 920
        'y': 680
        navigate:
          17a4a3e9-f5cf-edd8-cfb7-35d1a0bc60ff:
            vertices:
              - x: 800
                'y': 400
            targetId: list_iterator
            port: SUCCESS
      sleep:
        x: 1320
        'y': 320
        navigate:
          43954433-1cff-8e3a-a5f7-472b7e49f60c:
            targetId: 9f3c1b9e-2d98-75fc-79ba-7069939c5038
            port: FAILURE
      read_replication_controller:
        x: 1120
        'y': 120
      string_occurrence_counter:
        x: 720
        'y': 520
      counter:
        x: 1120
        'y': 320
        navigate:
          c260deb1-d39b-7d4c-6081-233939033b8d:
            targetId: 9f3c1b9e-2d98-75fc-79ba-7069939c5038
            port: FAILURE
          cf7e4964-4e90-8d93-81d7-e99760f967f2:
            targetId: 9f3c1b9e-2d98-75fc-79ba-7069939c5038
            port: NO_MORE
      set_kubernetes_port:
        x: 400
        'y': 320
      get_pod_details:
        x: 560
        'y': 680
      set_default_kubernetes_port:
        x: 400
        'y': 120
    results:
      FAILURE:
        9f3c1b9e-2d98-75fc-79ba-7069939c5038:
          x: 1120
          'y': 520
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 1640
          'y': 120

