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
#! @description: This flow creates the Kubernetes pod.
#!
#! @input kubernetes_host: Kubernetes host.
#! @input kubernetes_port: Kubernetes API Port.
#!                         Default: '443'
#!                         Optional
#! @input kubernetes_auth_token: Kubernetes authorization token.
#! @input namespace: Name of the namespace under pod to be created.
#! @input pod_json_body: The JSON input of the pod.
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
#! @output return_result: This will contain the response entity.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output pod_name: Name of the pod.
#! @output pod_uid: UID of the pod.
#! @output pod_creation_time: Pod created time.
#!!#
########################################################################################################################

namespace: io.cloudslang.kubernetes
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: create_pod
  inputs:
    - kubernetes_host
    - kubernetes_port:
        default: '443'
        required: true
    - kubernetes_auth_token:
        sensitive: true
    - namespace
    - pod_json_body
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
    - create_pod:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.pods.create_pod:
            - kubernetes_host: '${kubernetes_host}'
            - kubernetes_port: '${kubernetes_port}'
            - kubernetes_auth_token:
                value: '${kubernetes_auth_token}'
                sensitive: true
            - namespace: '${namespace}'
            - pod_json_body: '${pod_json_body}'
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
          - pod_json
          - return_result
          - status_code
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_pod_details
    - get_pod_details:
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
    - get_pod_status:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${pod_json}'
            - json_path: 'status,phase'
        publish:
          - pod_status: '${return_result}'
        navigate:
          - SUCCESS: compare_pod_status
          - FAILURE: counter
    - compare_pod_status:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${pod_status}'
            - second_string: Running
        navigate:
          - SUCCESS: get_pod_creation_time
          - FAILURE: on_failure
    - wait_before_check:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: get_pod_status
          - FAILURE: on_failure
    - get_pod_creation_time:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${pod_json}'
            - json_path: 'metadata,creationTimestamp'
        publish:
          - pod_creation_time: '${return_result}'
        navigate:
          - SUCCESS: get_pod_uid
          - FAILURE: on_failure
    - get_pod_uid:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${pod_json}'
            - json_path: 'metadata,uid'
        publish:
          - pod_uid: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - counter:
        do:
          io.cloudslang.base.utils.counter:
            - from: '1'
            - to: '60'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: wait_before_check
          - NO_MORE: FAILURE_1
          - FAILURE: on_failure
  outputs:
    - return_result
    - status_code
    - pod_name
    - pod_uid
    - pod_creation_time
  results:
    - FAILURE
    - SUCCESS
    - FAILURE_1
extensions:
  graph:
    steps:
      create_pod:
        x: 40
        'y': 120
      get_pod_details:
        x: 200
        'y': 120
      get_pod_status:
        x: 360
        'y': 120
      compare_pod_status:
        x: 560
        'y': 120
      get_pod_uid:
        x: 840
        'y': 120
        navigate:
          ba506f47-a748-b9c2-60f9-ec15ac569659:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      wait_before_check:
        x: 160
        'y': 320
      get_pod_creation_time:
        x: 680
        'y': 120
      counter:
        x: 360
        'y': 320
        navigate:
          6c380319-97ac-a095-a64b-0f2734e2dba6:
            targetId: c9102be8-9863-2027-22f4-33ca633b909c
            port: NO_MORE
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 840
          'y': 360
      FAILURE_1:
        c9102be8-9863-2027-22f4-33ca633b909c:
          x: 360
          'y': 520
