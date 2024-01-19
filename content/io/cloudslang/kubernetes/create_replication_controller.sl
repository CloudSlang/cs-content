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
#! @description: This flow creates the kubernetes replication controller and retrieves details of the replication controller.
#!
#! @input kubernetes_provider_sap: The service access point of the kubernetes provider.
#! @input kubernetes_auth_token: The kubernetes service account token that is used for authentication.
#! @input namespace: The name of the kubernetes namespace.
#! @input replication_controller_json_body: The replication controller json that is needed to create the kubernetes replication controller.
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
#! @output replication_controller_json: The kubernetes replication controller details in JSON format.
#! @output replication_controller_name: The name of the kubernetes replication controller created.
#! @output replication_controller_uid: The unique identifier of the kubernetes replication controller.
#! @output replication_controller_type: The type of kubernetes replication controller.
#! @output replication_controller_replicas: The number of replicas created.
#! @output replication_controller_creation_time: The kubernetes replication controller creation time.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output return_result: This will contain the success message.
#!
#! @result FAILURE: The operation failed to create the replication controller.
#! @result SUCCESS: The operation successfully created the replication controller.
#!!#
########################################################################################################################

namespace: io.cloudslang.kubernetes
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: create_replication_controller
  inputs:
    - kubernetes_provider_sap
    - kubernetes_auth_token:
        sensitive: true
    - namespace
    - replication_controller_json_body
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
    - create_replication_controller:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.replication_controllers.create_replication_controller:
            - kubernetes_host: '${kubernetes_host}'
            - kubernetes_port: '${kubernetes_port}'
            - kubernetes_auth_token:
                value: '${kubernetes_auth_token}'
                sensitive: true
            - replication_controller_json_body: '${replication_controller_json_body}'
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
          - replication_controller_json
          - status_code
          - replication_controller_name
          - return_result
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_replication_controller_uid
    - get_replication_controller_uid:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${replication_controller_json}'
            - json_path: 'metadata,uid'
        publish:
          - replication_controller_uid: '${return_result}'
        navigate:
          - SUCCESS: get_replicas
          - FAILURE: on_failure
    - get_replicas:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${replication_controller_json}'
            - json_path: 'spec,replicas'
        publish:
          - replication_controller_replicas: '${return_result}'
        navigate:
          - SUCCESS: get_replication_controller_creation_time
          - FAILURE: on_failure
    - get_replication_controller_creation_time:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${replication_controller_json}'
            - json_path: 'metadata,creationTimestamp'
        publish:
          - replication_controller_creation_time: '${return_result}'
        navigate:
          - SUCCESS: get_replication_controller_type
          - FAILURE: on_failure
    - get_replication_controller_type:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${replication_controller_json}'
            - json_path: kind
        publish:
          - replication_controller_type: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
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
          - SUCCESS: create_replication_controller
          - FAILURE: on_failure
    - set_default_kubernetes_port:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - kubernetes_port: '443'
        publish:
          - kubernetes_port
        navigate:
          - SUCCESS: create_replication_controller
          - FAILURE: on_failure
  outputs:
    - replication_controller_json
    - replication_controller_name
    - replication_controller_uid
    - replication_controller_type
    - replication_controller_replicas
    - replication_controller_creation_time
    - status_code
    - return_result
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_replication_controller_type:
        x: 840
        'y': 280
        navigate:
          43086a37-3210-31b0-f1e6-51b2c0b5b7bf:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      set_kubernetes_host:
        x: 40
        'y': 80
      get_replicas:
        x: 680
        'y': 80
      get_replication_controller_creation_time:
        x: 680
        'y': 280
      get_replication_controller_uid:
        x: 520
        'y': 280
      is_port_provided:
        x: 200
        'y': 80
      compare_numbers:
        x: 200
        'y': 280
      create_replication_controller:
        x: 520
        'y': 80
      set_kubernetes_port:
        x: 360
        'y': 280
      set_default_kubernetes_port:
        x: 360
        'y': 80
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 1000
          'y': 280
