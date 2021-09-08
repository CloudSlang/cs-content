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
#! @description: This operation can be used to start a virtual machine
#!
#! @input subscription_id: The ID of the Azure Subscription on which the VM should be started.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to start the VM.
#! @input auth_token: Azure authorization Bearer token
#! @input api_version: The API version used to create calls to Azure
#!                     Default: '2015-06-15'
#! @input vm_name: The name of the virtual machine to be started.
#!                 Virtual machine name cannot contain non-ASCII or special characters.
#! @input connect_timeout: Optional - time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#! @input socket_timeout: Optional - time in seconds to wait for data to be retrieved
#!                        Default: '0' (infinite)
#! @input proxy_host: Optional - proxy server used to access the web site
#! @input proxy_port: Optional - proxy server port
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
#! @output output: Json response with the information about the started VM.
#! @output status_code: 202 if request completed successfully, others in case something went wrong
#! @output error_message: If an error occurs while running the flow it will be populated in this output,
#!                        otherwise the output will be empty
#!
#! @result SUCCESS: Virtual machine started successfully.
#! @result FAILURE: There was an error while trying to start the virtual machine.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.compute.virtual_machines

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: start_vm

  inputs:
    - subscription_id
    - auth_token
    - vm_name
    - resource_group_name
    - api_version:
        default: '2015-06-15'
        required: false
    - connect_timeout:
        default: "0"
        required: false
    - socket_timeout:
        default: "0"
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - proxy_port:
        default: "8080"
        required: false
    - proxy_host:
        required: false
    - trust_all_roots:
        default: "false"
        required: false
    - x_509_hostname_verifier:
        default: "strict"
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        default: ''
        required: false
        sensitive: true

  workflow:

    - start_vm:
        do:
          http.http_client_post:
            - url: >
                ${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' +
                resource_group_name + '/providers/Microsoft.Compute/virtualMachines/' + vm_name +
                '/start?api-version=' + api_version}
            - headers: >
                     ${'Content-Length: 0' + '\n' +
                     'Authorization: '+ auth_token}
            - auth_type: 'anonymous'
            - preemptive_auth: 'true'
            - content_type: 'application/json'
            - request_character_set: 'UTF-8'
            - connect_timeout
            - socket_timeout
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - status_code
          - output: ${return_result}
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
