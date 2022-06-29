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
#! @description: This flow is used to create a Cassandra Application.
#!
#! @input kubernetes_host: Kubernetes host.
#! @input kubernetes_port: Kubernetes API Port.
#!                         Default: '443'
#!                         Optional
#! @input kubernetes_auth_token: Kubernetes authorization token.
#! @input namespace: The name of the kubernetes namespace.
#! @input service_name_suffix: The suffix to the name of the Kubernetes service that needs to be created.
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
#! @output replication_controller_name: The name of the kubernetes replication controller.
#! @output pod_list: The list of pods.
#! @output service_name: The name of the kubernetes service.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output return_result: This will contain the success message.
#!
#! @result SUCCESS: The flow successfully deployed the cassandra application.
#! @result FAILURE: The flow failed to deploy the cassandra application
#!!#
########################################################################################################################

namespace: io.cloudslang.kubernetes.samples
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: deploy_cassandra_application
  inputs:
    - kubernetes_host
    - kubernetes_port:
        default: '443'
        required: true
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
    - create_namespace:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.create_namespace:
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
            - kubernetes_host: '${kubernetes_host}'
            - kubernetes_port: '${kubernetes_port}'
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
        publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: create_pod
    - create_pod:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.create_pod:
            - kubernetes_host: '${kubernetes_host}'
            - kubernetes_port: '${kubernetes_port}'
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
            - kubernetes_host: '${kubernetes_host}'
            - kubernetes_port: '${kubernetes_port}'
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
  outputs:
    - replication_controller_name
    - pod_list
    - service_name
    - status_code
    - return_result
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      create_namespace:
        x: 40
        'y': 120
      create_service:
        x: 200
        'y': 120
      create_pod:
        x: 360
        'y': 120
      create_replication_controller:
        x: 520
        'y': 120
      list_pods:
        x: 680
        'y': 120
        navigate:
          8d22f839-f1c2-8f01-bb06-a93aff89a08c:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 840
          'y': 120
