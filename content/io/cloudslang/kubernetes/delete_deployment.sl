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
#! @description: This flow is used to delete the kubernetes deployment.
#!
#! @input kubernetes_provider_sap: The service access point of the kubernetes provider.
#! @input kubernetes_auth_token: The kubernetes service account token that is used for authentication.
#! @input namespace: The name of the kubernetes namespace.
#! @input deployment_name: The name of the kubernetes deployment that should be deleted.
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
#! @result SUCCESS: The flow successfully created the kubernetes deployment.
#! @result FAILURE: The flow failed to create the kubernetes deployment.
#!!#
########################################################################################################################

namespace: io.cloudslang.kubernetes.test
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: delete_deployment
  inputs:
    - kubernetes_provider_sap
    - kubernetes_auth_token:
        sensitive: true
    - namespace
    - deployment_name
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
          - SUCCESS: delete_deployment
          - FAILURE: on_failure
    - set_default_kubernetes_port:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - kubernetes_port: '443'
        publish:
          - kubernetes_port
        navigate:
          - SUCCESS: delete_deployment
          - FAILURE: on_failure
    - delete_deployment:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.deployments.delete_deployment:
            - kubernetes_host: '${kubernetes_host}'
            - kubernetes_port: '${kubernetes_port}'
            - kubernetes_auth_token:
                value: '${kubernetes_auth_token}'
                sensitive: true
            - namespace: '${namespace}'
            - deployment_name: '${deployment_name}'
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
          - status_code
        navigate:
          - FAILURE: on_failure
          - SUCCESS: read_deployment
    - read_deployment:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.deployments.read_deployment:
            - kubernetes_host: '${kubernetes_host}'
            - kubernetes_port: '${kubernetes_port}'
            - kubernetes_auth_token:
                value: '${kubernetes_auth_token}'
                sensitive: true
            - namespace: '${namespace}'
            - deployment_name: '${deployment_name}'
            - worker_group: '${worker_group}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${kubernetes_port}'
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
          - status_code
          - return_result
        navigate:
          - FAILURE: check_delete_deployment_status_code
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
          - FAILURE: on_failure
    - sleep:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '10'
        navigate:
          - SUCCESS: read_deployment
          - FAILURE: FAILURE
    - check_delete_deployment_status_code:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '404'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
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
      is_port_provided:
        x: 200
        'y': 80
      read_deployment:
        x: 720
        'y': 80
      compare_numbers:
        x: 200
        'y': 280
      sleep:
        x: 720
        'y': 320
        navigate:
          1ff71e50-b40e-4687-fcce-d0056986e999:
            targetId: 5248393a-5e8c-7bef-788a-34facb74c4fc
            port: FAILURE
      delete_deployment:
        x: 560
        'y': 80
      counter:
        x: 880
        'y': 320
        navigate:
          f1bdbd3c-0f87-29da-4ba6-69ede750a848:
            targetId: 5248393a-5e8c-7bef-788a-34facb74c4fc
            port: NO_MORE
            vertices:
              - x: 760
                'y': 480
      check_delete_deployment_status_code:
        x: 880
        'y': 80
        navigate:
          4b43fec0-e538-a339-1864-ad598cdd64e2:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      set_kubernetes_port:
        x: 400
        'y': 280
      set_default_kubernetes_port:
        x: 400
        'y': 80
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 1080
          'y': 80
      FAILURE:
        5248393a-5e8c-7bef-788a-34facb74c4fc:
          x: 560
          'y': 320
