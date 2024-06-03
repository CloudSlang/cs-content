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
#! @description: This workflow is used to restart the VM.
#!
#! @input provider_sap: Provider SAP.
#! @input vm_id: The unique Id of the VM.
#! @input api_token: The Refresh token for the Vcloud.
#! @input tenant_name: The organization we are attempting to access.
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input proxy_host: Proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: Proxy server port.
#!                    Optional
#! @input proxy_username: Username used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
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
#!
#! @output return_result: This will contain the response entity.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output ip_address: The IP Address of the VM.
#! @output power_state: The current power state of the VM.
#!
#! @result SUCCESS: The VM has been restarted successfully.
#! @result FAILURE: Error in restarting the VM.
#!!#
########################################################################################################################

namespace: io.cloudslang.vmware.cloud_director
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: vcloud_restart_vm
  inputs:
    - provider_sap
    - vm_id:
        required: true
        sensitive: false
    - api_token:
        sensitive: true
    - tenant_name
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
          - hostname
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
            - host_name: '${hostname}'
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
          - SUCCESS: get_vm_details
          - FAILURE: on_failure
    - string_equals:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status}'
            - second_string: '4'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: start_vm
    - check_power_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: status
        publish:
          - power_state: '${return_result}'
        navigate:
          - SUCCESS: sleep_1
          - FAILURE: compare_power_state
    - compare_power_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${power_state}'
            - second_string: '1'
        navigate:
          - SUCCESS: vcloud_stop_vm
          - FAILURE: sleep
    - sleep:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '30'
        navigate:
          - SUCCESS: check_power_state
          - FAILURE: on_failure
    - get_vm_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.vmware.cloud_director.vm.get_vm_details:
            - host_name: '${hostname}'
            - port: '${port}'
            - protocol: '${protocol}'
            - access_token: '${access_token}'
            - vm_id: '${vm_id}'
            - vapp_id: '${vm_id}'
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
          - return_result
          - status
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - get_vm_details_1:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.vmware.cloud_director.vm.get_vm_details:
            - host_name: '${hostname}'
            - port: '${port}'
            - protocol: '${protocol}'
            - access_token: '${access_token}'
            - vm_id: '${vm_id}'
            - vapp_id: '${vm_id}'
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
          - return_result
          - status
        navigate:
          - SUCCESS: check_power_state
          - FAILURE: on_failure
    - start_vm:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.vmware.cloud_director.vm.start_vm:
            - host_name: '${hostname}'
            - port: '${port}'
            - protocol: '${protocol}'
            - base_URL: '${base_URL}'
            - vm_id: '${vm_id}'
            - access_token:
                value: '${access_token}'
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
          - return_result
        navigate:
          - SUCCESS: get_vm_details_1
          - FAILURE: on_failure
    - vcloud_stop_vm:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.vmware.cloud_director.vcloud_stop_vm:
            - provider_sap: '${provider_sap}'
            - vm_id: '${vm_id}'
            - api_token:
                value: '${api_token}'
                sensitive: true
            - tenant_name: '${tenant_name}'
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
          - status_code
        navigate:
          - SUCCESS: vcloud_start_vm
          - FAILURE: on_failure
    - vcloud_start_vm:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.vmware.cloud_director.vcloud_start_vm:
            - provider_sap: '${provider_sap}'
            - vm_id: '${vm_id}'
            - api_token:
                value: '${api_token}'
                sensitive: true
            - tenant_name: '${tenant_name}'
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
          - status_code
          - ip_address
          - power_state
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - sleep_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '30'
        navigate:
          - SUCCESS: vcloud_stop_vm
          - FAILURE: on_failure
  outputs:
    - return_result
    - status_code
    - ip_address
    - power_state
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      check_power_state:
        x: 680
        'y': 160
      get_vm_details:
        x: 40
        'y': 520
      sleep_1:
        x: 520
        'y': 320
      string_equals:
        x: 320
        'y': 520
        navigate:
          52d52bb7-69bc-bea6-985a-2932ee155f64:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      vcloud_start_vm:
        x: 680
        'y': 720
        navigate:
          d311a3a3-9a19-9836-6097-a648e1a25681:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      get_host_details:
        x: 40
        'y': 160
      vcloud_stop_vm:
        x: 680
        'y': 400
      start_vm:
        x: 320
        'y': 160
      get_vm_details_1:
        x: 520
        'y': 160
      sleep:
        x: 880
        'y': 160
      get_access_token_using_web_api:
        x: 40
        'y': 320
      compare_power_state:
        x: 880
        'y': 400
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 320
          'y': 720

