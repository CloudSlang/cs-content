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
#!                         Default: '10'
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
        default: '10'
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
          - SUCCESS: get_subscription_params
    - get_subscription_params:
        do:
          io.cloudslang.hcm.utils.get_subscription_params:
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
        publish:
        - return_code
        - exception
        - final_list
        - return_result
        navigate:
        - SUCCESS: SUCCESS
        - FAILURE: FAILURE
  outputs:
  - return_result: '${return_result}'
  - return_code: '${return_code}'
  - error_message: '${error_message}'
  - final_list: '${final_list}'
  results:
  - SUCCESS
  - FAILURE
extensions:
  graph:
    steps:
      get_csa_user_identifier:
        x: 7
        y: 71
        navigate:
          628ce993-2555-f3b5-40a0-8cf8821c193f:
            targetId: 6306f32e-ac8b-2a15-82b1-d36b3527f1df
            port: FAILURE
      get_subscription_params:
        x: 453
        y: 84
        navigate:
          af158969-7381-df0d-45a7-7ee4a49e7882:
            targetId: 2fd4062c-60d3-a971-922b-da5fdb5a3531
            port: SUCCESS
          55a81b41-62c6-b837-c2ad-0f9f8494daf3:
            targetId: 6306f32e-ac8b-2a15-82b1-d36b3527f1df
            port: FAILURE
    results:
      SUCCESS:
        2fd4062c-60d3-a971-922b-da5fdb5a3531:
          x: 710
          y: 75
      FAILURE:
        6306f32e-ac8b-2a15-82b1-d36b3527f1df:
          x: 159
          y: 286
