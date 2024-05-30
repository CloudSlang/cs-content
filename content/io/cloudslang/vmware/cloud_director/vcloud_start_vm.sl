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
#! @description: This workflow is used to start the VM.
#!
#! @input provider_sap: Provider SAP.
#! @input vm_id: The unique Id of the VM.
#! @input api_token: The Refresh token for the Vcloud.
#! @input tenant_name: The organization we are attempting to access.
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input polling_interval: The number of seconds to wait until performing another check.Default: '20'Optional
#! @input polling_retries: The number of retries to check if the instance is started.Default: '30'Optional
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
#! @result SUCCESS: The VM has been started successfully.
#! @result FAILURE: Error in starting the VM.
#!!#
########################################################################################################################

namespace: io.cloudslang.vmware.cloud_director
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: vcloud_start_vm
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
    - polling_interval: '20'
    - polling_retries: '30'
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
    - comparing_power_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status}'
            - second_string: '4'
        navigate:
          - SUCCESS: get_vm_ip_address
          - FAILURE: start_vm
    - check_power_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${vm_details}'
            - json_path: status
        publish:
          - power_state: '${return_result}'
        navigate:
          - SUCCESS: compare_power_state
          - FAILURE: on_failure
    - compare_power_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${power_state}'
            - second_string: '4'
        navigate:
          - SUCCESS: get_vm_ip_address
          - FAILURE: counter
    - sleep:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '30'
        navigate:
          - SUCCESS: get_vm_details_1
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
          - vm_details: '${return_result}'
          - status
        navigate:
          - SUCCESS: comparing_power_state
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
          - vm_details: '${return_result}'
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
    - counter:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.counter:
            - from: '1'
            - to: '${polling_retries}'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: sleep
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - get_vm_ip_address:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${vm_details}'
            - json_path: 'section,3,networkConnection,0,ipAddress'
        publish:
          - ip_address: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
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
        x: 400
        'y': 240
      get_vm_details:
        x: 240
        'y': 440
      get_host_details:
        x: 80
        'y': 240
      start_vm:
        x: 240
        'y': 80
      get_vm_details_1:
        x: 400
        'y': 80
      sleep:
        x: 560
        'y': 80
      comparing_power_state:
        x: 240
        'y': 240
      get_vm_ip_address:
        x: 400
        'y': 440
        navigate:
          97ae80c3-c28e-0c3b-5cf5-b774c6cbb6d3:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      get_access_token_using_web_api:
        x: 80
        'y': 440
      counter:
        x: 720
        'y': 80
        navigate:
          9dd6a431-d977-2685-a09d-99e7c9baa827:
            targetId: 0fe466ae-a536-00e8-9244-527f1b42c14d
            port: NO_MORE
      compare_power_state:
        x: 720
        'y': 240
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 720
          'y': 440
      FAILURE:
        0fe466ae-a536-00e8-9244-527f1b42c14d:
          x: 920
          'y': 80

