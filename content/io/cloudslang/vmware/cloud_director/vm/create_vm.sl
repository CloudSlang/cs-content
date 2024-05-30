#   Copyright 2024 Open Text
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
#! @description: This flow is used to create vm in VMware Cloud Director.
#!
#! @input protocol: The protocol for rest API call. Default: https
#! @input host_name: The host name of the VMWare vCloud director.
#! @input port: The port of the host. Default: 443
#! @input access_token: The authorization token for vCloud director.
#! @input vdc_id: The id of the virtual data center.
#! @input vm_template_id: The template id of vm.
#! @input vm_name: The name of the zone where the disk is located.
#!                 Examples: 'us-central1-a, us-central1-b, us-central1-c'
#! @input vm_description: The description of the virtual machine.
#! @input vm_template_href: The href value of the virtual machine.
#! @input vm_template_name: The name of the virtual machine template.
#! @input network_name: The name of the network.
#! @input ip_address_allocation_mode: The mode of IP allocation. Valid values are 'POOL', 'MANUAL' and 'DHCP'.
#! @input network_adapter_type: The type of network adapter. Valid values 'VMXNET3', 'E1000' and 'E1000E' and etc
#! @input computer_name: The name of the computer.
#! @input storage_profile: The href of the storage profile to be associated with vApp.
#! @input ip_address: The value of IP Address in case of manual assignment of IP.
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input proxy_host: The proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: The proxy server used to access the provider services.
#!                    Optional
#! @input proxy_username: The proxy server username.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL.Default: 'false'Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name inthe subject's Common Name (CN) or subjectAltName field of the X.509 certificateValid: 'strict', 'browser_compatible', 'allow_all'Default: 'strict'Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates fromother parties that you expect to communicate with, or from Certificate Authorities thatyou trust to identify other parties.  If the protocol (specified by the 'url') is not'https' or if trust_all_roots is 'true' this input is ignored.Default value: '..JAVA_HOME/java/lib/security/cacerts'Format: Java KeyStore (JKS)Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is falseand trust_keystore is empty, trust_password default will be supplied.Optional
#!
#! @output return_result: contains the exception in case of failure, success message otherwise.
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output exception: exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: vm created successfully.
#! @result FAILURE: Error while creating vm.
#!!#
########################################################################################################################
namespace: io.cloudslang.vmware.cloud_director.vm
flow:
  name: create_vm
  inputs:
    - protocol: https
    - host_name
    - port: '443'
    - access_token:
        sensitive: true
    - vdc_id
    - vm_template_id:
        sensitive: false
    - vm_name
    - vm_description:
        required: false
    - vm_template_href:
        required: true
    - vm_template_name:
        required: true
    - network_name:
        required: true
    - ip_address_allocation_mode:
        required: true
    - network_adapter_type:
        required: true
    - computer_name:
        required: false
    - storage_profile:
        required: false
    - ip_address:
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
  workflow:
    - vm_request_body:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.vmware.cloud_director.utils.create_vm_request_body:
            - vm_name: '${vm_name}'
            - vm_template_id: '${vm_template_id}'
            - vm_template_href: '${vm_template_href}'
            - vm_template_name: '${vm_template_name}'
            - network_name: '${network_name}'
            - ip_address_allocation_mode: '${ip_address_allocation_mode}'
            - network_adapter_type: '${network_adapter_type}'
            - computer_name: '${computer_name}'
            - storage_profile: '${storage_profile}'
            - ip_address: '${ip_address}'
        publish:
          - vm_request_body: '${return_result}'
        navigate:
          - SUCCESS: create_vapp_api_call
    - create_vapp_api_call:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${protocol + '://'+ host_name + ':' + port + '/api/vdc/'+vdc_id+'/action/instantiateVmFromTemplate'}"
            - auth_type: anonymous
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
            - headers: "${'Accept: application/*+json;version=37.2' + '\\n' +'Authorization: ' + access_token + '\\n' +'Content-Type: application/*+xml;charset=UTF-8'}"
            - body: '${vm_request_body}'
            - content_type: application/json
            - worker_group: '${worker_group}'
        publish:
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result
    - return_code
    - exception
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      vm_request_body:
        x: 160
        'y': 120
      create_vapp_api_call:
        x: 360
        'y': 120
        navigate:
          e5ab9dd5-9e18-47ab-6d0b-ca2f6c6054c2:
            targetId: 39b3c3fe-524e-b2fb-d62e-f1abcd08f3ba
            port: SUCCESS
    results:
      SUCCESS:
        39b3c3fe-524e-b2fb-d62e-f1abcd08f3ba:
          x: 520
          'y': 120
