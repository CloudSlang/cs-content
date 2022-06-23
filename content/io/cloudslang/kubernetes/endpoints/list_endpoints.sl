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
#! @description: This operation lists all the Kubernetes endpoints within the namespace.
#!
#! @input kubernetes_host: Kubernetes host..
#! @input kubernetes_port: Kubernetes API Port.
#!                         Default: '443'
#!                         Optional
#! @input kubernetes_auth_token: Kubernetes authorization token.
#! @input namespace: Name of the namespace.
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
#! @output endpoints_json: The Kubernetes endpoint details in JSON format.
#! @output list_of_endpoints: It lists the Kubernetes endpoints within the specified namespace.
#! @output return_result: This contains the response entity.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#!
#! @result FAILURE: The operation failed to list endpoints.
#! @result SUCCESS: The operation successfully retrieved the list of endpoints.
#!!#
########################################################################################################################

namespace: io.cloudslang.kubernetes.endpoints
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: list_endpoints
  inputs:
    - kubernetes_host
    - kubernetes_port:
        default: '443'
        required: true
    - kubernetes_auth_token:
        sensitive: true
    - namespace
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
    - api_to_list_kubernetes_endpoints:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://'+kubernetes_host+':'+kubernetes_port+'/api/v1/namespaces/'+namespace+'/endpoints'}"
            - auth_type: anonymous
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
            - headers: "${'Authorization: Bearer ' + kubernetes_auth_token}"
            - content_type: application/json
        publish:
          - status_code
          - return_result
        navigate:
          - SUCCESS: set_success_message
          - FAILURE: on_failure
    - get_list_of_endpoints:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${endpoints_json}'
            - json_path: '$.items[*].metadata.name'
        publish:
          - list_of_endpoints: "${return_result.strip('[').strip(\"]\").strip('\"').replace('\"','')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - set_success_message:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - message: "${'Information about the endpoints under namespace  '+namespace+' has been successfully retrieved.'}"
            - endpoints_json: '${return_result}'
        publish:
          - return_result: '${message}'
          - endpoints_json
        navigate:
          - SUCCESS: get_list_of_endpoints
          - FAILURE: on_failure
  outputs:
    - list_of_endpoints
    - endpoints_json
    - status_code
    - return_result
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      api_to_list_kubernetes_endpoints:
        x: 80
        'y': 200
      get_list_of_endpoints:
        x: 440
        'y': 200
        navigate:
          92876206-03c8-0dde-48b3-917528021231:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      set_success_message:
        x: 240
        'y': 200
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 680
          'y': 200
