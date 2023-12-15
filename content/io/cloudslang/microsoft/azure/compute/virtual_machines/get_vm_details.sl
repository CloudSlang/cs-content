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
#! @description: This operation can be used to retrieve information about a virtual machine
#!
#! @input subscription_id: The ID of the Azure Subscription on which the VM should be created.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to get the VM details.
#! @input auth_token: Azure authorization Bearer token
#! @input api_version: The API version used to create calls to Azure
#!                     Default: '2015-06-15'
#! @input vm_name: The name of the virtual machine to retrieve information from.
#!                 Virtual machine name cannot contain non-ASCII or special characters.
#! @input connect_timeout: Optional - time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#! @input socket_timeout: Optional - time in seconds to wait for data to be retrieved
#!                        Default: '0' (infinite)
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - Username used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input trust_keystore: Optional - the pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - the password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Default: ''
#! @input x_509_hostname_verifier: Optional - specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#!                                 Default: 'strict'
#!
#! @output output: json response with details about the virtual machine
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output error_message: If a VM is not found the error message will be populated with a response, empty otherwise
#!
#! @result SUCCESS: Virtual machine details retrieved successfully.
#! @result FAILURE: There was an error while trying to retrieve details about the virtual machine.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.compute.virtual_machines

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: get_vm_details
  inputs:
    - subscription_id
    - resource_group_name
    - auth_token
    - api_version:
        default: '2015-06-15'
        required: false
    - vm_name
    - connect_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - proxy_port:
        default: '8080'
        required: false
    - proxy_host:
        required: false
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        default: ********
        required: false
        sensitive: true
  workflow:
    - get_vm_details:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' +resource_group_name + '/providers/Microsoft.Compute/virtualMachines/' +vm_name + '?api-version=' + api_version}"
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
          547e21e4-88f6-8179-0b66-fcdf87a9b6cb:
            targetId: 066c1904-c6e8-6fda-bdfc-24a65483eba5
            port: SUCCESS
          5d3bdcaf-0e63-7f31-0b75-b5f92d2590a8:
            targetId: 066c1904-c6e8-6fda-bdfc-24a65483eba5
            port: FAILURE
      get_vm_details:
        x: 80
        'y': 200
        navigate:
          07680823-f278-5b3d-2416-2afb3adf1740:
            targetId: 7590fb35-28e7-0169-5c6e-59a5e5023601
            port: SUCCESS
    results:
      SUCCESS:
        7590fb35-28e7-0169-5c6e-59a5e5023601:
          x: 400
          'y': 125
      FAILURE:
        066c1904-c6e8-6fda-bdfc-24a65483eba5:
          x: 700
          'y': 250
