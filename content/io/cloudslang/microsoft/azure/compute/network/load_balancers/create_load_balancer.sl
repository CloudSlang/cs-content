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
#! @description: This operation can be used to create a load balancer.
#!
#! @input subscription_id: The ID of the Azure Subscription on which the VM should be created.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to create the VM.
#! @input api_version: The API version used to create calls to Azure
#! @input auth_token: Azure authorization Bearer token
#! @input nic_name: network interface card name
#! @input location: Specifies the supported Azure location where the load balancer should be created.
#!                  This can be different from the location of the resource group.
#! @input frontend_ip_name: Frontend IP name
#! @input backend_ip_pool_name: Backend IP pool name
#! @input private_ip_address: Private IP address
#! @input public_ip_address: Public IP address
#! @input probe_name: Probe name
#! @input load_balancer_name: Load balancer name
#! @input url: url to the Azure resource
#! @input public_ip_address_name: Virtual machine public IP address
#! @input virtual_network_name: Name of the virtual network in which the virtual machine will be assigned to
#! @input subnet_name: The name of the Subnet in which the created VM should be added.
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
#! @output output: json response about the load balancer created
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output error_message: If a load balancer is not found the error message will be populated with a response,
#!                        empty otherwise
#!
#! @result SUCCESS: Load balancer created successfully.
#! @result FAILURE: There was an error while trying to create the load balancer.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.compute.network.load_balancers

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: create_load_balancer

  inputs:
    - subscription_id
    - resource_group_name
    - auth_token
    - api_version:
        required: false
        default: '2015-06-15'
    - location
    - virtual_network_name
    - subnet_name
    - nic_name
    - frontend_ip_name
    - backend_ip_pool_name
    - private_ip_address
    - public_ip_address
    - probe_name
    - load_balancer_name
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
    - create_load_balancer:
        do:
          http.http_client_put:
            - url: >
                ${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' +
                resource_group_name + '/providers/Microsoft.Network/loadBalancers/' + load_balancer_name +
                '?api-version=' + api_version}
            - body: >
                ${'{"location":"' + location +
                '","tags":{"key":"value"},"properties":{"frontendIPConfigurations":{"name":"' + frontend_ip_name +
                '","properties":{"subnet":{"id":"/subscriptions/' + subscription_id + '/resourceGroups/' +
                resource_group_name + '/providers/Microsoft.Network/virtualNetworks/' + virtual_network_name +
                '/subnets/' + subnet_name + '"},"privateIPAddress":"' + private_ip_address +
                '","privateIPAllocationMethod":"Static","publicIPAddress":{"id":"/subscriptions/' + subscription_id +
                '/resourceGroups/' + resource_group_name + '/providers/Microsoft.Network/publicIPAddresses/' +
                public_ip_address + '"}}},"backendAddressPools":[{"name":"' + backend_ip_pool_name +
                '"}],"loadBalancingRules":[{"name":"HTTP Traffic","properties":{"frontendIPConfiguration":{' +
                '"id":"/subscriptions/' + subscription_id + '/resourceGroups/' + resource_group_name +
                '/providers/Microsoft.Network/loadBalancers/' + load_balancer_name +
                '/frontendIPConfigurations/ip1"},"backendAddressPool":{"id":"/subscriptions/' + subscription_id +
                '/resourceGroups/' + resource_group_name + '/providers/Microsoft.Network/loadBalancers/' +
                load_balancer_name + '/backendAddressPool/pool1"},"protocol":"Tcp","frontendPort":80,"backendPort":' +
                '8080,"probe":{"id":"/subscriptions/' + subscription_id + '/resourceGroups/' + resource_group_name +
                '/providers/Microsoft.Network/loadBalancers/' + load_balancer_name +
                '/probes/probe1"},"enableFloatingIP":true,"idleTimeoutInMinutes":4,"loadDistribution":"Default"}}],' +
                '"probes":[{"name":"' + probe_name + '", "properties":{"protocol":"Tcp","port":8080,"requestPath":' +
                '"myprobeapp1/myprobe1.svc","intervalInSeconds":5,"numberOfProbes":16}}],"inboundNatRules":[{"name":' +
                '"RDP Traffic","properties":{"frontendIPConfiguration":{"id":"/subscriptions/' + subscription_id +
                '/resourceGroups/' + resource_group_name + '/providers/Microsoft.Network/loadBalancers/' +
                load_balancer_name + '/frontendIPConfigurations/ip1"},"protocol":"Tcp",' +
                '"frontendPort":3389,"backendPort":3389}}]}}'}
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

