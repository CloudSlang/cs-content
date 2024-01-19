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
#! @description: This flow is used to create a Guestbook application.
#!
#! @input kubernetes_provider_sap: The service access point of the kubernetes provider.
#! @input kubernetes_auth_token: The kubernetes service account token that is used for authentication.
#! @input namespace: The name of the Kubernetes namespace.
#! @input service_name_suffix: The name of the Kubernetes service.
#! @input number_of_replicas: The total number of replicas of pods that need to be created.
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
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
#! @output list_of_service: The list of Kubernetes services.
#! @output cluster_ip: The Cluster IP address of the kubernetes guestbook application.
#!!#
########################################################################################################################

namespace: io.cloudslang.kubernetes.samples
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: deploy_guestbook_application
  inputs:
    - kubernetes_provider_sap
    - kubernetes_auth_token:
        sensitive: true
    - namespace
    - service_name_suffix:
        required: true
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
          - pod_list
          - pods_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: list_service
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
    - list_service:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.services.list_service:
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
          - list_of_service
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_cluster_ip
    - create_namespace:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.create_namespace:
            - kubernetes_provider_sap: '${kubernetes_provider_sap}'
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
            - service_name_slave: '${service_name_suffix}'
            - service_name_guestbook: '${service_name_suffix}'
        publish:
          - final_namespace
          - namespace_json
          - creation_time
          - return_result
          - service_name: '${"redis-master"+service_name}'
          - service_name_slave: '${"redis-slave"+service_name_slave}'
          - service_name_guestbook: '${"guestbook"+service_name_guestbook}'
          - status_code
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_redis_master_service
    - set_cluster_ip:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${service_json}'
            - json_path: 'status.loadBalancer.ingress[*].ip'
        publish:
          - cluster_ip: "${return_result.strip('[').strip(\"]\").strip('\"').replace('\"','')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_cluster_ip:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.services.get_service:
            - kubernetes_host: '${kubernetes_host}'
            - kubernetes_port: '${kubernetes_port}'
            - kubernetes_auth_token:
                value: '${kubernetes_auth_token}'
                sensitive: true
            - namespace: '${namespace}'
            - service_name: '${final_service_name_guestbook}'
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
        navigate:
          - FAILURE: on_failure
          - SUCCESS: set_cluster_ip
    - deploy_redis_master_service:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.samples.subflows.deploy_service:
            - kubernetes_provider_sap: '${kubernetes_provider_sap}'
            - kubernetes_auth_token:
                value: '${kubernetes_auth_token}'
                sensitive: true
            - service_name: '${service_name}'
            - namespace: '${namespace}'
            - worker_group: '${worker_group}'
            - pod_json_body: "${'{\"kind\":\"ReplicationController\", \"apiVersion\":\"v1\",\"metadata\":{ \"name\":\"'+service_name+'\", \"labels\":{ \"app\":\"redis\", \"role\":\"master\" }},\"spec\":{ \"replicas\":'+number_of_replicas+',\"selector\":{\"app\":\"redis\",\"role\":\"master\"},\"template\":{\"metadata\":{\"labels\":{\"app\":\"redis\", \"role\":\"master\"}},\"spec\":{ \"containers\":[{ \"name\":\"'+service_name+'\", \"image\":\"k8s.gcr.io/redis:e2e\", \"ports\":[{ \"name\":\"redis-server\",\"containerPort\":6379} ] }]}} }}'}"
            - service_json_body: "${'{ \"kind\":\"Service\", \"apiVersion\":\"v1\",\"metadata\":{ \"name\":\"'+service_name+'\",\"labels\":{ \"app\":\"redis\", \"role\":\"master\"}},\"spec\":{ \"ports\": [{\"port\":6379,\"targetPort\":\"redis-server\"}],\"selector\":{ \"app\":\"redis\", \"role\":\"master\"} } }'}"
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
          - final_service_name
        navigate:
          - SUCCESS: deploy_redis_slave_service
          - FAILURE: on_failure
          - FAILURE_1: FAILURE_1
    - deploy_redis_slave_service:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.samples.subflows.deploy_service:
            - kubernetes_provider_sap: '${kubernetes_provider_sap}'
            - kubernetes_auth_token:
                value: '${kubernetes_auth_token}'
                sensitive: true
            - service_name: '${service_name}'
            - namespace: '${namespace}'
            - worker_group: '${worker_group}'
            - pod_json_body: "${'{\"kind\":\"ReplicationController\",\"apiVersion\":\"v1\", \"id\":\"redis-slave\", \"metadata\":{ \"name\":\"'+service_name_slave+'\",\"labels\":{ \"app\":\"redis\", \"role\":\"slave\"}}, \"spec\":{ \"replicas\":'+number_of_replicas+',\"selector\":{ \"app\":\"redis\",\"role\":\"slave\" }, \"template\":{ \"metadata\":{\"labels\":{\"app\":\"redis\",\"role\":\"slave\" } },\"spec\":{\"containers\":[{\"name\":\"'+service_name_slave+'\",\"image\":\"gcr.io/google_samples/gb-redisslave:v1\", \"ports\":[{ \"name\":\"redis-server\", \"containerPort\":6379} ] }]}}}}'}"
            - service_json_body: "${'{ \"kind\":\"Service\", \"apiVersion\":\"v1\",\"metadata\":{\"name\":\"'+service_name_slave+'\",\"labels\":{ \"app\":\"redis\",\"role\":\"slave\"}},\"spec\":{ \"ports\": [{ \"port\":6379,\"targetPort\":\"redis-server\"} ],  \"selector\":{ \"app\":\"redis\", \"role\":\"slave\" }}}'}"
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
          - SUCCESS: deploy_guestbook
          - FAILURE: on_failure
          - FAILURE_1: FAILURE_1
    - deploy_guestbook:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.samples.subflows.deploy_service:
            - kubernetes_provider_sap: '${kubernetes_provider_sap}'
            - kubernetes_auth_token:
                value: '${kubernetes_auth_token}'
                sensitive: true
            - service_name: '${service_name}'
            - namespace: '${namespace}'
            - worker_group: '${worker_group}'
            - pod_json_body: "${'{\"kind\":\"ReplicationController\", \"apiVersion\":\"v1\",\"metadata\":{ \"name\":\"'+service_name_guestbook+'\",\"labels\":{ \"app\":\"guestbook\"  } }, \"spec\":{\"replicas\":'+number_of_replicas+',\"selector\":{\"app\":\"'+service_name_guestbook+'\" },\"template\":{\"metadata\":{ \"labels\":{\"app\":\"'+service_name_guestbook+'\" } },\"spec\":{ \"containers\":[{ \"name\":\"'+service_name_guestbook+'\", \"image\":\"gcr.io/google-samples/gb-frontend:v4\", \"ports\":[{ \"name\":\"http-server\", \"containerPort\":80}  ]   }]  } }}}'}"
            - service_json_body: "${'{\"kind\":\"Service\", \"apiVersion\":\"v1\",\"metadata\":{ \"name\":\"'+service_name_guestbook+'\", \"labels\":{  \"app\":\"'+service_name_guestbook+'\" } }, \"spec\":{\"ports\": [{ \"port\":80, \"targetPort\":\"http-server\" }],\"selector\":{ \"app\":\"'+service_name_guestbook+'\" },\"type\": \"LoadBalancer\"}}'}"
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
          - final_service_name_guestbook: '${final_service_name}'
        navigate:
          - SUCCESS: list_pods
          - FAILURE: on_failure
          - FAILURE_1: FAILURE_1
  outputs:
    - status_code
    - return_result
    - pod_list
    - list_of_service
    - cluster_ip
  results:
    - SUCCESS
    - FAILURE
    - FAILURE_1
extensions:
  graph:
    steps:
      set_kubernetes_host:
        x: 40
        'y': 80
      set_cluster_ip:
        x: 1040
        'y': 480
        navigate:
          084d9e4a-8bfb-431e-346c-bb76fa16e56e:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      deploy_guestbook:
        x: 840
        'y': 80
        navigate:
          f650e6ed-d082-252e-1729-f9156ea249f6:
            targetId: e2fa2ca1-841c-cf82-4550-9d370c6be8fd
            port: FAILURE_1
      is_port_provided:
        x: 200
        'y': 80
      list_pods:
        x: 1040
        'y': 80
      compare_numbers:
        x: 200
        'y': 320
      deploy_redis_slave_service:
        x: 640
        'y': 80
        navigate:
          e808640e-e0de-a8b2-2dcf-8aec2e7ed756:
            targetId: e2fa2ca1-841c-cf82-4550-9d370c6be8fd
            port: FAILURE_1
      list_service:
        x: 1040
        'y': 280
      deploy_redis_master_service:
        x: 520
        'y': 320
        navigate:
          b7802438-154a-ccff-bc7f-b1ea37a7364c:
            targetId: e2fa2ca1-841c-cf82-4550-9d370c6be8fd
            port: FAILURE_1
      get_cluster_ip:
        x: 760
        'y': 480
      create_namespace:
        x: 520
        'y': 80
      set_kubernetes_port:
        x: 400
        'y': 320
      set_default_kubernetes_port:
        x: 360
        'y': 80
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 1240
          'y': 80
      FAILURE_1:
        e2fa2ca1-841c-cf82-4550-9d370c6be8fd:
          x: 800
          'y': 320

