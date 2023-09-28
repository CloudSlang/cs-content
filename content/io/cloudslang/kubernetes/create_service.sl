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
#! @description: This flow creates a Kubernetes service.
#!
#! @input kubernetes_provider_sap: The service access point of the kubernetes provider.
#! @input kubernetes_auth_token: The kubernetes service account token that is used for authentication.
#! @input namespace: The name of the Kubernetes namespace.
#! @input service_name: The name of the service to be created.
#! @input service_json_body: The service json  should be in JSON format for the Service to be created.
#!                           Example : {"kind":"Service","apiVersion":"v1","metadata": {"name": "+service_name+"},
#!                           "spec":{"type":"NodePort","selector":{"app":"tomcat4"},
#!                           "ports":[{"protocol":"TCP","port":9090,"targetPort":8080,"loadBalancer":30003}]}}
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
#!                        you trust to identify other parties.If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#!
#! @output service_json: The Kubernetes service details in JSON format.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output return_result: This will contain the response entity.
#! @output final_service_name: The name of the Kubernetes service.
#! @output service_uid: The uid of the Kubernetes service.
#! @output service_creation_time_stamp: The creation time of the Kubernetes service.
#! @output service_cluster_ip: The clusterIp of the Kubernetes service.
#! @output service_type: The service type of the Kubernetes service.
#! @output external_ip: The external IP address of the kubernetes service.
#!!#
########################################################################################################################

namespace: io.cloudslang.kubernetes
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: create_service
  inputs:
    - kubernetes_provider_sap
    - kubernetes_auth_token:
        sensitive: true
    - namespace
    - service_name
    - service_json_body
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
    - get_service:
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
            - service_name: '${service_name}'
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
          - status_code
          - return_result
        navigate:
          - FAILURE: create_service
          - SUCCESS: set_service_name
    - create_service:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.services.create_service:
            - kubernetes_host: '${kubernetes_host}'
            - kubernetes_port: '${kubernetes_port}'
            - kubernetes_auth_token:
                value: '${kubernetes_auth_token}'
                sensitive: true
            - namespace: '${namespace}'
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
          - return_result
          - final_service_name: '${service_name}'
          - status_code
        navigate:
          - SUCCESS: check_service_is_created
          - FAILURE: on_failure
    - set_uid:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${service_json}'
            - json_path: metadata.uid
        publish:
          - service_uid: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: set_creation_time_stamp
          - FAILURE: on_failure
    - set_creation_time_stamp:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${service_json}'
            - json_path: metadata.creationTimestamp
        publish:
          - service_creation_time_stamp: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: set_cluster_ip
          - FAILURE: on_failure
    - set_service_type:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${service_json}'
            - json_path: spec.type
        publish:
          - service_type: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: get_external_ip
          - FAILURE: on_failure
    - set_cluster_ip:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${service_json}'
            - json_path: spec.clusterIP
        publish:
          - service_cluster_ip: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: set_service_type
          - FAILURE: on_failure
    - set_service_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${service_json}'
            - json_path: metadata.name
        publish:
          - final_service_name: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: set_uid
          - FAILURE: on_failure
    - check_service_is_created:
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
            - service_name: '${service_name}'
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
          - return_result
          - status_code
        navigate:
          - FAILURE: on_failure
          - SUCCESS: set_uid
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
          - SUCCESS: get_service
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
          - SUCCESS: get_service
          - FAILURE: on_failure
    - get_external_ip:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${service_json}'
            - json_path: 'status.loadBalancer.ingress[*].ip'
        publish:
          - external_ip: "${return_result.strip('[').strip(\"]\").strip('\"').replace('\"','')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: if_no_external_ip
    - if_no_external_ip:
        do:
          io.cloudslang.base.utils.do_nothing: []
        publish:
          - external_ip: "${' '.replace(\"' '\",'')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - service_json
    - status_code
    - return_result
    - final_service_name
    - service_uid
    - service_creation_time_stamp
    - service_cluster_ip
    - service_type
    - external_ip
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      set_service_type:
        x: 1280
        'y': 120
      set_kubernetes_host:
        x: 0
        'y': 120
      set_cluster_ip:
        x: 1120
        'y': 120
      is_port_provided:
        x: 160
        'y': 120
      get_service:
        x: 480
        'y': 120
      compare_numbers:
        x: 40
        'y': 400
      create_service:
        x: 480
        'y': 400
      set_service_name:
        x: 640
        'y': 120
      get_external_ip:
        x: 1280
        'y': 320
        navigate:
          9a442848-b4f7-f632-c77b-287614e8c1b1:
            targetId: 2a197e64-7870-d4f6-77fe-aca64a048eb4
            port: SUCCESS
      set_uid:
        x: 800
        'y': 120
      check_service_is_created:
        x: 800
        'y': 400
      set_creation_time_stamp:
        x: 960
        'y': 120
      set_kubernetes_port:
        x: 320
        'y': 280
      set_default_kubernetes_port:
        x: 320
        'y': 120
      if_no_external_ip:
        x: 1120
        'y': 320
        navigate:
          0c471989-0aa8-5c88-3eb7-ac796e05feb2:
            targetId: 2a197e64-7870-d4f6-77fe-aca64a048eb4
            port: SUCCESS
    results:
      SUCCESS:
        2a197e64-7870-d4f6-77fe-aca64a048eb4:
          x: 1280
          'y': 560

