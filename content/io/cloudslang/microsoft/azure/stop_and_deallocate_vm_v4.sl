#   (c) Copyright 2022 Micro Focus, L.P.
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
#! @description: This workflow stops the virtual machine and deallocates the public IP address from the virtual machine.
#!
#! @input vm_name: The name of the virtual machine which needs to stop.Virtual machine name cannot contain non-ASCII or special characters.
#! @input subscription_id: The ID of the Azure Subscription on which the VM should be stopped.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to stop the VM.
#! @input tenant_id: The tenantId value used to control who can sign into the application.
#! @input client_id: The Application ID assigned to your app when you registered it with Azure AD.
#! @input client_secret: The application secret that you created in the app registration portal for your app. It cannot
#!                       be used in a native app (public client), because client_secrets cannot be reliably stored on
#!                       devices. It is required for web apps and web APIs (all confidential clients), which have the
#!                       ability to store the client_secret securely on the server side.
#! @input enable_public_ip: The value of property will be true if the VM has public IP Address.
#! @input schedule_time: Schedule time of the stop and deallocating the VM.
#!                       Optional
#! @input schedule_time_zone: Schedule time zone of the stop and deallocate VM.Optional
#! @input stop_and_deallocate_vm_scheduler_id: Stop and deallocate VM scheduler ID.Optional
#! @input cancel_scheduler: The value of property will be yes if the scheduler has to cancel, otherwise no.
#!                          Optional
#! @input stop_and_deallocate_vm_scheduler_time: Stop and deallocate VM scheduler time.Optional
#! @input component_id: The service component ID.
#! @input connect_timeout: Time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#!                         Optional
#! @input polling_interval: Time to wait between checks.
#!                          Default: '30'
#!                          Optional
#! @input proxy_host: Proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: Proxy server port.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input proxy_username: Username used when connecting to the proxy.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#!
#! @output scheduler_id: Stop and deallocate VM scheduler ID.
#! @output public_ip_address: The primary IP Address of the VM.
#! @output power_state: Power state of the Virtual Machine.
#! @output updated_stop_and_deallocate_vm_scheduler_time: Stop and deallocate VM scheduler time.
#!
#! @result FAILURE: There was an error while trying to run every step of the flow.
#! @result SUCCESS: The flow completed successfully.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings
  flow: io.cloudslang.base.utils
  auth: io.cloudslang.microsoft.azure.authorization
  vm: io.cloudslang.microsoft.azure.compute.virtual_machines

flow:
  name: stop_and_deallocate_vm_v4
  inputs:
    - vm_name
    - subscription_id
    - resource_group_name
    - tenant_id:
        required: true
        sensitive: false
    - client_id:
        required: true
        sensitive: false
    - client_secret:
        required: true
        sensitive: true
    - enable_public_ip
    - schedule_time:
        required: false
    - schedule_time_zone:
        required: false
    - stop_and_deallocate_vm_scheduler_id:
        required: false
    - cancel_scheduler:
        required: false
    - stop_and_deallocate_vm_scheduler_time:
        required: false
    - component_id:
        required: false
    - connect_timeout:
        default: '0'
        required: false
    - polling_interval:
        default: '30'
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - proxy_username:
        required: false
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
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - get_auth_token_using_web_api:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.microsoft.azure.authorization.get_auth_token_using_web_api:
            - tenant_id: '${tenant_id}'
            - client_id: '${client_id}'
            - client_secret:
                value: '${client_secret}'
                sensitive: true
            - resource: 'https://management.azure.com/'
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
          - auth_token:
              value: '${auth_token}'
              sensitive: true
          - return_code
          - error_message: '${exception}'
        navigate:
          - SUCCESS: get_tenant_id
          - FAILURE: on_failure
    - get_power_state:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.compute.virtual_machines.get_power_state:
            - vm_name
            - subscription_id
            - resource_group_name
            - auth_token
            - connect_timeout
            - socket_timeout: '0'
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - power_state: '${power_state}'
          - power_status: '${output}'
          - status_code
          - error_message
        navigate:
          - SUCCESS: check_power_state
          - FAILURE: on_failure
    - check_schedule_time_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${schedule_time}'
            - second_string: ''
        navigate:
          - SUCCESS: check_cancel_scheduler_empty
          - FAILURE: check_schedule_time_zone_empty
    - check_stop_and_deallocate_vm_scheduler_id_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${stop_and_deallocate_vm_scheduler_id}'
            - second_string: ''
        navigate:
          - SUCCESS: scheduler_time
          - FAILURE: FAILURE
    - scheduler_time:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.microsoft.azure.utils.schedule_time:
            - scheduler_time: '${schedule_time}'
            - scheduler_time_zone: '${schedule_time_zone}'
        publish:
          - scheduler_start_time
          - trigger_expression
          - time_zone
          - exception
        navigate:
          - SUCCESS: get_optional_properties_json
          - FAILURE: on_failure
    - api_call_to_create_scheduler:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get_sp('io.cloudslang.microfocus.content.oo_rest_uri')+'/scheduler/rest/v1/'+dnd_tenant_id+'/schedules'}"
            - username: '${dnd_rest_user}'
            - password:
                value: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_password')}"
                sensitive: true
            - proxy_host: "${get_sp('io.cloudslang.microfocus.content.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.microfocus.content.proxy_port')}"
            - proxy_username: "${get_sp('io.cloudslang.microfocus.content.proxy_username')}"
            - proxy_password:
                value: "${get_sp('io.cloudslang.microfocus.content.proxy_password')}"
                sensitive: true
            - trust_all_roots: "${get_sp('io.cloudslang.microfocus.content.trust_all_roots')}"
            - x_509_hostname_verifier: "${get_sp('io.cloudslang.microfocus.content.x_509_hostname_verifier')}"
            - trust_keystore: "${get_sp('io.cloudslang.microfocus.content.trust_keystore')}"
            - trust_password:
                value: "${get_sp('io.cloudslang.microfocus.content.trust_password')}"
                sensitive: true
            - connect_timeout: "${get_sp('io.cloudslang.microfocus.content.connect_timeout')}"
            - socket_timeout: "${get_sp('io.cloudslang.microfocus.content.socket_timeout')}"
            - body: "${'{ \"flowIdentifier\": \"io.cloudslang.microsoft.azure.utils.schedule_stop_and_deallocate_vm\",\"scheduleName\": \"Schedule Azure Stop and deallocate VM\",\"triggerExpression\":\"' + trigger_expression + '\",\"timezone\":\"' + time_zone + '\",\"startDate\":\"' + scheduler_start_time + '\",\"enabled\": true,\"misfireInstruction\": 0,\"useEmptyValueForPrompts\": true,\"exclusions\": {\"dateTimeExclusionList\": null,\"dateExclusionList\": null,\"timeExclusionList\": null},\"runLogLevel\": \"STANDARD\", \"inputs\": [{\"name\": \"vm_name\", \"value\": \"' + vm_name + '\", \"sensitive\": false}, { \"name\": \"subscription_id\", \"value\": \"' + subscription_id + '\", \"sensitive\": false},{ \"name\": \"resource_group_name\", \"value\": \"' + resource_group_name +'\", \"sensitive\": false},{ \"name\": \"tenant_id\", \"value\": \"' + tenant_id + '\", \"sensitive\": false},{ \"name\": \"client_id\", \"value\": \"' + client_id + '\", \"sensitive\": false},{\"name\": \"client_secret\",\"value\": \"' + client_secret + '\", \"sensitive\": true},{\"name\": \"enable_public_ip\", \"value\": \"' + enable_public_ip + '\", \"sensitive\": false},{ \"name\": \"connect_timeout\", \"value\": \"' + connect_timeout + '\", \"sensitive\": false},{\"name\": \"polling_interval\", \"value\": \"' + polling_interval + '\", \"sensitive\": false},{\"name\": \"proxy_host\",\"value\": \"' + proxy_host + '\",\"sensitive\": false},{\"name\": \"proxy_port\", \"value\": \"' + proxy_port + '\",\"sensitive\": false},{\"name\": \"trust_all_roots\",\"value\": \"' + trust_all_roots + '\",\"sensitive\": false},{\"name\":\"x_509_hostname_verifier\",\"value\": \"' +x_509_hostname_verifier + '\",\"sensitive\": false},{\"name\": \"worker_group\",\"value\": \"' + worker_group + '\",\"sensitive\": false}],\"licenseType\": 0}'}"
            - content_type: application/json
            - worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        publish:
          - response_headers
          - status_code
          - error_message
        navigate:
          - SUCCESS: get_scheduler_id
          - FAILURE: on_failure
    - get_scheduler_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - input1: '${response_headers.split("Location: /schedules/")[1]}'
            - scheduler_start_time: '${scheduler_start_time}'
            - time_zone: '${time_zone}'
        publish:
          - scheduler_id: '${input1.split("X-Content-Type-Options:")[0]}'
          - updated_stop_and_deallocate_vm_scheduler_time: "${scheduler_start_time + ' ' + time_zone}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - check_cancel_scheduler_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${cancel_scheduler}'
            - second_string: 'yes'
        navigate:
          - SUCCESS: check_stop_and_deallocate_vm_scheduler_id
          - FAILURE: stop_and_deallocate_vm_v3
    - api_call_to_delete_scheduler:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_delete:
            - url: "${get_sp('io.cloudslang.microfocus.content.oo_rest_uri')+'/scheduler/rest/v1/'+dnd_tenant_id+'/schedules/'+stop_and_deallocate_vm_scheduler_id.strip(\" \")}"
            - username: '${dnd_rest_user}'
            - password:
                value: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_password')}"
                sensitive: true
            - proxy_host: "${get_sp('io.cloudslang.microfocus.content.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.microfocus.content.proxy_port')}"
            - proxy_username: "${get_sp('io.cloudslang.microfocus.content.proxy_username')}"
            - proxy_password:
                value: "${get_sp('io.cloudslang.microfocus.content.proxy_password')}"
                sensitive: true
            - trust_all_roots: "${get_sp('io.cloudslang.microfocus.content.trust_all_roots')}"
            - x_509_hostname_verifier: "${get_sp('io.cloudslang.microfocus.content.x_509_hostname_verifier')}"
            - trust_keystore: "${get_sp('io.cloudslang.microfocus.content.trust_keystore')}"
            - trust_password:
                value: "${get_sp('io.cloudslang.microfocus.content.trust_password')}"
                sensitive: true
            - socket_timeout: "${get_sp('io.cloudslang.microfocus.content.socket_timeout')}"
            - worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - check_stop_and_deallocate_vm_scheduler_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${stop_and_deallocate_vm_scheduler_id}'
            - second_string: ''
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: api_call_to_delete_scheduler
    - check_schedule_time_zone:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${schedule_time_zone}'
            - second_string: ''
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: check_stop_and_deallocate_vm_scheduler_id_empty
    - check_schedule_time_zone_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${schedule_time_zone}'
            - second_string: Not Applicable
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: check_schedule_time_zone
    - check_enable_public_ip:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${enable_public_ip}'
            - second_string: 'true'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: set_public_ip_address
          - FAILURE: check_schedule_time_empty
    - check_power_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${power_status}'
            - json_path: 'statuses,1,code'
        publish:
          - expected_power_state: '${return_result}'
        navigate:
          - SUCCESS: compare_power_state
          - FAILURE: on_failure
    - compare_power_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${expected_power_state}'
            - second_string: PowerState/deallocated
        navigate:
          - SUCCESS: check_enable_public_ip
          - FAILURE: check_schedule_time_empty
    - get_optional_properties_json:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.utils.set_optional_properties_json:
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - component_id: '${component_id}'
        publish:
          - optional_properties_json
        navigate:
          - FAILURE: on_failure
          - SUCCESS: check_optional_property_json_empty
    - check_optional_property_json_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${optional_properties_json}'
            - second_string: ''
        navigate:
          - SUCCESS: api_call_to_create_scheduler
          - FAILURE: api_call_to_create_scheduler_with_optional_values
    - api_call_to_create_scheduler_with_optional_values:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${get_sp('io.cloudslang.microfocus.content.oo_rest_uri')+'/scheduler/rest/v1/'+dnd_tenant_id+'/schedules'}"
            - username: '${dnd_rest_user}'
            - password:
                value: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_password')}"
                sensitive: true
            - proxy_host: "${get_sp('io.cloudslang.microfocus.content.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.microfocus.content.proxy_port')}"
            - proxy_username: "${get_sp('io.cloudslang.microfocus.content.proxy_username')}"
            - proxy_password:
                value: "${get_sp('io.cloudslang.microfocus.content.proxy_password')}"
                sensitive: true
            - trust_all_roots: "${get_sp('io.cloudslang.microfocus.content.trust_all_roots')}"
            - x_509_hostname_verifier: "${get_sp('io.cloudslang.microfocus.content.x_509_hostname_verifier')}"
            - trust_keystore: "${get_sp('io.cloudslang.microfocus.content.trust_keystore')}"
            - trust_password:
                value: "${get_sp('io.cloudslang.microfocus.content.trust_password')}"
                sensitive: true
            - connect_timeout: "${get_sp('io.cloudslang.microfocus.content.connect_timeout')}"
            - socket_timeout: "${get_sp('io.cloudslang.microfocus.content.socket_timeout')}"
            - body: "${'{ \"flowIdentifier\": \"io.cloudslang.microsoft.azure.utils.schedule_stop_and_deallocate_vm\",\"scheduleName\": \"Schedule Azure Stop and deallocate VM\",\"triggerExpression\":\"' + trigger_expression + '\",\"timezone\":\"' + time_zone + '\",\"startDate\":\"' + scheduler_start_time + '\",\"enabled\": true,\"misfireInstruction\": 0,\"useEmptyValueForPrompts\": true,\"exclusions\": {\"dateTimeExclusionList\": null,\"dateExclusionList\": null,\"timeExclusionList\": null},\"runLogLevel\": \"STANDARD\", \"inputs\": [{\"name\": \"vm_name\", \"value\": \"' + vm_name + '\", \"sensitive\": false}, { \"name\": \"subscription_id\", \"value\": \"' + subscription_id + '\", \"sensitive\": false},{ \"name\": \"resource_group_name\", \"value\": \"' + resource_group_name +'\", \"sensitive\": false},{ \"name\": \"tenant_id\", \"value\": \"' + tenant_id + '\", \"sensitive\": false},{ \"name\": \"client_id\", \"value\": \"' + client_id + '\", \"sensitive\": false},{\"name\": \"client_secret\",\"value\": \"' + client_secret + '\", \"sensitive\": true},{\"name\": \"enable_public_ip\", \"value\": \"' + enable_public_ip + '\", \"sensitive\": false},{ \"name\": \"connect_timeout\", \"value\": \"' + connect_timeout + '\", \"sensitive\": false},{\"name\": \"polling_interval\", \"value\": \"' + polling_interval + '\", \"sensitive\": false}, ' + optional_properties_json +' {\"name\": \"trust_all_roots\",\"value\": \"' + trust_all_roots + '\",\"sensitive\": false},{\"name\":\"x_509_hostname_verifier\",\"value\": \"' + x_509_hostname_verifier + '\",\"sensitive\": false},{\"name\": \"worker_group\",\"value\": \"' + worker_group + '\",\"sensitive\": false}],\"licenseType\": 0}'}"
            - content_type: application/json
            - worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        publish:
          - response_headers
          - status_code
          - error_message
        navigate:
          - SUCCESS: get_scheduler_id
          - FAILURE: on_failure
    - set_public_ip_address:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - vm_name: '${vm_name}'
        publish:
          - public_ip_address: '${vm_name}'
        navigate:
          - SUCCESS: check_schedule_time_empty
          - FAILURE: on_failure
    - stop_and_deallocate_vm_v3:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.microsoft.azure.stop_and_deallocate_vm_v3:
            - vm_name: '${vm_name}'
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - tenant_id: '${tenant_id}'
            - client_id: '${client_id}'
            - client_secret:
                value: '${client_secret}'
                sensitive: true
            - enable_public_ip: '${enable_public_ip}'
            - connect_timeout: '${connect_timeout}'
            - polling_interval: '${polling_interval}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - power_state
          - public_ip_address
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_tenant_id:
        worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        do:
          io.cloudslang.base.utils.do_nothing:
            - dnd_rest_user: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_user')}"
            - scheduler_id: '${stop_and_deallocate_vm_scheduler_id}'
            - updated_stop_and_deallocate_vm_scheduler_time: '${stop_and_deallocate_vm_scheduler_time}'
        publish:
          - dnd_rest_user
          - dnd_tenant_id: '${dnd_rest_user.split("/")[0]}'
          - scheduler_id
          - updated_stop_and_deallocate_vm_scheduler_time
        navigate:
          - SUCCESS: get_power_state
          - FAILURE: on_failure
  outputs:
    - scheduler_id
    - public_ip_address
    - power_state
    - updated_stop_and_deallocate_vm_scheduler_time
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      check_power_state:
        x: 40
        'y': 320
      api_call_to_create_scheduler:
        x: 1160
        'y': 720
      get_auth_token_using_web_api:
        x: 40
        'y': 120
      check_stop_and_deallocate_vm_scheduler_id_empty:
        x: 1000
        'y': 120
        navigate:
          b0e3a4b5-a772-78f7-dcc7-cd41ca4a55f4:
            targetId: 982c534f-a49d-7b50-8804-eefbdb22843c
            port: FAILURE
      api_call_to_create_scheduler_with_optional_values:
        x: 1000
        'y': 520
      get_tenant_id:
        x: 200
        'y': 120
      get_scheduler_id:
        x: 1000
        'y': 720
        navigate:
          5eed7b79-c5a1-2f9b-58bf-286142b3ffbd:
            targetId: 49f71b73-1825-42e1-f00c-2b1e4388e4f9
            port: SUCCESS
      stop_and_deallocate_vm_v3:
        x: 640
        'y': 520
        navigate:
          26ffdf57-c3af-f0d4-ef8c-1255b9cd0c32:
            targetId: 49f71b73-1825-42e1-f00c-2b1e4388e4f9
            port: SUCCESS
      check_schedule_time_empty:
        x: 520
        'y': 120
      check_schedule_time_zone:
        x: 840
        'y': 120
        navigate:
          e2330162-e802-e4ca-d47d-4daf4d24a34c:
            targetId: 982c534f-a49d-7b50-8804-eefbdb22843c
            port: SUCCESS
      get_power_state:
        x: 360
        'y': 120
      api_call_to_delete_scheduler:
        x: 840
        'y': 520
        navigate:
          c30da958-a26c-5338-3400-ce2a68314d0e:
            targetId: 49f71b73-1825-42e1-f00c-2b1e4388e4f9
            port: SUCCESS
      scheduler_time:
        x: 1160
        'y': 120
      check_stop_and_deallocate_vm_scheduler_id:
        x: 680
        'y': 320
        navigate:
          9503230f-e28b-ad48-5e48-e372253abcd8:
            targetId: 982c534f-a49d-7b50-8804-eefbdb22843c
            port: SUCCESS
      set_public_ip_address:
        x: 360
        'y': 520
      check_optional_property_json_empty:
        x: 1160
        'y': 520
      check_enable_public_ip:
        x: 360
        'y': 320
      check_schedule_time_zone_empty:
        x: 680
        'y': 120
        navigate:
          e798600c-def0-c244-6b71-f9f5faafdd04:
            targetId: 982c534f-a49d-7b50-8804-eefbdb22843c
            port: SUCCESS
      check_cancel_scheduler_empty:
        x: 520
        'y': 320
      compare_power_state:
        x: 200
        'y': 320
      get_optional_properties_json:
        x: 1160
        'y': 320
    results:
      FAILURE:
        982c534f-a49d-7b50-8804-eefbdb22843c:
          x: 840
          'y': 320
      SUCCESS:
        49f71b73-1825-42e1-f00c-2b1e4388e4f9:
          x: 840
          'y': 720