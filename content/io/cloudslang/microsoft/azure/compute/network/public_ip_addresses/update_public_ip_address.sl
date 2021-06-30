#   (c) Copyright 2021 Micro Focus, L.P.
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
#! @description: This operation can be used to update a public IP address
#!
#! @input subscription_id: The ID of the Azure Subscription on which the public IP address should be created.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to create the public IP address.
#! @input auth_token: Azure authorization Bearer token
#! @input api_version: The API version used to create calls to Azure
#!                     Default: '2016-03-30'
#! @input connect_timeout: Optional - time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#! @input socket_timeout: Optional - time in seconds to wait for data to be retrieved
#!                        Default: '0' (infinite)
#! @input location: Specifies the supported Azure location where public IP address should be created.
#!                  This can be different from the location of the resource group.
#! @input public_ip_address_name: Virtual machine public IP address
#! @input public_ip_address_version: Public IP address version
#!                                   Default: 'Ipv4'
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
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - the password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!
#! @output update_public_ip_json: json response about the public IP address created
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output error_message: If a public IP address could not be created the error message will be populated with a response,
#!                        empty otherwise
#!
#! @result SUCCESS: Public IP address created successfully.
#! @result FAILURE: There was an error while trying to create the public IP address.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.compute.network.public_ip_addresses
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: update_public_ip_address
  inputs:
    - subscription_id
    - resource_group_name
    - auth_token
    - api_version:
        default: '2016-03-30'
        required: false
    - connect_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
        required: false
    - location
    - public_ip_address_name
    - dns_name:
        required: true
    - worker_group:
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
        default: strict
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
  workflow:
    - update_public_ip_address:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          http.http_client_put:
            - url: "${'https://management.azure.com/subscriptions/' + subscription_id +'/resourceGroups/' + resource_group_name + '/providers/Microsoft.Network/publicIPAddresses/' + public_ip_address_name + '?api-version=' + api_version}"
            - body: "${'{\"location\":\"' + location + '\",\"properties\":{\"publicIPAllocationMethod\":\"Dynamic\",\"idleTimeoutInMinutes\":4,\"dnsSettings\":{\"domainNameLabel\":\"' + dns_name +'\"}}}'}"
            - headers: "${'Authorization: ' + auth_token}"
            - auth_type: anonymous
            - preemptive_auth: 'true'
            - content_type: application/json
            - request_character_set: UTF-8
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
    - update_public_ip_json: '${output}'
    - status_code
    - error_message
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      update_public_ip_address:
        x: 102
        'y': 249
        navigate:
          77c0a036-ecec-62c8-d2fe-c3d7b6dfdb3d:
            targetId: 6ae81ed1-6144-8588-2b48-7ed8f049bdb7
            port: SUCCESS
      retrieve_error:
        x: 400
        'y': 375
        navigate:
          2ec7b821-603e-f5b9-4cd6-df5cb547b480:
            targetId: a16ae609-8617-d37a-7116-2dbafbec39ab
            port: SUCCESS
          44ae8219-cdf7-48a6-7cb7-3c0f1d32351a:
            targetId: a16ae609-8617-d37a-7116-2dbafbec39ab
            port: FAILURE
    results:
      SUCCESS:
        6ae81ed1-6144-8588-2b48-7ed8f049bdb7:
          x: 400
          'y': 125
      FAILURE:
        a16ae609-8617-d37a-7116-2dbafbec39ab:
          x: 700
