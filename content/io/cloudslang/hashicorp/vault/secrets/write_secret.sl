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
#! @description: Executes a '/v1/secret/${secret}' POST call against a Vault Server to write a particular secret.
#!
#! @input hostname: Vault's FQDN.
#! @input port: Vault's Port.
#! @input protocol: Vault's Protocol.
#!                  Default: 'https'
#!                  Possible values: 'https' and 'http'.
#! @input x_vault_token: Vault's X-VAULT-Token.
#! @input secret: The Secret to be written on the vault server.
#! @input secret_value: The value to be written on the vault server.
#! @input proxy_host: Proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: Proxy server port.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: User name used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#! @input keystore: The pathname of the Java KeyStore file.
#!                  You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trust_all_roots is 'true'
#!                  this input is ignored.
#!                  Format: Java KeyStore (JKS)
#!                  Optional
#! @input keystore_password: The password associated with the KeyStore file. If trust_all_roots is false and
#!                           keystore is empty, keystore_password default will be supplied.
#!                           Optional
#! @input connect_timeout: Time in seconds to wait for a connection to be established.
#!                         Default: '0' (infinite)
#!                         Optional
#! @input socket_timeout: Time in seconds to wait for data to be retrieved.
#!                        Default: '0' (infinite)
#!                        Optional
#!
#! @output secret_value: The value stored in Vault for the requested secret.
#! @output return_result: The response of the operation in case of success or the error message otherwise.
#! @output error_message: return_result if status_code is not contained in interval between '200' and '299'.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: Status code of the HTTP call.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#!
#! @result SUCCESS: Everything completed successfully and the secret have been written to Vault.
#! @result FAILURE: Something went wrong. Most likely Vault's return_result was not as expected and status_code was not 204.
#!!#
########################################################################################################################

namespace: io.cloudslang.hashicorp.vault.secrets

imports:
  http: io.cloudslang.base.http
  strings: io.cloudslang.base.strings

flow:
  name: write_secret

  inputs:
    - protocol:
        default: 'https'
    - hostname
    - port
    - secret
    - x_vault_token:
        sensitive: true
    - secret_value:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
    - keystore:
        required: false
    - keystore_password:
        required: false
    - connect_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
        required: false

  workflow:
    - create_vault_secret:
        do:
          http.http_client_post:
            - url: "${protocol + '://' + hostname + ':' + port + '/v1/secret/' + secret}"
            - headers: "${'X-VAULT-Token: ' + x_vault_token}"
            - body: "${'{\"value\":\"' + secret_value + '\"}'}"
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - connect_timeout
            - socket_timeout
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
          - response_headers
        navigate:
          - SUCCESS: is_status_code_204
          - FAILURE: on_failure

    - is_status_code_204:
        do:
          strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '204'
        publish: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure

  outputs:
    - return_result
    - return_code
    - status_code
    - error_message
    - response_headers

  results:
    - SUCCESS
    - FAILURE