#   (c) Copyright 2023 Micro Focus, L.P.
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
#! @description: The operation is used to fetch Recommendation details for a particular Recommendation ID.
#!
#! @input auth_token: The authorization token for azure cloud.
#! @input recommendationId: The recommendation ID.
#! @input resourceUri: The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
#! @input proxy_host: Proxy server used to access the provider services.Optional
#! @input proxy_port: Proxy server port used to access the provider services.Optional
#! @input trust_keystore: Optional - the pathname of the Java TrustStore file. This contains certificates fromother parties that you expect to communicate with, or from Certificate Authorities thatyou trust to identify other parties.  If the protocol (specified by the 'url') is not'https' or if trust_all_roots is 'true' this input is ignored.Default value: ..JAVA_HOME/java/lib/security/cacertsFormat: Java KeyStore (JKS)
#! @input trust_password: Optional - the password associated with the trust_keystore file. If trust_all_roots is falseand trust_keystore is empty, trust_password default will be supplied.Default: ''
#! @input trust_all_roots: Specifies whether to enable weak security over SSL.Default: 'false'Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name inthe subject's Common Name (CN) or subjectAltName field of the X.509 certificateValid: 'strict', 'browser_compatible', 'allow_all'Default: 'strict'Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one groupsimultaneously.Default: 'RAS_Operator_Path'Optional
#!
#! @output return_result: json response with details about the Recommendation Details
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output error_message: Error in fetching recommendation details
#!
#! @result FAILURE: Error in fetching Recommendation details for particular Recommendation ID.
#! @result SUCCESS: The Recommendation details for particular Recommendation ID is fetched successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.microsoft.azure.advisor.recommendations
flow:
  name: get_recommendation_details
  inputs:
    - auth_token
    - recommendationId
    - resourceUri
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - api_call_to_get_recomendation_details:
        worker_group: "${get('worker_group', 'RAS_Operator_Path')}"
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${'https://management.azure.com/'+resourceUri+'/providers/Microsoft.Advisor/recommendations/'+recommendationId+'?api-version=2023-01-01'}"
            - auth_type: anonymous
            - username
            - password
            - tls_version
            - allowed_cyphers
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username
            - proxy_password
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - execution_timeout
            - connect_timeout
            - socket_timeout
            - keep_alive
            - connections_max_per_route
            - connections_max_total
            - headers: "${'Authorization: ' + auth_token}"
            - query_params
            - content_type
            - recommendationId: '${recommendationId}'
            - method: GET
            - request_character_set: utf-8
            - response_character_set: utf-8
            - resourceUri: '${resourceUri}'
        publish:
          - error_message
          - status_code
          - return_result
        navigate:
          - SUCCESS: set_success_message
          - FAILURE: on_failure
    - set_success_message:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - message: The Recommendation details for particular Recommendation ID is fetched successfully.
        publish:
          - output: '${message}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result
    - status_code
    - error_message
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      api_call_to_get_recomendation_details:
        x: 160
        'y': 240
      set_success_message:
        x: 320
        'y': 240
        navigate:
          8ae983b7-334d-8dff-bc05-dd9a68302f6b:
            targetId: 336280f1-4a0b-157f-ffeb-4d461839dcc0
            port: SUCCESS
    results:
      SUCCESS:
        336280f1-4a0b-157f-ffeb-4d461839dcc0:
          x: 480
          'y': 240
