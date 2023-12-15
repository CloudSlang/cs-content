#   Copyright 2023 Open Text
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
#! @description: This operation can be used to get information about a specified network interface card
#!
#! @input subscription_id: The ID of the Azure Subscription on which the network interface card
#!                         information should be retrieved.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to retrieve
#!                             information about the network interface card.
#! @input auth_token: Azure authorization Bearer token
#! @input api_version: The API version used to create calls to Azure
#!                     Default: '2015-06-15'
#!                     Optional
#! @input nic_name: network interface card name
#! @input connect_timeout: Time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#!                         Optional
#! @input socket_timeout: Time in seconds to wait for data to be retrieved
#!                        Default: '0' (infinite)
#!                        Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
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
#! @output output: information about the network interface card
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output error_message: If the network interface card is not found the error message will be populated with a response,
#!                        empty otherwise
#!
#! @result SUCCESS: Information about the network interface card retrieved successfully.
#! @result FAILURE: There was an error while trying to retrieve information about the network interface card.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.compute.network.network_interface_card

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow: 
  name: get_nic_name_info
  
  inputs:
    - subscription_id
    - resource_group_name
    - auth_token
    - api_version:
        required: false
        default: '2015-06-15'
    - nic_name
    - connect_timeout:
        default: "0"
        required: false
    - socket_timeout:
        default: "0"
        required: false
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
    - get_nic_info:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' +resource_group_name + '/providers/Microsoft.Network/networkInterfaces/' + nic_name +'?api-version=' + api_version}"
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
          642c279e-a958-2ff7-661b-f83267674976:
            targetId: af4569cf-6aee-8c4f-1029-43fea8ff8ae8
            port: SUCCESS
          82ebcb32-d70e-d453-439a-3f8077989aa4:
            targetId: af4569cf-6aee-8c4f-1029-43fea8ff8ae8
            port: FAILURE
      get_nic_info:
        x: 80
        'y': 240
        navigate:
          6aa28d25-8d2d-98e0-e670-a044337fd2e7:
            targetId: eeed5cca-ded3-0ca3-00f5-765198b512a9
            port: SUCCESS
    results:
      SUCCESS:
        eeed5cca-ded3-0ca3-00f5-765198b512a9:
          x: 400
          'y': 125
      FAILURE:
        af4569cf-6aee-8c4f-1029-43fea8ff8ae8:
          x: 700
          'y': 250

