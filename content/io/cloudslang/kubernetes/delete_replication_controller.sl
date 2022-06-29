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
#! @description: This flow deletes the kubernetes replication controller.
#!
#! @input kubernetes_host: Kubernetes host.
#! @input kubernetes_port: Kubernetes API Port.
#!                         Default: '443'
#!                         Optional
#! @input kubernetes_auth_token: Kubernetes authorization token.
#! @input namespace: The name of the namespace.
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
#! @input x_509_hostname_verifier: specifies the way the server hostname must match a domain name in
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
    - kubernetes_host
    - kubernetes_port:
        default: '443'
        required: true
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
        publish:
          - pods_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: delete_replication_controller
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
          - SUCCESS: get_array_of_pods
          - FAILURE: on_failure
    - delete_pod:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.delete_pod:
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
          - SUCCESS: pods_array_iterator
    - string_equals_empty_array:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${return_result}'
            - second_string: '[]'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: pods_array_iterator
          - FAILURE: get_pod_name
    - pods_array_iterator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.array_iterator:
            - array: '${pods_array}'
        publish:
          - result_string
          - return_result
          - return_code
        navigate:
          - HAS_MORE: json_path_query
          - NO_MORE: check_no_more
          - FAILURE: on_failure
    - get_array_of_pods:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${pods_json}'
            - json_path: items
        publish:
          - pods_array: '${return_result}'
        navigate:
          - SUCCESS: pods_array_iterator
          - FAILURE: on_failure
    - json_path_query:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${result_string}'
            - json_path: "${\"$.metadata.ownerReferences[?(@.kind=='ReplicationController' && @.name=='\"+replication_controller_name+\"')]\"}"
        publish:
          - return_result
        navigate:
          - SUCCESS: string_equals_empty_array
          - FAILURE: pods_array_iterator
    - get_pod_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${result_string}'
            - json_path: 'metadata,name'
        publish:
          - pod_name: '${return_result}'
        navigate:
          - SUCCESS: delete_pod
          - FAILURE: on_failure
    - check_no_more:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${return_result}'
            - second_string: no more
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: json_path_query
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
        x: 520
        'y': 80
      delete_replication_controller:
        x: 200
        'y': 80
      pods_array_iterator:
        x: 840
        'y': 80
      json_path_query:
        x: 1000
        'y': 480
      get_array_of_pods:
        x: 680
        'y': 80
      get_pod_name:
        x: 680
        'y': 480
      list_pods:
        x: 40
        'y': 80
      delete_pod:
        x: 680
        'y': 280
      string_equals_empty_array:
        x: 840
        'y': 480
      sleep:
        x: 440
        'y': 280
        navigate:
          43954433-1cff-8e3a-a5f7-472b7e49f60c:
            targetId: 9f3c1b9e-2d98-75fc-79ba-7069939c5038
            port: FAILURE
      read_replication_controller:
        x: 360
        'y': 80
      counter:
        x: 280
        'y': 280
        navigate:
          c260deb1-d39b-7d4c-6081-233939033b8d:
            targetId: 9f3c1b9e-2d98-75fc-79ba-7069939c5038
            port: FAILURE
          cf7e4964-4e90-8d93-81d7-e99760f967f2:
            targetId: 9f3c1b9e-2d98-75fc-79ba-7069939c5038
            port: NO_MORE
      check_no_more:
        x: 1000
        'y': 80
        navigate:
          a3723742-b1ff-a4ee-e599-900ad111629f:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 1200
          'y': 80
      FAILURE:
        9f3c1b9e-2d98-75fc-79ba-7069939c5038:
          x: 360
          'y': 480
