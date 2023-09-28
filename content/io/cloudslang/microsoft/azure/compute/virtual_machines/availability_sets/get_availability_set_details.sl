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
#! @description: This operation can be used to retrieve a JSON array containing details about
#!               the specified availability set.
#!
#! @input subscription_id: The ID of the Azure Subscription on which the VM should be created.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to create the VM.
#! @input auth_token: Azure authorization Bearer token
#! @input api_version: The API version used to create calls to Azure
#!                     Default: '2016-09-01'
#! @input availability_set_name: availability set name
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Optional
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - Username used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input x_509_hostname_verifier: Optional - specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#!                                 Default: 'strict'
#! @input trust_keystore: Optional - the pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - the password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!
#! @output output: information about the specified availability set
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output error_message: If the availability set is not found the error message will be populated with a response,
#!                        empty otherwise
#!
#! @result SUCCESS: Information about the availability set retrieved successfully.
#! @result FAILURE: There was an error while trying to retrieve retrieve information about the availability set
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.compute.virtual_machines.availability_sets

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: get_availability_set_details

  inputs:
    - subscription_id
    - resource_group_name
    - auth_token
    - api_version:
        required: false
        default: '2019-07-01'
    - availability_set_name
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
    - get_information_about_availability_set:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          http.http_client_get:
            - url: "${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' +resource_group_name + '/providers/Microsoft.Compute/availabilitySets/' + availability_set_name +'?api-version=' + api_version}"
            - headers: "${'Authorization: ' + auth_token}"
            - auth_type: anonymous
            - preemptive_auth: 'true'
            - content_type: application/json
            - request_character_set: UTF-8
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
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
      get_information_about_availability_set:
        x: 100
        'y': 250
        navigate:
          cdee64f0-f453-18fc-5a6e-0d0f65dbe30b:
            targetId: cdb7c897-4524-40ac-9560-874b8940f662
            port: SUCCESS
      retrieve_error:
        x: 400
        'y': 375
        navigate:
          17e5613e-0478-bc55-0936-c38725027e39:
            targetId: 430d7508-642a-e521-f94c-97b9a596de97
            port: SUCCESS
          0284fad2-b9e9-0ac8-e7cb-cd55ff9d88ed:
            targetId: 430d7508-642a-e521-f94c-97b9a596de97
            port: FAILURE
    results:
      SUCCESS:
        cdb7c897-4524-40ac-9560-874b8940f662:
          x: 400
          'y': 125
      FAILURE:
        430d7508-642a-e521-f94c-97b9a596de97:
          x: 700
          'y': 250


