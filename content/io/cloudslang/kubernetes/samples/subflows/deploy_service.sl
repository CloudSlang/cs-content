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
#! @description: This flow deploys the kubernetes service.
#!
#! @input kubernetes_provider_sap: The service access point of the kubernetes provider
#! @input kubernetes_auth_token: The kubernetes service account token that is used for authentication.
#! @input service_name: The name of the Kubernetes service.
#! @input namespace: The name of the Kubernetes namespace.
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input pod_json_body: The JSON files which defines the pods configuration.
#! @input service_json_body: The service json that is needed to create the Kubernetes Service.Example : {"kind":"Service","apiVersion":"v1","metadata": {"name": "+service_name+"},"spec": {"type":"NodePort","selector":{"app":"tomcat4"},"ports":[{"protocol":"TCP","port": 9090,"targetPort":8080,"loadBalancer":30003}]}}
#! @input proxy_host: Proxy server used to access the website.
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
#!                        you trust to identify other parties. If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, default trust_password will be used.
#!                        Optional
#!
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output return_result: This contains the response entity.
#! @output pod_list: The list of kubernetes pods.
#! @output replication_controller_json: The Kubernetes replication controller details in JSON format.
#! @output replication_controller_name: The name of the Kubernetes replication controller.
#! @output final_service_name: The name of the Kubernetes service.
#! @output service_cluster_ip: The clusterIp of the Kubernetes service.
#!!#
########################################################################################################################

namespace: io.cloudslang.kubernetes.samples.subflows
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: deploy_service
  inputs:
    - kubernetes_provider_sap
    - kubernetes_auth_token:
        sensitive: true
    - service_name:
        required: false
    - namespace
    - worker_group:
        default: RAS_Operator_Path
        required: false
    - pod_json_body
    - service_json_body
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
    - wait_for_pods_creation:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '30'
        navigate:
          - SUCCESS: list_pods
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
        publish:
          - return_result
          - pods_json
          - pod_list: "${pod_list.strip('[').strip(\"]\").strip('\"').replace('\"','')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: list_iterator
    - get_pod_status:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${pod_json}'
            - json_path: status.phase
        publish:
          - pod_state: "${return_result.strip('[').strip(\"]\").strip('\"').replace('\"','')}"
        navigate:
          - SUCCESS: is_releavant_pod
          - FAILURE: on_failure
    - is_running:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${pod_state}'
            - second_string: Running
            - ignore_case: 'true'
        navigate:
          - SUCCESS: create_service
          - FAILURE: wait_for_pod_start_up
    - is_releavant_pod:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_occurrence_counter:
            - string_in_which_to_search: '${pod_list}'
            - string_to_find: '${service_name}'
            - ignore_case: 'true'
        publish:
          - return_result
        navigate:
          - SUCCESS: is_running
          - FAILURE: on_failure
    - list_iterator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${pod_list}'
        publish:
          - pod_name: '${result_string}'
        navigate:
          - HAS_MORE: get_pod_details
          - NO_MORE: FAILURE_1
          - FAILURE: on_failure
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
          - return_result
          - pod_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_pod_status
    - wait_for_pod_start_up:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - create_service:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.create_service:
            - kubernetes_provider_sap: '${kubernetes_provider_sap}'
            - kubernetes_host: '${kubernetes_host}'
            - kubernetes_port: '${kubernetes_port}'
            - kubernetes_auth_token:
                value: '${kubernetes_auth_token}'
                sensitive: true
            - namespace: '${namespace}'
            - service_name: '${service_name}'
            - service_json_body: '${service_json_body}'
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
          - service_json
          - service_cluster_ip
          - service_creation_time_stamp
          - service_uid
          - final_service_name
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
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
    - set_default_kubernetes_port:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - kubernetes_port: '443'
        publish:
          - kubernetes_port
        navigate:
          - SUCCESS: wait_for_pods_creation
          - FAILURE: on_failure
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
    - create_replication_controller:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.create_replication_controller:
            - kubernetes_provider_sap: '${kubernetes_provider_sap}'
            - kubernetes_auth_token:
                value: '${kubernetes_auth_token}'
                sensitive: true
            - namespace: '${namespace}'
            - replication_controller_json_body: '${pod_json_body}'
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
          - replication_controller_name
          - status_code
          - return_result
        navigate:
          - FAILURE: on_failure
          - SUCCESS: wait_for_pods_creation
  outputs:
    - status_code
    - return_result
    - pod_list
    - replication_controller_json
    - replication_controller_name
    - final_service_name
    - service_cluster_ip
  results:
    - SUCCESS
    - FAILURE
    - FAILURE_1
extensions:
  graph:
    steps:
      set_kubernetes_host:
        x: 0
        'y': 80
      is_running:
        x: 1200
        'y': 280
      is_port_provided:
        x: 160
        'y': 80
      list_pods:
        x: 560
        'y': 80
      list_iterator:
        x: 720
        'y': 80
        navigate:
          744a6cb7-6610-dabd-327f-082878f046f4:
            targetId: 6bbf337b-f452-88c0-9a03-5184d011fb3b
            port: NO_MORE
      compare_numbers:
        x: 40
        'y': 440
      wait_for_pods_creation:
        x: 400
        'y': 80
      create_replication_controller:
        x: 400
        'y': 280
      wait_for_pod_start_up:
        x: 880
        'y': 280
      create_service:
        x: 1000
        'y': 480
        navigate:
          ee720576-9af4-6c3f-7d58-7088d4a307c3:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      get_pod_status:
        x: 1040
        'y': 80
      is_releavant_pod:
        x: 1200
        'y': 80
      set_kubernetes_port:
        x: 280
        'y': 440
      get_pod_details:
        x: 880
        'y': 80
      set_default_kubernetes_port:
        x: 280
        'y': 80
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 1240
          'y': 480
      FAILURE_1:
        6bbf337b-f452-88c0-9a03-5184d011fb3b:
          x: 600
          'y': 440

