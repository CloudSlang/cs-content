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
#! @description: This operation can be used to create a network interface card
#!
#! @input subscription_id: The ID of the Azure Subscription on which the network interface card should be created.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to create the network interface card.
#! @input auth_token: Azure authorization Bearer token
#! @input api_version: The API version used to create calls to Azure
#!                     Default: '2015-06-15'
#! @input nic_name: network interface card name
#! @input virtual_network_name: Name of the virtual network in which the virtual machine will be assigned to
#! @input subnet_name: The name of the Subnet in which the created VM should be added.
#! @input location: Specifies the supported Azure location where the network interface card should be created.
#!                  This can be different from the location of the resource group.
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
#! @output output: json response about the network card interface created
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output error_message: If a network interface card could not be created the error message will be populated with
#!                        a response, empty otherwise
#!
#! @result SUCCESS: Network interface card created successfully.
#! @result FAILURE: There was an error while trying to create the network interface card.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.compute.network.network_interface_card
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: create_nic_without_public_ip
  inputs:
    - subscription_id
    - resource_group_name
    - auth_token:
        sensitive: true
    - api_version:
        default: '2015-06-15'
        required: false
    - nic_name
    - virtual_network_name
    - subnet_name
    - location
    - connect_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
    - proxy_host:
        required: false
    - proxy_port:
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
    - dns_json:
        required: false
  workflow:
    - create_network_interface_card:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          http.http_client_put:
            - url: "${'https://management.azure.com/subscriptions/' + subscription_id +'/resourceGroups/' + resource_group_name + '/providers/Microsoft.Network/networkInterfaces/' + nic_name + '?api-version=' + api_version}"
            - body: "${'{\"location\":\"' + location + '\",\"properties\":{\"ipConfigurations\":[{\"name\":\"' + nic_name + '\",\"properties\":{\"subnet\":{\"id\":\"/subscriptions/' + subscription_id + '/resourceGroups/' +resource_group_name + '/providers/Microsoft.Network/virtualNetworks/' + virtual_network_name +'/subnets/' + subnet_name + '\"}}}],\"dnsSettings\":{\"dnsServers\":['+dns_json+'],\"internalDnsNameLabel\":\"dns'+nic_name+'\"}}}'}"
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
    - output
    - status_code
    - error_message
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      create_network_interface_card:
        x: 100
        'y': 250
        navigate:
          3c4eb0a1-d01d-4365-2bf6-087c64f5349c:
            targetId: 07b4758a-7445-d51e-4e73-9655c87b6d82
            port: SUCCESS
      retrieve_error:
        x: 400
        'y': 375
        navigate:
          1cd7c749-2a61-e602-1457-ef3616652e1b:
            targetId: 2e63f609-32be-ef15-d642-e0e725280ff3
            port: SUCCESS
          5fd6d141-7a8d-0367-1e2a-6847a5c64fbc:
            targetId: 2e63f609-32be-ef15-d642-e0e725280ff3
            port: FAILURE
    results:
      SUCCESS:
        07b4758a-7445-d51e-4e73-9655c87b6d82:
          x: 400
          'y': 125
      FAILURE:
        2e63f609-32be-ef15-d642-e0e725280ff3:
          x: 700
          'y': 250
