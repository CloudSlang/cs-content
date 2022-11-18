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
#! @description: This operation can retrieve the list of machine types, as a JSON array.
#!
#! @input access_token: The authorization token for google cloud.
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input zone: The name of the zone from which the machine types list retrieved. Examples: 'us-central1-a', 'us-central1-b', 'us-central1-c'
#! @input filter: A filter expression that filters resources listed in the response. Most Compute resources support two
#!                types of filter expressions: expressions that support regular expressions and expressions that follow
#!                API improvement proposal AIP-160.
#!                If you want to use AIP-160, your expression must specify the field name, an operator, and the value
#!                that you want to use for filtering. The value must be a string, a number, or a boolean.
#!                The operator must be either =, !=, >, <, <=, >= or :.
#!                For example, if you are filtering Compute Engine instances, you can exclude instances named
#!                example-instance by specifying name != example-instance.
#!                The : operator can be used with string fields to match substrings. For non-string fields it is
#!                equivalent to the = operator. The :* comparison can be used to test whether a key has been defined.
#!                Optional
#! @input page_token: Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list
#!                    request to get the next page of results.
#!                    Optional
#! @input max_results: The maximum number of results per page that should be returned. If the number of available
#!                     results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get
#!                     the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive.
#!                     Optional
#! @input order_by: Sorts list results by a certain order. By default, results are returned in alphanumerical order
#!                  based on the resource name.
#!                  You can also sort results in descending order based on the creation timestamp using
#!                  orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse
#!                  chronological order (newest result first). Use this to sort resources like operations so that the
#!                  newest operation is returned first.
#!                  Currently, only sorting by name or creationTimestamp desc is supported.
#!                  Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input proxy_host: Proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services.
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: '..JAVA_HOME/java/lib/security/cacerts'
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#!
#! @output return_result: This will contain the response message.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output machine_types_json: A JSON list containing the machine types information.
#!
#! @result SUCCESS: The machine types successfully retrieved.
#! @result FAILURE: The machine types were not found or some inputs were given incorrectly.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute_v2.instances

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: list_machine_types
  inputs:
    - access_token:
        sensitive: true
    - project_id:
        sensitive: true
    - zone:
        required: true
    - filter:
        required: false
    - page_token:
        required: false
    - max_results:
        required: false
    - order_by:
        required: false
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
    - check_query_params:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.compute_v2.instances.subflows.check_query_parameters:
            - filter: '${filter}'
            - max_results: '${max_results}'
            - page_token: '${page_token}'
            - order_by: '${order_by}'
        publish:
          - query_params: '${return_result}'
        navigate:
          - SUCCESS: api_to_list_machine_types
    - api_to_list_machine_types:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://compute.googleapis.com/compute/v1/projects/'+project_id+'/zones/'+zone+'/machineTypes'}"
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
            - headers: "${'Authorization: '+access_token}"
            - query_params: '${query_params}'
            - content_type: application/json
            - worker_group: '${worker_group}'
        publish:
          - return_result
          - status_code
        navigate:
          - SUCCESS: set_success_message
          - FAILURE: on_failure
    - set_success_message:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - message: Information about the machine types retrieved successfully.
            - machine_types_json: '${return_result}'
        publish:
          - return_result: '${message}'
          - machine_types_json
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result
    - status_code
    - machine_types_json
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      check_query_params:
        x: 160
        'y': 120
      api_to_list_machine_types:
        x: 360
        'y': 120
      set_success_message:
        x: 520
        'y': 120
        navigate:
          07fcb95b-c35b-4733-c816-ea61f64cc0ee:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 680
          'y': 120
