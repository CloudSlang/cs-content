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
#! @description: This operation can be used to delete a load balancer
#!
#! @input subscription_id: The ID of the Azure Subscription on which the VM should be created.
#! @input api_version: The API version used to create calls to Azure
#! @input resource_group_name: The name of the Azure Resource Group that should be used to create the VM.
#! @input load_balancer_name: load balancer name
#! @input auth_token: Azure authorization Bearer token
#! @input load_balancer_name: Load balancer name
#! @input subnet_name: The name of the Subnet in which the created VM should be added.
#! @input auth_type: Optional - authentication type
#!                   Default: "anonymous"
#! @input preemptive_auth: Optional - if 'true' authentication info will be sent in the first request, otherwise a request
#!                         with no authentication info will be made and if server responds with 401 and a header
#!                         like WWW-Authenticate: Basic realm="myRealm" only then will the authentication info
#!                         will be sent - Default: true
#! @input content_type: Optional - content type that should be set in the request header, representing the MIME-type
#!                      of the data in the message body
#!                      Default: "application/json; charset=utf-8"
#! @input trust_keystore: Optional - the pathname of the Java TrustStore file. This contains certificates from other parties
#!                        that you expect to communicate with, or from Certificate Authorities that you trust to
#!                        identify other parties.  If the protocol (specified by the 'url') is not 'https' or if
#!                        trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - the password associated with the trust_keystore file. If trust_all_roots is false and trust_keystore is empty,
#!                        trustPassword default will be supplied.
#!                        Default value: ''
#! @input keystore: Optional - the pathname of the Java KeyStore file. You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is 'true' this input is ignored.
#!                  Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                  Format: Java KeyStore (JKS)
#! @input keystore_password: Optional - the password associated with the KeyStore file. If trust_all_roots is false and keystore
#!                           is empty, keystore_password default will be supplied.
#!                           Default value: ''
#! @input trust_all_roots: Optional - specifies whether to enable weak security over SSL - Default: false
#! @input x_509_hostname_verifier: Optional - specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#!                                 Default: 'strict'
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - username used when connecting to the proxy
#! @input proxy_password: Optional - proxy server password associated with the <proxy_username> input value
#! @input connections_max_per_route: Optional - maximum limit of connections on a per route basis - Default: '50'
#! @input connections_max_total: Optional - maximum limit of connections in total - Default: '500'
#! @input use_cookies: Optional - specifies whether to enable cookie tracking or not - Default: true
#! @input keep_alive: Optional - specifies whether to create a shared connection that will be used in subsequent calls
#!                    Default: true
#! @input request_character_set: Optional - character encoding to be used for the HTTP request - Default: 'UTF-8'
#! @input chunked_request_entity: Optional - data is sent in a series of 'chunks' - Valid: true/false
#!                                Default: "false"
#!
#! @output output: json response with information of the deleted load balancer
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output error_message: If a load balancer is not found the error message will be populated with a response,
#!                        empty otherwise
#!
#! @result SUCCESS: load balancer deleted successfully.
#! @result FAILURE: There was an error while trying to delete the load balancer.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.compute.network.load_balancers

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: delete_load_balancer

  inputs:
    - auth_token
    - subnet_name
    - load_balancer_name
    - resource_group_name
    - subscription_id
    - api_version:
        required: false
        default: '2015-06-15'
    - auth_type:
        default: 'anonymous'
        required: false
    - preemptive_auth:
        default: 'true'
        required: false
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
        default: 'strict'
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        default: ''
        sensitive: true
        required: false
    - keystore:
        required: false
    - keystore_password:
        default: ''
        sensitive: true
        required: false
    - use_cookies:
        default: 'true'
        required: false
    - keep_alive:
        default: 'true'
        required: false
    - connections_max_per_route:
        default: '20'
        required: false
    - connections_max_total:
        default: '200'
        required: false
    - content_type:
        default: 'application/json'
        required: false
    - request_character_set:
        default: 'UTF-8'
        required: false

  workflow:
    - delete_load_balancer:
        do:
          http.http_client_delete:
            - url: >
                ${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' +
                resource_group_nname + '/providers/Microsoft.Network/loadBalancers/' + load_balancer_name +
                '/' + subnet_name + '?api-version=' + api_version}
            - headers: "${'Authorization: ' + auth_token}"
            - auth_type
            - preemptive_auth
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - use_cookies
            - keep_alive
            - connections_max_per_route
            - connections_max_total
            - content_type
            - request_character_set
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

