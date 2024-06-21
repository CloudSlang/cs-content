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
#! @description: This flow deploys the virtual machine in the given VMWare vCloud Director provider.
#!
#! @input provider_sap: The provider service access point for the vCloud director.
#! @input api_token: The refresh token for the vCloud.
#! @input tenant_name: The name of the Tenant.
#! @input vdc_id: The id of the virtual data center.
#! @input vm_template: The template id of virtual machine.
#! @input vm_name: The name of the virtual machine.
#! @input network_name: The name of the network needs to be attached to the vm.
#! @input ip_address_allocation_mode: The mode of IP allocation.
#!                                    Valid values are 'POOL', 'MANUAL' and 'DHCP'.
#! @input network_adapter_type: The type of network adapter.
#!                              Valid values 'VMXNET3', 'E1000' and 'E1000E' and etc
#! @input ip_address: The value of IP Address in case of manual assignment of IP.
#! @input storage_profile: The name of the storage profile to be associated with vApp.
#! @input polling_interval: The number of seconds to wait until performing another check.Default: '20'Optional
#! @input polling_retries: The number of retries to check if the instance is stopped.Default: '30'Optional
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
#! @output final_vm_name: The name of the vm deployed.
#! @output vm_id: The id of the vm.
#! @output vm_status: The status of created vApp.
#! @output vm_ip_address: The IP address of the vm.
#! @output vm_mac_address: The MAC address of the vm.
#! @output number_of_cpu: The Number of CPU of vm .
#! @output memory: The memory of vm.
#!
#! @result SUCCESS: vm deployed successfully.
#! @result FAILURE: Failed to deploy the vm.
#!!#
########################################################################################################################
namespace: io.cloudslang.vmware.cloud_director
flow:
  name: vcloud_deploy_vm
  inputs:
    - provider_sap:
        sensitive: false
    - api_token:
        sensitive: true
    - tenant_name:
        sensitive: false
    - vdc_id
    - vm_template:
        sensitive: false
    - vm_name
    - network_name:
        required: true
    - ip_address_allocation_mode: POOL
    - network_adapter_type: VMXNET3
    - ip_address:
        required: false
    - storage_profile:
        required: false
    - polling_interval:
        default: '30'
        required: false
    - polling_retries:
        default: '30'
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
    - get_host_details:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.vmware.cloud_director.utils.get_host_details:
            - provider_sap: '${provider_sap}'
        publish:
          - host_name: '${hostname}'
          - protocol
          - port
        navigate:
          - SUCCESS: get_access_token_using_web_api
    - get_access_token_using_web_api:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.vmware.cloud_director.authorization.get_access_token_using_web_api:
            - host_name: '${host_name}'
            - protocol: '${protocol}'
            - port: '${port}'
            - organization: '${tenant_name}'
            - refresh_token:
                value: '${api_token}'
                sensitive: true
            - worker_group: '${worker_group}'
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
        publish:
          - access_token
        navigate:
          - SUCCESS: random_number_generator
          - FAILURE: on_failure
    - random_number_generator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.math.random_number_generator:
            - min: '10000'
            - max: '99999'
        publish:
          - random_number
        navigate:
          - SUCCESS: create_vm
          - FAILURE: on_failure
    - get_vapp_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.vmware.cloud_director.vapp.get_vapp_details:
            - host_name: '${host_name}'
            - port: '${port}'
            - protocol: '${protocol}'
            - access_token: '${access_token}'
            - vapp_id: '${vapp_id}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - worker_group: '${worker_group}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - vapp_details: '${return_result}'
        navigate:
          - SUCCESS: get_vm_names
          - FAILURE: on_failure
    - get_vm_names:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${vapp_details}'
            - json_path: '$.children.vm[*].name'
        publish:
          - final_vm_name: "${return_result.replace('\"','').strip('[').strip(']')}"
        navigate:
          - SUCCESS: get_vm_status
          - FAILURE: on_failure
    - wait_for_vm_creation:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '30'
        navigate:
          - SUCCESS: get_vapp_details
          - FAILURE: on_failure
    - is_vm_status_is_8:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${vm_status}'
            - second_string: '8'
        publish: []
        navigate:
          - SUCCESS: get_vm_id_list
          - FAILURE: is_vm_status_is_4
    - is_vm_status_is_4:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${vm_status}'
            - second_string: '4'
        publish: []
        navigate:
          - SUCCESS: get_vm_id_list
          - FAILURE: is_vm_status_is_20
    - get_vm_id_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${vapp_details}'
            - json_path: '$.children.vm[*].id'
        publish:
          - vm_id: "${return_result.replace('urn:vcloud:vm:','vm-').replace('\"','').strip('[').strip(']').replace(' ','')}"
        navigate:
          - SUCCESS: get_vm_ip
          - FAILURE: on_failure
    - get_vm_ip:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${vapp_details}'
            - json_path: "${'$.children.vm[?(@.name==\"'+final_vm_name+'\")].section[?(@._type==\"NetworkConnectionSectionType\")].networkConnection[0].ipAddress'}"
        publish:
          - vm_ip_address: "${return_result.strip('[\"').strip('\"]')}"
        navigate:
          - SUCCESS: compare_ip_1
          - FAILURE: on_failure
    - get_vm_mac_address:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${vapp_details}'
            - json_path: "${'$.children.vm[?(@.name==\"'+final_vm_name+'\")].section[?(@._type==\"NetworkConnectionSectionType\")].networkConnection[0].macAddress'}"
        publish:
          - vm_mac_address: "${return_result.strip('[\"').strip('\"]')}"
        navigate:
          - SUCCESS: is_vm_ip_list_is_null
          - FAILURE: on_failure
    - create_vm:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.vmware.cloud_director.vm.create_vm:
            - protocol: '${protocol}'
            - host_name: '${host_name}'
            - port: '${port}'
            - access_token:
                value: '${access_token}'
                sensitive: true
            - vdc_id: '${vdc_id}'
            - vm_template_id: "${vm_template.split('|||')[1]}"
            - vm_name: '${vm_name+random_number}'
            - vm_template_href: "${vm_template.split('|||')[0]}"
            - vm_template_name: "${vm_template.split('|||')[2]}"
            - network_name: '${network_name}'
            - ip_address_allocation_mode: '${ip_address_allocation_mode}'
            - network_adapter_type: '${network_adapter_type}'
            - computer_name: '${vm_name}'
            - storage_profile: '${storage_profile}'
            - ip_address: '${ip_address}'
            - worker_group: '${worker_group}'
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
        publish:
          - vm_details: '${return_result}'
        navigate:
          - SUCCESS: get_vapp_id
          - FAILURE: on_failure
    - get_vapp_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${vm_details}'
            - json_path: operation
        publish:
          - vapp_id: "${'vapp-' + return_result.split(\"(\")[1].replace(')','')}"
        navigate:
          - SUCCESS: wait_for_vm_creation
          - FAILURE: on_failure
    - is_vm_status_is_20:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${vm_status}'
            - second_string: '20'
        publish: []
        navigate:
          - SUCCESS: wait_for_vm_creation
          - FAILURE: on_failure
    - get_vm_status:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${vapp_details}'
            - json_path: "${'$.children.vm[?(@.name==\"'+final_vm_name+'\")].status'}"
        publish:
          - vm_status: "${return_result.replace('[','').replace(']','')}"
        navigate:
          - SUCCESS: is_vm_status_is_0
          - FAILURE: on_failure
    - is_vm_ip_list_is_null:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${vm_ip_address}'
            - second_string: 'null'
        publish: []
        navigate:
          - SUCCESS: set_vm_ip_list_to_empty
          - FAILURE: sleep_1_1
    - set_vm_ip_list_to_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - vm_ip_address: ''
        publish:
          - vm_ip_address
        navigate:
          - SUCCESS: sleep_1_1
          - FAILURE: on_failure
    - is_vm_status_is_0:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${vm_status}'
            - second_string: '0'
        publish: []
        navigate:
          - SUCCESS: wait_for_vm_creation
          - FAILURE: is_vm_status_is_8
    - compare_ip:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${vm_ip_address}'
        navigate:
          - SUCCESS: counter_1
          - FAILURE: get_vm_mac_address
    - counter_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.counter:
            - from: '1'
            - to: '${polling_retries}'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: sleep_1
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - sleep_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '30'
        navigate:
          - SUCCESS: get_vapp_details_1
          - FAILURE: on_failure
    - get_vapp_details_1:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.vmware.cloud_director.vapp.get_vapp_details:
            - host_name: '${host_name}'
            - port: '${port}'
            - protocol: '${protocol}'
            - access_token: '${access_token}'
            - vapp_id: '${vapp_id}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - worker_group: '${worker_group}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - vapp_details: '${return_result}'
        navigate:
          - SUCCESS: get_vm_ip
          - FAILURE: on_failure
    - compare_ip_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${vm_ip_address}'
            - second_string: 'null'
        navigate:
          - SUCCESS: counter_1
          - FAILURE: compare_ip
    - get_vapp_details_2:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.vmware.cloud_director.vapp.get_vapp_details:
            - host_name: '${host_name}'
            - port: '${port}'
            - protocol: '${protocol}'
            - access_token: '${access_token}'
            - vapp_id: '${vapp_id}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - worker_group: '${worker_group}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - vapp_details: '${return_result}'
        navigate:
          - SUCCESS: get_vm_status_1
          - FAILURE: on_failure
    - get_vm_status_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${vapp_details}'
            - json_path: "${'$.children.vm[?(@.name==\"'+final_vm_name+'\")].status'}"
        publish:
          - vm_status: "${return_result.replace('[','').replace(']','')}"
        navigate:
          - SUCCESS: is_vm_status_is_stopped
          - FAILURE: on_failure
    - is_vm_status_is_stopped:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${vm_status}'
            - second_string: '8'
        publish: []
        navigate:
          - SUCCESS: set_vm_status_to_powered_off_1
          - FAILURE: is_vm_status_is_started
    - is_vm_status_is_started:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${vm_status}'
            - second_string: '4'
        publish: []
        navigate:
          - SUCCESS: set_vm_status_to_powered_on_1
          - FAILURE: on_failure
    - set_vm_status_to_powered_off_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - vm_status: Powered Off
        publish:
          - vm_status
        navigate:
          - SUCCESS: json_path_query_to_extract_cpu
          - FAILURE: on_failure
    - set_vm_status_to_powered_on_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - vm_status: Powered On
        publish:
          - vm_status
        navigate:
          - SUCCESS: json_path_query_to_extract_cpu
          - FAILURE: on_failure
    - sleep_1_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '30'
        navigate:
          - SUCCESS: get_vapp_details_2
          - FAILURE: on_failure
    - json_path_query_to_extract_cpu:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${vapp_details}'
            - json_path: 'children.vm[0].section[0].numCpus'
        publish:
          - number_of_cpu: '${return_result}'
        navigate:
          - SUCCESS: json_path_query_to_extract_memory
          - FAILURE: on_failure
    - json_path_query_to_extract_memory:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${vapp_details}'
            - json_path: 'children.vm[0].section[0].memoryResourceMb.configured'
        publish:
          - memory: "${str(int(return_result)/ 1024) + ' GB'}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - final_vm_name
    - vm_id
    - vm_status
    - vm_ip_address
    - vm_mac_address
    - number_of_cpu
    - memory
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      is_vm_ip_list_is_null:
        x: 1200
        'y': 80
      json_path_query_to_extract_cpu:
        x: 1560
        'y': 480
      compare_ip:
        x: 1040
        'y': 440
      get_vm_status_1:
        x: 1600
        'y': 80
      get_vm_id_list:
        x: 760
        'y': 640
      set_vm_status_to_powered_off_1:
        x: 1560
        'y': 240
      get_vm_mac_address:
        x: 1040
        'y': 80
      get_vapp_id:
        x: 600
        'y': 280
      is_vm_status_is_started:
        x: 1320
        'y': 480
      get_vm_ip:
        x: 760
        'y': 440
      wait_for_vm_creation:
        x: 440
        'y': 280
      get_vapp_details_1:
        x: 760
        'y': 280
      sleep_1:
        x: 760
        'y': 80
      get_vm_names:
        x: 120
        'y': 280
      json_path_query_to_extract_memory:
        x: 1680
        'y': 480
        navigate:
          6f170d8e-34cc-f35a-a3ff-0c9c23b0acc9:
            targetId: 39b3c3fe-524e-b2fb-d62e-f1abcd08f3ba
            port: SUCCESS
      get_vapp_details_2:
        x: 1440
        'y': 80
      set_vm_status_to_powered_on_1:
        x: 1440
        'y': 480
      counter_1:
        x: 920
        'y': 80
        navigate:
          57038ab3-0f9e-988f-51f2-ced27fe839b5:
            targetId: 30894e63-4da9-52d4-6134-9e48080cee3f
            port: NO_MORE
      get_vm_status:
        x: 120
        'y': 440
      is_vm_status_is_stopped:
        x: 1320
        'y': 240
      compare_ip_1:
        x: 920
        'y': 440
      get_host_details:
        x: 120
        'y': 80
      is_vm_status_is_0:
        x: 280
        'y': 440
      get_vapp_details:
        x: 280
        'y': 280
      is_vm_status_is_4:
        x: 440
        'y': 640
      random_number_generator:
        x: 440
        'y': 80
      is_vm_status_is_20:
        x: 120
        'y': 640
        navigate:
          fbe9732e-e0a8-6dd4-82f4-38621cf8a6e3:
            vertices:
              - x: 80
                'y': 640
              - x: 80
                'y': 240
              - x: 480
                'y': 240
            targetId: wait_for_vm_creation
            port: SUCCESS
      create_vm:
        x: 600
        'y': 80
      sleep_1_1:
        x: 1309.888916015625
        'y': 75.03819274902344
      get_access_token_using_web_api:
        x: 280
        'y': 80
      is_vm_status_is_8:
        x: 440
        'y': 440
      set_vm_ip_list_to_empty:
        x: 1200
        'y': 280
    results:
      SUCCESS:
        39b3c3fe-524e-b2fb-d62e-f1abcd08f3ba:
          x: 1680
          'y': 240
      FAILURE:
        30894e63-4da9-52d4-6134-9e48080cee3f:
          x: 920
          'y': 320

