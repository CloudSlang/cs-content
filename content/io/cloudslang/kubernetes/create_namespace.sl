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
#! @description: This flow creates the namespace.
#!
#! @input kubernetes_host: Kubernetes host..
#! @input kubernetes_port: Kubernetes API Port.
#!                         Default: '443'
#!                         Optional
#! @input kubernetes_auth_token: Kubernetes authorization token.
#! @input namespace: The name of the namespace.
#! @input namespace_json_body: The JSON body of the namespace to be created.
#!                             Example: "{"kind": "Namespace", "apiVersion": "v1", "metadata": {"name": "+namespace+"}}"
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
#! @output namespace_json: The details of created namespace.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output return_result: This will contain the message.
#! @output uid: Unique identifier of the deployment.
#! @output namespace_creation_time_stamp: Timestamp when Deployment is created.
#! @output status: status of the deployment.
#! @output namespace_name: Name of the created namespace.
#!
#! @result SUCCESS: The operation successfully created the namespace.
#!!#
########################################################################################################################

namespace: io.cloudslang.kubernetes
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: create_namespace
  inputs:
    - kubernetes_host
    - kubernetes_port:
        default: '443'
        required: true
    - kubernetes_auth_token:
        sensitive: true
    - namespace
    - namespace_json_body:
        required: true
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
    - read_namespace:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.kubernetes.namespaces.read_namespace:
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
          - status_code
          - namespace_json
          - namespace_name: '${namespace}'
        navigate:
          - FAILURE: check_namespace
          - SUCCESS: set_success_message_if_namespace_exists
    - set_uid:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${namespace_json}'
            - json_path: metadata.uid
        publish:
          - uid: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: set_creation_time_stamp
          - FAILURE: on_failure
    - set_creation_time_stamp:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${namespace_json}'
            - json_path: metadata.creationTimestamp
        publish:
          - namespace_creation_time_stamp: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: set_status
          - FAILURE: on_failure
    - set_status:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${namespace_json}'
            - json_path: status.phase
        publish:
          - status: "${return_result.strip('\"')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - check_namespace:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '404'
        navigate:
          - SUCCESS: create_namespace
          - FAILURE: on_failure
    - create_namespace:
        do:
          io.cloudslang.kubernetes.namespaces.create_namespace:
            - kubernetes_host: '${kubernetes_host}'
            - kubernetes_port: '${kubernetes_port}'
            - kubernetes_auth_token:
                value: '${kubernetes_auth_token}'
                sensitive: true
            - namespace_json_body: '${namespace_json_body}'
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
          - status_code
          - namespace_json
          - namespace_name: '${namespace}'
          - return_result
        navigate:
          - FAILURE: on_failure
          - SUCCESS: set_uid
    - set_success_message_if_namespace_exists:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - message: "${'The namespace '+namespace_name+' already exists.'}"
        publish:
          - return_result: '${message}'
        navigate:
          - SUCCESS: set_uid
          - FAILURE: on_failure
  outputs:
    - namespace_json
    - status_code
    - return_result
    - uid
    - namespace_creation_time_stamp
    - status
    - namespace_name
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      read_namespace:
        x: 80
        'y': 160
      set_creation_time_stamp:
        x: 600
        'y': 160
      set_uid:
        x: 440
        'y': 160
      set_status:
        x: 760
        'y': 160
        navigate:
          9a20a149-3b12-1a25-1ad6-139314e88afa:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      check_namespace:
        x: 80
        'y': 360
      create_namespace:
        x: 240
        'y': 360
      set_success_message_if_namespace_exists:
        x: 240
        'y': 160
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 960
          'y': 160

