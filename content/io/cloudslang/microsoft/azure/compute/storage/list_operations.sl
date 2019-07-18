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
#! @description: This operation can be used to retrieve a list of operations supported by the storage resource provider
#!
#! @input subscription_id: The ID of the Azure Subscription on which the VM should be created.
#! @input auth_token: Azure authorization Bearer token
#! @input list_cont_auth_header: Storage authorization header
#! @input api_version: The API version used to create calls to Azure
#!                     Default: '2015-04-05'
#! @input date: Specifies the Coordinated Universal Time (UTC) for the request
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
#! @output output: The list of the list of the operations supported by the storage resource provider
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output error_message: If the operations are not found the error message will be populated with a response,
#!                        empty otherwise
#!
#! @result SUCCESS: The list of the operations supported by the storage resource provider retrieved successfully.
#! @result FAILURE: There was an error while trying to retrieve the list of the operations supported by the storage
#!                  resource provider
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.compute.storage

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: list_operations

  inputs:
    - subscription_id
    - auth_token
    - list_cont_auth_header
    - api_version:
        required: false
        default: '2015-04-05'
    - date
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
    - list_operations:
        do:
          http.http_client_get:
            - url: ${'https://management.azure.com/providers/Microsoft.Storage/operations?api-version=' + api_version}
            - headers: >
                ${'Authorization: ' + list_cont_auth_header + '\n' +
                'x-ms-date:' + date + '\n' +
                'x-ms-version:' + api_version}
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

