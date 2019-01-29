#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: This operation can be used to retrieve a JSON array containing all available virtual machine sizes
#!               that can be used to create a new virtual machine in an existing availability set.
#!
#! @input subscription_id: The ID of the Azure Subscription from which the list of available vm sizes contained in the
#!                         specified availability set can be retrieved.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to retrieve all the virtual
#!                             machine sizes for the specified availability set.
#! @input api_version: The API version used to create calls to Azure.
#!                     Default: '2015-06-15'
#!                     Optional
#! @input availability_set_name: Availability set name.
#! @input auth_token: Azure authorization Bearer token.
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
#! @output output: The list of all available virtual machine sizes that can be used to create a new virtual machine
#!                 in an existing availability set.
#! @output status_code:  If successful, the operation returns 200 (OK); otherwise 502 (Bad Gateway) will be returned.
#! @output error_message: If no available virtual machine size that can be used is found the error message will be
#!                        populated with a response, empty otherwise.
#!
#! @result SUCCESS: The list of all available virtual machine sizes that can be used to create a new virtual machine
#!                  in an existing availability set.
#! @result FAILURE: There was an error while trying to retrieve the list of all available virtual machine sizes that can
#!                  be used to create a new virtual machine in an existing availability set.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.compute.virtual_machines

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: list_available_vm_sizes_in_an_availability_set

  inputs:
    - subscription_id
    - resource_group_name
    - auth_token
    - availability_set_name
    - api_version:
        required: false
        default: '2015-06-15'
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
    - list_available_vm_sizes_in_an_availability_set:
        do:
          http.http_client_get:
            - url: >
                ${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' +
                resource_group_name + '/providers/Microsoft.Compute/availabilitySets/' + availability_set_name +
                '/vmSizes?api-version=' + api_version}
            - headers: "${'Authorization: ' + auth_token}"
            - auth_type: 'anonymous'
            - preemptive_auth: 'true'
            - content_type: 'application/json'
            - request_character_set: 'UTF-8'
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - output: ${return_result}
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: retrieve_error

    - retrieve_error:
        do:
          json.get_value:
            - json_input: ${output}
            - json_path: 'error,message'
        publish:
          - error_message: ${return_result}
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
