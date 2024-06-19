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
#! @description: This flow deploys the vApp in the given VMWare vCloud Director provider.
#!
#! @input provider_sap: The provider service access point for the vCloud director.
#! @input api_token: The refresh token for the vCloud director.
#! @input tenant_name: The name of the tenant or organization.
#! @input vdc_id: The id of the virtual data center.
#! @input vapp_template_id: The template id of vApp.
#! @input vapp_name: The name of the vApp.
#! @input storage_profile: The name of the storage profile to be associated with vApp.
#! @input compute_parameters: The input values of VM template name, CPU, memory and Hard disk for each VMs present in the vApp template in JSON format.
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
#! @output final_vapp_name: The name of the vApp deployed.
#! @output vapp_id: The Id of vApp.
#! @output vapp_status: The status of created vApp.
#! @output vm_name_list: The list of VM name.
#! @output vm_ip_list: The list of IP address of VMs.
#! @output vm_id_list: The list of ID of VMs.
#! @output vm_mac_address_list: The list of MAC address of VMs.
#!
#! @result SUCCESS: vApp deployed successfully.
#! @result FAILURE: Failed to deploy the vApp.
#!!#
########################################################################################################################
namespace: io.cloudslang.vmware.cloud_director.vapp
flow:
  name: vcloud_deploy_vapp
  inputs:
    - provider_sap:
        sensitive: false
    - api_token:
        sensitive: true
    - tenant_name:
        sensitive: false
    - vdc_id
    - vapp_template_id:
        sensitive: false
    - vapp_name
    - storage_profile:
        required: false
    - compute_parameters:
        required: false
    - polling_interval:
        default: '20'
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
          - SUCCESS: create_vapp
          - FAILURE: on_failure
    - get_vapp_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: href
        publish:
          - vapp_id: "${return_result.split('vApp/')[1]}"
        navigate:
          - SUCCESS: get_vapp_details
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
          - vm_name_list: "${return_result.replace('\"','').strip('[').strip(']')}"
        navigate:
          - SUCCESS: get_vapp_status
          - FAILURE: on_failure
    - get_vapp_status:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${vapp_details}'
            - json_path: status
        publish:
          - vapp_status: '${return_result}'
        navigate:
          - SUCCESS: is_vm_status_is_0
          - FAILURE: on_failure
    - wait_for_vapp_creation:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '30'
        navigate:
          - SUCCESS: get_vapp_id
          - FAILURE: on_failure
    - is_vapp_status_is_8:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${vapp_status}'
            - second_string: '8'
        publish: []
        navigate:
          - SUCCESS: set_vapp_status_to_powered_off
          - FAILURE: is_vapp_status_is_4
    - set_vapp_status_to_powered_off:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - vapp_status: Powered Off
        publish:
          - vapp_status
        navigate:
          - SUCCESS: get_vm_id_list
          - FAILURE: on_failure
    - set_vapp_status_to_powered_on:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - vapp_status: Powered On
        publish:
          - vapp_status
        navigate:
          - SUCCESS: get_vm_id_list
          - FAILURE: on_failure
    - is_vapp_status_is_4:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${vapp_status}'
            - second_string: '4'
        publish: []
        navigate:
          - SUCCESS: set_vapp_status_to_powered_on
          - FAILURE: is_vapp_status_is_10
    - is_vapp_status_is_10:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${vapp_status}'
            - second_string: '10'
        publish: []
        navigate:
          - SUCCESS: wait_for_vapp_creation
          - FAILURE: on_failure
    - get_vm_id_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${vapp_details}'
            - json_path: '$.children.vm[*].id'
            - vm_ip_list: ''
            - vm_mac_address_list: ''
        publish:
          - vm_id_list: "${return_result.replace('urn:vcloud:vm:','vm-').replace('\"','').strip('[').strip(']').replace(' ','')}"
          - vm_ip_list
          - vm_mac_address_list
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - list_iterator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${vm_name_list}'
            - vm_ip_list: '${vm_ip_list}'
            - vm_mac_address_list: '${vm_mac_address_list}'
        publish:
          - vm: '${result_string}'
          - vm_ip_list
          - vm_mac_address_list
        navigate:
          - HAS_MORE: get_vm_ip
          - NO_MORE: is_vm_ip_list_is_null
          - FAILURE: on_failure
    - get_vm_ip:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${vapp_details}'
            - json_path: "${'$.children.vm[?(@.name==\"'+vm+'\")].section[?(@._type==\"NetworkConnectionSectionType\")].networkConnection[0].ipAddress'}"
        publish:
          - vm_ip: "${return_result.strip('[\"').strip('\"]')}"
        navigate:
          - SUCCESS: get_vm_mac_address
          - FAILURE: on_failure
    - set_vm_ip_and_mac_address:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - vm_ip: '${vm_ip}'
            - vm_ip_list: '${vm_ip_list}'
            - vm_mac_address: '${vm_mac_address}'
            - vm_mac_address_list: '${vm_mac_address_list}'
        publish:
          - vm_ip_list: "${vm_ip_list+','+vm_ip}"
          - vm_mac_address_list: "${vm_mac_address_list+','+vm_mac_address}"
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - is_vm_ip_list_is_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${vm_ip_list}'
            - second_string: ''
        publish: []
        navigate:
          - SUCCESS: set_first_vm_ip_and_mac_address
          - FAILURE: set_vm_ip_and_mac_address
    - set_first_vm_ip_and_mac_address:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - vm_ip: '${vm_ip}'
            - vm_mac_address: '${vm_mac_address}'
        publish:
          - vm_ip_list: '${vm_ip}'
          - vm_mac_address_list: '${vm_mac_address}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - is_vm_ip_list_is_null:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${vm_ip_list}'
            - second_string: 'null'
        publish: []
        navigate:
          - SUCCESS: set_vm_ip_list_to_empty
          - FAILURE: SUCCESS
    - set_vm_ip_list_to_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - vm_ip_list: ''
        publish:
          - vm_ip_list
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_vm_mac_address:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${vapp_details}'
            - json_path: "${'$.children.vm[?(@.name==\"'+vm+'\")].section[?(@._type==\"NetworkConnectionSectionType\")].networkConnection[0].macAddress'}"
        publish:
          - vm_mac_address: "${return_result.strip('[\"').strip('\"]')}"
        navigate:
          - SUCCESS: is_vm_ip_list_is_empty
          - FAILURE: on_failure
    - create_vapp:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.vmware.cloud_director.vapp.create_vapp:
            - protocol: '${protocol}'
            - host_name: '${host_name}'
            - port: '${port}'
            - access_token:
                value: '${access_token}'
                sensitive: true
            - tenant_name: '${tenant_name}'
            - vdc_id: '${vdc_id}'
            - vapp_template_id: "${'vappTemplate-'+vapp_template_id}"
            - storage_profile: '${storage_profile}'
            - compute_parameters: '${compute_parameters}'
            - vapp_name: '${vapp_name+random_number}'
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
          - return_result
          - final_vapp_name: '${vapp_name}'
        navigate:
          - SUCCESS: wait_for_vapp_creation
          - FAILURE: on_failure
    - is_vm_status_is_0:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${vapp_status}'
            - second_string: '0'
        publish: []
        navigate:
          - SUCCESS: wait_for_vapp_creation
          - FAILURE: is_vapp_status_is_8
  outputs:
    - final_vapp_name
    - vapp_id
    - vapp_status
    - vm_name_list
    - vm_ip_list
    - vm_id_list
    - vm_mac_address_list
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      is_vm_ip_list_is_null:
        x: 840
        'y': 80
        navigate:
          57ff09d3-474e-fa53-54b1-1a4308b48f52:
            targetId: 39b3c3fe-524e-b2fb-d62e-f1abcd08f3ba
            port: FAILURE
      set_first_vm_ip_and_mac_address:
        x: 840
        'y': 640
      get_vm_id_list:
        x: 680
        'y': 440
      get_vm_mac_address:
        x: 1160
        'y': 440
      get_vapp_id:
        x: 40
        'y': 480
      is_vapp_status_is_10:
        x: 80
        'y': 600
        navigate:
          36b8409c-456e-624b-40d0-82126b79e225:
            vertices:
              - x: 40
                'y': 640
              - x: 0
                'y': 400
            targetId: wait_for_vapp_creation
            port: SUCCESS
      get_vm_ip:
        x: 1000
        'y': 440
      set_vapp_status_to_powered_off:
        x: 520
        'y': 440
      set_vapp_status_to_powered_on:
        x: 520
        'y': 640
      get_vm_names:
        x: 200
        'y': 320
      is_vapp_status_is_4:
        x: 360
        'y': 600
      create_vapp:
        x: 520
        'y': 80
        navigate:
          6ca32ebd-0e9e-349a-e77d-e9b40ebb273b:
            vertices:
              - x: 560
                'y': 240
              - x: 80
                'y': 240
            targetId: wait_for_vapp_creation
            port: SUCCESS
      set_vm_ip_and_mac_address:
        x: 1000
        'y': 640
      list_iterator:
        x: 840
        'y': 440
      is_vapp_status_is_8:
        x: 360
        'y': 440
      wait_for_vapp_creation:
        x: 40
        'y': 280
      get_host_details:
        x: 40
        'y': 80
      is_vm_ip_list_is_empty:
        x: 1160
        'y': 640
        navigate:
          cb2b9bbd-a455-306b-91d4-fc0345eb8bdb:
            vertices:
              - x: 1040
                'y': 800
            targetId: set_first_vm_ip_and_mac_address
            port: SUCCESS
      is_vm_status_is_0:
        x: 680
        'y': 200
      get_vapp_details:
        x: 200
        'y': 480
      random_number_generator:
        x: 360
        'y': 80
      get_access_token_using_web_api:
        x: 200
        'y': 80
      set_vm_ip_list_to_empty:
        x: 1000
        'y': 280
        navigate:
          3a33f5cc-ce8f-7658-8836-08d07fbeb70a:
            targetId: 39b3c3fe-524e-b2fb-d62e-f1abcd08f3ba
            port: SUCCESS
      get_vapp_status:
        x: 360
        'y': 280
    results:
      SUCCESS:
        39b3c3fe-524e-b2fb-d62e-f1abcd08f3ba:
          x: 1080
          'y': 80

