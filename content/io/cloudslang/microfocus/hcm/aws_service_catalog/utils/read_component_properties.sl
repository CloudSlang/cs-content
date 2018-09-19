#   (c) Copyright 2018 Micro Focus, L.P.
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
#! @description: This flow retrieves the AWS Service Catalog provisioning parameters from a given CSA Subscription.
#!
#! @input csa_rest_uri: The Rest URI used to connect to the CSA host.
#! @input csa_user: The CSA user for which to retrieve the user identifier.
#! @input csa_subscription_id: The ID of the subscription for which to retrieve the component properties.
#! @input delimiter: The delimiter used to separate the values from component properties list.
#! @input auth_type: The type of authentication used by this operation when trying to execute the request on the target server.
#!                   Default 'basic'
#! @input username: The username used to connect to the CSA host.
#! @input password: Password associated with the <username> input to connect to the CSA host.
#! @input proxy_host: Proxy server used to access the web site.
#! @input proxy_port: Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Username used when connecting to the proxy.
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#! @input trust_all_roots: Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's 
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'. 
#!                                 Default: 'strict'
#! @input trust_keystore: Location of the TrustStore file. Format: a URL or the local path to it
#! @input trust_password: Password associated with the trust_keystore file.
#! @input keystore: Location of the KeyStore file.  Format: a URL or the local path to it.
#! @input keystore_password: Password associated with the KeyStore file.
#! @input connect_timeout: Time in seconds to wait for a connection to be established. 
#!                         Default: '0' (infinite timeout)
#! @input socket_timeout: Time in seconds to wait for data to be retrieved (maximum period inactivity between two 
#!                        consecutive data packets) 
#!                        Default: '0' (infinite timeout)
#! @input use_cookies: Specifies whether to enable cookie tracking or not. 
#!                     Default: 'true'
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls.  
#!                    Default: 'true'
#!
#! @output return_result: The list of provisioning parameters.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output error_message: Return_result when the return_code is non-zero (e.g. network or other failure).
#!
#! @result SUCCESS: Operation succeeded. The list of provisioning parameters was retrieved.
#! @result FAILURE: Operation failed. The list of provisioning parameters was not retrieved.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.hcm.aws_service_catalog.utils
flow:
  name: read_component_properties
  inputs:
    - csa_rest_uri:
        required: true
    - csa_user:
        required: true
    - csa_subscription_id:
        required: true
    - delimiter:
        default: ','
    - auth_type:
        default: basic
        required: false
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
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
    - keystore:
        required: false
    - keystore_password:
        required: false
        sensitive: true
    - connect_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
        required: false
    - use_cookies:
        default: 'true'
        required: false
    - keep_alive:
        default: 'true'
        required: false
  workflow:
    - get_csa_user_identifier:
        do:
          io.cloudslang.microfocus.hcm.aws_service_catalog.utils.get_csa_user_identifier:
            - csa_rest_uri: '${csa_rest_uri}'
            - csa_user: '${csa_user}'
            - auth_type: '${auth_type}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
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
            - keystore: '${keystore}'
            - keystore_password:
                value: '${keystore_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - use_cookies: '${use_cookies}'
            - keep_alive: '${keep_alive}'
        publish:
          - user_id
          - error_message
          - retrun_result
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: http_client_action
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${csa_rest_uri + '/artifact/' + csa_subscription_id}"
            - auth_type: '${auth_type}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
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
            - keystore: '${keystore}'
            - keystore_password:
                value: '${keystore_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - use_cookies: '${use_cookies}'
            - keep_alive: '${keep_alive}'
            - query_params: "${'userIdentifier=' + user_id + '&view=propertyvalue'}"
            - method: get
        publish:
          - return_result
          - error_message
          - return_code
          - xml_response: '${return_result}'
        navigate:
          - SUCCESS: xpath_query
          - FAILURE: FAILURE
    - xpath_query:
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${xml_response}'
            - xpath_query: '//options/property/*[ name()="displayName"]/text()'
            - delimiter: '${delimiter}'
        publish:
          - selected_keys: '${selected_value}'
        navigate:
          - SUCCESS: xpath_query_1
          - FAILURE: FAILURE
    - xpath_query_1:
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${xml_response}'
            - xpath_query: '//options/property/values/*[name()="value" ]/text()'
            - delimiter: '${delimiter}'
        publish:
          - selected_values: '${selected_value}'
        navigate:
          - SUCCESS: build_properties_list
          - FAILURE: FAILURE
    - build_properties_list:
        do:
          io.cloudslang.microfocus.hcm.aws_service_catalog.utils.build_properties_list:
            - list1: '${selected_keys}'
            - list2: '${selected_values}'
            - final_list: ' '
            - delimiter: '${delimiter}'
            - blank_list: ' '
        publish:
          - properties_list
          - list_props: '${blank_list}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: FAILURE
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${properties_list}'
            - separator: '${delimiter}'
        publish:
          - current_prop: '${result_string}'
        navigate:
          - HAS_MORE: string_occurrence_counter
          - NO_MORE: length
          - FAILURE: FAILURE
    - string_occurrence_counter:
        do:
          io.cloudslang.base.strings.string_occurrence_counter:
            - string_in_which_to_search: '${current_prop}'
            - string_to_find: param_
        publish:
          - occurence_count: '${return_result}'
        navigate:
          - SUCCESS: regex_replace
          - FAILURE: list_iterator
    - regex_replace:
        do:
          io.cloudslang.base.strings.regex_replace:
            - regex: param_
            - text: '${current_prop}'
            - replacement: ''
        publish:
          - result_text
        navigate:
          - SUCCESS: add_element
    - add_element:
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${list_props}'
            - element: '${result_text}'
            - delimiter: '${delimiter}'
        publish:
          - list_props: '${return_result}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: FAILURE
    - remove_by_index:
        do:
          io.cloudslang.base.lists.remove_by_index:
            - list: '${list_props}'
            - element: '0'
            - delimiter: '${delimiter}'
        publish:
          - list_props: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
    - length:
        do:
          io.cloudslang.base.lists.length:
            - list: '${list_props}'
            - delimiter: '${delimiter}'
        publish:
          - list_length: '${return_result}'
        navigate:
          - SUCCESS: compare_numbers
          - FAILURE: FAILURE
    - compare_numbers:
        do:
          io.cloudslang.base.math.compare_numbers:
            - value1: '${list_length}'
            - value2: '0'
        navigate:
          - GREATER_THAN: remove_by_index
          - EQUALS: SUCCESS
          - LESS_THAN: SUCCESS
  outputs:
    - return_result: '${list_props}'
    - return_code: '${return_code}'
    - error_message: '${error_message}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      remove_by_index:
        x: 1260
        y: 255
        navigate:
          9af0567a-8e16-55c9-e558-be120e20c484:
            targetId: 799e4596-aca7-0bc1-65b8-bcb03a6e347f
            port: FAILURE
      get_csa_user_identifier:
        x: 8
        y: 71
        navigate:
          628ce993-2555-f3b5-40a0-8cf8821c193f:
            targetId: 6306f32e-ac8b-2a15-82b1-d36b3527f1df
            port: FAILURE
      xpath_query:
        x: 349
        y: 72
        navigate:
          740edb64-7828-a4ca-91e4-48e4f1ec3aa0:
            targetId: 6306f32e-ac8b-2a15-82b1-d36b3527f1df
            port: FAILURE
      length:
        x: 1078
        y: 69
        navigate:
          0191b7a2-9dee-16e4-1555-238bd029059f:
            targetId: 799e4596-aca7-0bc1-65b8-bcb03a6e347f
            port: FAILURE
      list_iterator:
        x: 889
        y: 75
        navigate:
          e2839190-549d-2fd5-982c-53e74ff8056d:
            vertices:
              - x: 930
                y: 215
            targetId: string_occurrence_counter
            port: HAS_MORE
          02ce77f4-0b58-cd03-801e-0fe77c0ce159:
            targetId: 799e4596-aca7-0bc1-65b8-bcb03a6e347f
            port: FAILURE
      compare_numbers:
        x: 1266
        y: 74
        navigate:
          a0fca19d-bffe-7fe8-f0b1-658d3a08221b:
            targetId: 2fd4062c-60d3-a971-922b-da5fdb5a3531
            port: EQUALS
            vertices:
              - x: 1366
                y: 130
              - x: 1378
                y: 128
          f77bfb22-e860-f84a-9679-5887166752a1:
            targetId: 2fd4062c-60d3-a971-922b-da5fdb5a3531
            port: LESS_THAN
      http_client_action:
        x: 165
        y: 72
        navigate:
          f28f44ce-3371-7169-2f03-ebf5d731b65c:
            targetId: 6306f32e-ac8b-2a15-82b1-d36b3527f1df
            port: FAILURE
      xpath_query_1:
        x: 518
        y: 71
        navigate:
          b2625d4c-440c-a65e-e000-02494595c596:
            targetId: 4d495d15-0b35-9ed6-b3f2-5036fc1d34c6
            port: FAILURE
      build_properties_list:
        x: 704
        y: 68
        navigate:
          ea0691e8-16d5-c8b5-cb6b-b400deacd2c3:
            targetId: 4d495d15-0b35-9ed6-b3f2-5036fc1d34c6
            port: FAILURE
      string_occurrence_counter:
        x: 891
        y: 275
      regex_replace:
        x: 879
        y: 503
      add_element:
        x: 696
        y: 281
        navigate:
          6131add5-e45a-4f16-3385-ffa8573e516c:
            targetId: 4d495d15-0b35-9ed6-b3f2-5036fc1d34c6
            port: FAILURE
    results:
      SUCCESS:
        2fd4062c-60d3-a971-922b-da5fdb5a3531:
          x: 1381
          y: 78
      FAILURE:
        6306f32e-ac8b-2a15-82b1-d36b3527f1df:
          x: 159
          y: 286
        799e4596-aca7-0bc1-65b8-bcb03a6e347f:
          x: 1073
          y: 244
        4d495d15-0b35-9ed6-b3f2-5036fc1d34c6:
          x: 514
          y: 287
