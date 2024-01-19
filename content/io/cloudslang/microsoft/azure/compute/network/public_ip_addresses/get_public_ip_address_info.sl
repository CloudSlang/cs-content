#   Copyright 2024 Open Text
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
#! @description: This operation can be used to retrieve a JSON array containing information about
#!               a public specified IP address.
#!
#! @input subscription_id: The ID of the Azure Subscription on which the public IP address information should be retrieved.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to retrieve
#!                             information about the public IP address.
#! @input auth_token: Azure authorization Bearer token.
#! @input api_version: The API version used to create calls to Azure
#!                     Default: '2016-03-30'
#!                     Optional
#! @input public_ip_address_name: public IP address name
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: 'RAS_Operator_Path'.
#!                      Optional
#! @input connect_timeout: Optional - time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#! @input socket_timeout: Time in seconds to wait for data to be retrieved
#!                        Default: '0' (infinite)
#!                        Optional
#! @input proxy_host: Proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: Proxy server port.
#!                    Default: '8080'
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
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#!
#! @output output: information about the public IP address as a JSON array.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output error_message: If the IP address is not found the error message will be populated with a response,
#!                        empty otherwise.
#!
#! @result SUCCESS: Information about the public IP address retrieved successfully.
#! @result FAILURE: There was an error while trying to retrieve information about the public IP address.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.compute.network.public_ip_addresses

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: get_public_ip_address_info

  inputs:
    - subscription_id
    - resource_group_name
    - auth_token
    - api_version:
        required: false
        default: '2016-03-30'
    - connect_timeout:
        default: "0"
        required: false
    - socket_timeout:
        default: "0"
        required: false
    - public_ip_address_name
    - worker_group:
        default: RAS_Operator_Path
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        default: "8080"
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - trust_all_roots:
        default: "false"
        required: false
    - x_509_hostname_verifier:
        default: "strict"
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true

  workflow:
    - get_public_ip_address_info:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' +resource_group_name + '/providers/Microsoft.Network/publicIPAddresses/' + public_ip_address_name +'?api-version=' + api_version}"
            - auth_type: anonymous
            - preemptive_auth: 'true'
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
            - keystore: "${get_sp('io.cloudslang.base.http.keystore')}"
            - keystore_password:
                value: "${get_sp('io.cloudslang.base.http.keystore_password')}"
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: 'false'
            - connections_max_per_route: '2'
            - connections_max_total: '20'
            - headers: "${'Authorization: ' + auth_token}"
            - content_type: application/json
            - request_character_set: UTF-8
            - method: GET
        publish:
          - output: '${return_result}'
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: retrieve_error
    - retrieve_error:
        worker_group: '${worker_group}'
        do:
          json.get_value:
            - json_input: '${output}'
            - json_path: 'error,message'
        publish:
          - error_message: '${return_result}'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: FAILURE
  outputs:
    - output
    - status_code
    - error_message
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      retrieve_error:
        x: 400
        'y': 375
        navigate:
          40a3a966-a2d3-7114-0862-9add0d06d760:
            targetId: 7dc464f3-f9dc-b6b8-8569-d725059d7b6d
            port: SUCCESS
          2dcfc37f-9a2e-6105-e05c-352724a9f348:
            targetId: 7dc464f3-f9dc-b6b8-8569-d725059d7b6d
            port: FAILURE
      get_public_ip_address_info:
        x: 80
        'y': 240
        navigate:
          99ba5427-7e36-bc46-6720-87ae4ce1d8a1:
            targetId: 3dd45d46-5f6a-fb85-8ed3-485e08d467d8
            port: SUCCESS
    results:
      SUCCESS:
        3dd45d46-5f6a-fb85-8ed3-485e08d467d8:
          x: 400
          'y': 125
      FAILURE:
        7dc464f3-f9dc-b6b8-8569-d725059d7b6d:
          x: 700
          'y': 250

