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
#! @input schedule_time_zone: Schedule time zone of the stop and deallocate VM.Optional
#! @input stop_and_deallocate_vm_scheduler_id: Stop and deallocate VM scheduler ID.Optional
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
#! @output public_ip_address: The primary IP Address of the VM.
#! @output power_state: Power state of the Virtual Machine.
#! @output updated_scheduler_id: Stop and deallocate VM scheduler ID.
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
  name: stop_vm_and_deallocate_public_ip
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
    - scheduler_time_zone:
        required: false
    - stop_and_deallocate_vm_scheduler_id:
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
          - FAILURE: check_stop_and_deallocate_vm_scheduler_id_empty_1
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
          - error_message
        navigate:
          - SUCCESS: check_stop_and_deallocate_vm_scheduler_id_empty
          - FAILURE: check_stop_and_deallocate_vm_scheduler_id_empty_1
    - get_tenant_id:
        worker_group: "${get_sp('io.cloudslang.microfocus.content.worker_group')}"
        do:
          io.cloudslang.base.utils.do_nothing:
            - dnd_rest_user: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_user')}"
            - scheduler_id: '${stop_and_deallocate_vm_scheduler_id}'
        publish:
          - dnd_rest_user
          - dnd_tenant_id: '${dnd_rest_user.split("/")[0]}'
          - updated_scheduler_id: '${scheduler_id}'
        navigate:
          - SUCCESS: stop_and_deallocate_vm_v3
          - FAILURE: check_stop_and_deallocate_vm_scheduler_id_empty_1
    - check_stop_and_deallocate_vm_scheduler_id_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${stop_and_deallocate_vm_scheduler_id}'
            - second_string: ''
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: get_scheduler_details
    - get_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: nextFireTime
        publish:
          - next_run_in_unix_time: '${return_result}'
        navigate:
          - SUCCESS: time_format
          - FAILURE: on_failure
    - time_format:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.microsoft.azure.utils.time_format:
            - time: '${next_run_in_unix_time}'
            - timezone: '${scheduler_time_zone}'
            - format: '%Y-%m-%dT%H:%M:%S'
        publish:
          - updated_stop_and_deallocate_vm_scheduler_time: '${result_date + ".000" + timezone.split("UTC")[1].split(")")[0] + timezone.split(")")[1]}'
        navigate:
          - SUCCESS: SUCCESS
    - get_scheduler_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get_sp('io.cloudslang.microfocus.content.oo_rest_uri')+'/scheduler/rest/v1/'+dnd_tenant_id+'/schedules/'+stop_and_deallocate_vm_scheduler_id.strip()}"
            - username: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_user')}"
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
        publish:
          - return_result
          - error_message
        navigate:
          - SUCCESS: get_value
          - FAILURE: on_failure
    - check_stop_and_deallocate_vm_scheduler_id_empty_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${stop_and_deallocate_vm_scheduler_id}'
            - second_string: ''
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: get_scheduler_details_1
    - get_value_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: nextFireTime
        publish:
          - next_run_in_unix_time: '${return_result}'
        navigate:
          - SUCCESS: time_format_1
          - FAILURE: on_failure
    - time_format_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.microsoft.azure.utils.time_format:
            - time: '${next_run_in_unix_time}'
            - timezone: '${scheduler_time_zone}'
            - format: '%Y-%m-%dT%H:%M:%S'
        publish:
          - updated_stop_and_deallocate_vm_scheduler_time: '${result_date + ".000" + timezone.split("UTC")[1].split(")")[0] + timezone.split(")")[1]}'
        navigate:
          - SUCCESS: FAILURE
    - get_scheduler_details_1:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get_sp('io.cloudslang.microfocus.content.oo_rest_uri')+'/scheduler/rest/v1/'+dnd_tenant_id+'/schedules/'+stop_and_deallocate_vm_scheduler_id.strip()}"
            - username: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_user')}"
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
        publish:
          - return_result
          - error_message
        navigate:
          - SUCCESS: get_value_1
          - FAILURE: on_failure
  outputs:
    - public_ip_address
    - power_state
    - updated_scheduler_id
    - updated_stop_and_deallocate_vm_scheduler_time
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_auth_token_using_web_api:
        x: 40
        'y': 80
      check_stop_and_deallocate_vm_scheduler_id_empty:
        x: 360
        'y': 280
        navigate:
          734741f0-5e88-3f88-0d91-0f3444d5c30d:
            targetId: 49f71b73-1825-42e1-f00c-2b1e4388e4f9
            port: SUCCESS
      get_scheduler_details_1:
        x: 40
        'y': 480
      get_tenant_id:
        x: 200
        'y': 80
      get_value:
        x: 680
        'y': 80
      time_format:
        x: 840
        'y': 80
        navigate:
          4bd5ecf5-2f0e-014f-b077-8321576fb7ed:
            targetId: 49f71b73-1825-42e1-f00c-2b1e4388e4f9
            port: SUCCESS
      stop_and_deallocate_vm_v3:
        x: 360
        'y': 80
      check_stop_and_deallocate_vm_scheduler_id_empty_1:
        x: 45.002540588378906
        'y': 299.1111145019531
        navigate:
          56acfde7-2c80-7b4e-7004-db89cd33cecc:
            targetId: 148c5d72-2a50-7b67-8096-2d705b954816
            port: SUCCESS
      get_scheduler_details:
        x: 520
        'y': 80
      get_value_1:
        x: 200
        'y': 480
      time_format_1:
        x: 360
        'y': 480
        navigate:
          10c1bc4e-c3b8-a49c-dcce-c76f221f7eda:
            targetId: 148c5d72-2a50-7b67-8096-2d705b954816
            port: SUCCESS
    results:
      SUCCESS:
        49f71b73-1825-42e1-f00c-2b1e4388e4f9:
          x: 840
          'y': 280
      FAILURE:
        148c5d72-2a50-7b67-8096-2d705b954816:
          x: 600
          'y': 480
