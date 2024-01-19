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
#! @description: This flow is used to create a Cassandra application.
#!
#! @input kubernetes_provider_sap: The service access point of the kubernetes provider.
#! @input kubernetes_auth_token: The kubernetes service account token that is used for authentication.
#! @input namespace: The name of the kubernetes namespace.
#! @input service_name_suffix: The suffix to the name of the kubernetes service that needs to be created.
#! @input number_of_replicas: The total number of replicas of pods that need to be created.
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
#! @output replication_controller_name: The name of the kubernetes replication controller.
#! @output pod_list: The list of pods.
#! @output cluster_ip: The IP address of the kubernetes cluster.
#! @output service_name: The name of the kubernetes service.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output return_result: This will contain the success message.
#!
#! @result SUCCESS: The flow successfully deployed the Cassandra application.
#! @result FAILURE: The flow failed to deploy the Cassandra application
#!!#
########################################################################################################################

namespace: io.cloudslang.kubernetes.samples
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: deploy_cassandra_application
  inputs:
    - kubernetes_provider_sap
    - kubernetes_auth_token:
        sensitive: true
    - namespace
    - service_name_suffix
    - number_of_replicas
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
    - create_namespace:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.create_namespace:
            - kubernetes_provider_sap: '${kubernetes_provider_sap}'
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
            - service_name: '${service_name_suffix}'
        publish:
          - return_result
          - namespace_json
          - final_namespace
          - service_name: '${"cassandra-"+service_name}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_service
    - create_service:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.create_service:
            - kubernetes_provider_sap: '${kubernetes_provider_sap}'
            - kubernetes_auth_token:
                value: '${kubernetes_auth_token}'
                sensitive: true
            - namespace: '${final_namespace}'
            - service_name: '${service_name}'
            - service_json_body: "${'{\"apiVersion\":\"v1\",\"kind\":\"Service\",\"metadata\":{\"labels\":{\"name\":\"'+service_name+'\"},\"name\":\"'+service_name+'\"},\"spec\":{\"type\":\"LoadBalancer\",\"ports\":[{\"port\":9042,\"nodePort\":31516}],\"selector\":{\"name\":\"'+service_name+'\"}}}'}"
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
          - cluster_ip: '${service_cluster_ip}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_pod
    - create_pod:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.create_pod:
            - kubernetes_provider_sap: '${kubernetes_provider_sap}'
            - kubernetes_auth_token:
                value: '${kubernetes_auth_token}'
                sensitive: true
            - namespace: '${final_namespace}'
            - pod_json_body: "${'{\"kind\":\"Pod\",\"spec\":{\"containers\":[{\"name\":\"'+service_name+'\",\"env\":[{\"name\":\"MAX_HEAP_SIZE\",\"value\":\"512M\"},{\"name\":\"HEAP_NEWSIZE\",\"value\":\"100M\"},{\"valueFrom\":{\"fieldRef\":{\"fieldPath\":\"metadata.namespace\"}},\"name\":\"'+namespace+'\"}],\"image\":\"gcr.io/google_containers/cassandra:v6\",\"args\":[\"/run.sh\"],\"volumeMounts\":[{\"mountPath\":\"/'+service_name+'_data\",\"name\":\"data\"}],\"ports\":[{\"name\":\"cql\",\"containerPort\":9042},{\"name\":\"thrift\",\"containerPort\":9160}],\"resources\":{\"limits\":{\"cpu\":\"0.1\"}}}],\"volumes\":[{\"emptyDir\":{},\"name\":\"data\"}]},\"apiVersion\":\"v1\",\"metadata\":{\"labels\":{\"name\":\"'+service_name+'\"},\"name\":\"'+service_name+'\"}}'}"
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
          - pod_name
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_replication_controller
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
            - namespace: '${final_namespace}'
            - replication_controller_json_body: "${'{\"kind\":\"ReplicationController\",\"spec\":{\"replicas\":'+number_of_replicas+',\"template\":{\"spec\":{\"containers\":[{\"command\":[\"/run.sh\"],\"name\":\"'+service_name+'\",\"env\":[{\"name\":\"MAX_HEAP_SIZE\",\"value\":\"512M\"},{\"name\":\"HEAP_NEWSIZE\",\"value\":\"100M\"},{\"valueFrom\":{\"fieldRef\":{\"fieldPath\":\"metadata.namespace\"}},\"name\":\"'+namespace+'\"}],\"image\":\"gcr.io/google_containers/cassandra:v6\",\"volumeMounts\":[{\"mountPath\":\"/'+service_name+'_data\",\"name\":\"data\"}],\"ports\":[{\"containerPort\":9042,\"name\":\"cql\"},{\"containerPort\":9160,\"name\":\"thrift\"}],\"resources\":{\"limits\":{\"cpu\":0.1}}}],\"volumes\":[{\"emptyDir\":{},\"name\":\"data\"}]},\"metadata\":{\"labels\":{\"name\":\"'+service_name+'\"}}},\"selector\":{\"name\":\"'+service_name+'\"}},\"apiVersion\":\"v1\",\"metadata\":{\"labels\":{\"name\":\"'+service_name+'\"},\"name\":\"'+service_name+'\"}}'}"
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
          - replication_controller_name
          - status_code
          - return_result
        navigate:
          - FAILURE: on_failure
          - SUCCESS: list_pods
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
            - namespace: '${final_namespace}'
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
          - pod_list
          - status_code
          - return_result
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
          - SUCCESS: create_namespace
          - FAILURE: on_failure
    - set_default_kubernetes_port:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - kubernetes_port: '443'
        publish:
          - kubernetes_port
        navigate:
          - SUCCESS: create_namespace
          - FAILURE: on_failure
  outputs:
    - replication_controller_name
    - pod_list
    - cluster_ip
    - service_name
    - status_code
    - return_result
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      create_pod:
        x: 680
        'y': 280
      set_kubernetes_host:
        x: 40
        'y': 80
      is_port_provided:
        x: 200
        'y': 80
      list_pods:
        x: 840
        'y': 80
        navigate:
          8d22f839-f1c2-8f01-bb06-a93aff89a08c:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      compare_numbers:
        x: 200
        'y': 280
      create_replication_controller:
        x: 680
        'y': 80
      create_service:
        x: 520
        'y': 280
      create_namespace:
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
          'y': 80
