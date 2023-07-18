#   Copyright 2020-2023 Open Text
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
#! @description: This flow is used to create the kubernetes deployment.
#!
#! @input kubernetes_provider_sap: The service access point of the kubernetes provider.
#! @input kubernetes_auth_token: The kubernetes service account token that is used for authentication.
#! @input namespace: The name of the kubernetes namespace.
#! @input deployment_json_body: The deployment json that is needed to create the Kubernetes Deployment.Example : {"apiVersion":"apps/v1","kind":"Deployment","metadata":{"name":"tomcat-deployment3","labels":{ "app":"tomcat"}},"spec":{"replicas":1,"selector":{"matchLabels":{ "app":"tomcat"}},"template":{"metadata":{"labels":{"app":"tomcat"}},"spec":{"containers":[               {                  "name":"tomcat","image":"tomcat","ports":[{"containerPort":8080}]}]}}}}
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
#! @output deployment_name: The name of the kubernetes deployment.
#! @output deployment_uid: The unique identifier of the kubernetes deployment.
#! @output deployment_creation_time: The kubernetes deployment creation time.
#! @output deployment_strategy_type: The strategy type of the kubernetes deployment.
#! @output replicas: The number of replicas created.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output return_result: This will contain the success message.
#!
#! @result SUCCESS: The flow successfully created the kubernetes deployment.
#! @result FAILURE: The flow failed to create the kubernetes deployment.
#!!#
########################################################################################################################

namespace: io.cloudslang.kubernetes
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: create_deployment
  inputs:
    - kubernetes_provider_sap
    - kubernetes_auth_token:
        sensitive: true
    - namespace
    - deployment_json_body
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
          - SUCCESS: create_deployment
          - FAILURE: on_failure
    - set_default_kubernetes_port:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - kubernetes_port: '443'
        publish:
          - kubernetes_port
        navigate:
          - SUCCESS: create_deployment
          - FAILURE: on_failure
    - create_deployment:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.deployments.create_deployment:
            - kubernetes_host: '${kubernetes_host}'
            - kubernetes_port: '${kubernetes_port}'
            - kubernetes_auth_token:
                value: '${kubernetes_auth_token}'
                sensitive: true
            - namespace: '${namespace}'
            - deployment_json_body: '${deployment_json_body}'
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
          - deployment_name
          - return_result
          - status_code
          - deployment_json
        navigate:
          - SUCCESS: get_replicas
          - FAILURE: on_failure
    - get_replicas:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${deployment_json}'
            - json_path: 'spec,replicas'
        publish:
          - replicas: '${return_result}'
        navigate:
          - SUCCESS: get_deployment_creation_time
          - FAILURE: on_failure
    - get_deployment_creation_time:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${deployment_json}'
            - json_path: 'metadata,creationTimestamp'
        publish:
          - deployment_creation_time: '${return_result}'
        navigate:
          - SUCCESS: get_deployment_strategy_type
          - FAILURE: on_failure
    - get_deployment_strategy_type:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${deployment_json}'
            - json_path: 'spec,strategy,type'
        publish:
          - deployment_strategy_type: '${return_result}'
        navigate:
          - SUCCESS: get_deployment_uid
          - FAILURE: on_failure
    - get_deployment_uid:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${deployment_json}'
            - json_path: 'metadata,uid'
        publish:
          - deployment_uid: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - deployment_name
    - deployment_uid
    - deployment_creation_time
    - deployment_strategy_type
    - replicas
    - status_code
    - return_result
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      set_kubernetes_host:
        x: 40
        'y': 80
      get_replicas:
        x: 720
        'y': 80
      create_deployment:
        x: 560
        'y': 80
      is_port_provided:
        x: 200
        'y': 80
      compare_numbers:
        x: 200
        'y': 280
      get_deployment_strategy_type:
        x: 920
        'y': 280
      get_deployment_creation_time:
        x: 720
        'y': 280
      set_kubernetes_port:
        x: 400
        'y': 280
      set_default_kubernetes_port:
        x: 400
        'y': 80
      get_deployment_uid:
        x: 920
        'y': 80
        navigate:
          dcc01ca4-29b7-bf3b-774a-4ee4e01eac3a:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 1080
          'y': 80
