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
#! @description: This workflow is used to stop the vm.
#!
#! @input host_name: The host name of the VMWare vCloud director.
#! @input port: The port of the host. Default: 443
#! @input protocol: The protocol for rest API call. Default: https
#! @input vm_id: The unique Id of the VM.
#! @input api_token: The Refresh token for the Vcloud.
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
#!
#! @result SUCCESS: The VM has been stopped successfully.
#! @result FAILURE: Error in stoping the Vm.
#!!#
########################################################################################################################

namespace: io.cloudslang.vmware.cloud_director
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: vcloud_stop_vm
  inputs:
    - host_name:
        required: true
    - port: '443'
    - protocol: https
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
    - get_access_token_using_web_api:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.vmware.cloud_director.authorization.get_access_token_using_web_api:
            - host_name: '${host_name}'
            - protocol: '${protocol}'
            - port: '${port}'
            - base_URL: '${base_URL}'
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
            - second_string: '8'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: stop_vm
    - check_power_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: status
        publish:
          - power_state: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: compare_power_state
    - compare_power_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${power_state}'
            - second_string: '1'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: sleep
    - sleep:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '30'
        navigate:
          - SUCCESS: check_power_state
          - FAILURE: on_failure
    - stop_vm:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.vmware.cloud_director.vm.stop_vm:
            - host_name: '${host_name}'
            - port: '${port}'
            - protocol: '${protocol}'
            - base_URL: '${base_URL}'
            - vm_id: '${vm_id}'
            - vapp_id: '${vapp_id}'
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
        navigate:
          - SUCCESS: get_vm_details_1
          - FAILURE: on_failure
    - get_vm_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.vmware.cloud_director.vm.get_vm_details:
            - host_name: '${host_name}'
            - port: '${port}'
            - protocol: '${protocol}'
            - base_URL: '${base_URL}'
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
            - host_name: '${host_name}'
            - port: '${port}'
            - protocol: '${protocol}'
            - base_URL: '${base_URL}'
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
  outputs:
    - return_result
    - status_code
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_access_token_using_web_api:
        x: 120
        'y': 160
      string_equals:
        x: 320
        'y': 400
        navigate:
          52d52bb7-69bc-bea6-985a-2932ee155f64:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      check_power_state:
        x: 680
        'y': 160
        navigate:
          09c575ad-eda1-8bc0-a9ab-3d7a9fecbd0f:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      compare_power_state:
        x: 880
        'y': 400
        navigate:
          d6318fc3-6bac-efbd-94d7-0022c4c76ff9:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      sleep:
        x: 880
        'y': 160
      stop_vm:
        x: 320
        'y': 160
      get_vm_details:
        x: 120
        'y': 400
      get_vm_details_1:
        x: 520
        'y': 160
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 680
          'y': 400

