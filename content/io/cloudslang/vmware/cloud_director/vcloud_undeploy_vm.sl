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
#! @description: This workflow is used used to undeploy VM.
#!
#! @input provider_sap: Provider SAP.
#! @input vm_id: The organization we are attempting to access.
#! @input api_token: The Refresh token for the Vcloud.
#! @input tenant_name: The name of the Tenant.
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
#!
#! @result SUCCESS: The VM has been successfully undeployed.
#! @result FAILURE: Error in undeploying VM
#!!#
########################################################################################################################

namespace: io.cloudslang.vmware.cloud_director
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: vcloud_undeploy_vm
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
    - check_status_code_of_vapp:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '403'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - check_status_code:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status_code}'
            - second_string: '403'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: counter
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
    - sleep:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '${polling_interval}'
        navigate:
          - SUCCESS: get_vm_details_to_check_vm_status
          - FAILURE: on_failure
    - delete_vm:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.vmware.cloud_director.vm.delete_vm:
            - host_name: '${hostname}'
            - port: '${port}'
            - protocol: '${protocol}'
            - vm_id: '${vm_id}'
            - access_token: '${access_token}'
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
          - status_code
        navigate:
          - SUCCESS: get_vm_details_to_check_vm_status
          - FAILURE: on_failure
    - string_equals:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status}'
            - second_string: '4'
        navigate:
          - SUCCESS: stop_vapp
          - FAILURE: delete_vm
    - stop_vapp:
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
          - status_code
        navigate:
          - SUCCESS: get_vm_details_to_check_status
          - FAILURE: on_failure
    - sleep_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '30'
        navigate:
          - SUCCESS: get_vm_details_to_check_status
          - FAILURE: on_failure
    - string_equals_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status}'
            - second_string: '8'
        navigate:
          - SUCCESS: delete_vm
          - FAILURE: sleep_1
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
          - status_code
          - status
        navigate:
          - SUCCESS: string_equals
          - FAILURE: check_status_code_of_vapp
    - get_vm_details_to_check_status:
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
          - status_code
          - status
        navigate:
          - SUCCESS: string_equals_1
          - FAILURE: on_failure
    - get_vm_details_to_check_vm_status:
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
          - status_code
          - status
          - return_result
        navigate:
          - SUCCESS: check_status_code
          - FAILURE: check_status_code
  outputs:
    - return_result
    - status_code
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_vm_details:
        x: 40
        'y': 520
      check_status_code:
        x: 1000
        'y': 80
        navigate:
          862539b4-158a-ab27-81d8-417e1c0d0734:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      stop_vapp:
        x: 280
        'y': 400
      sleep_1:
        x: 440
        'y': 160
      delete_vm:
        x: 160
        'y': 80
      string_equals:
        x: 160
        'y': 400
      get_vm_details_to_check_status:
        x: 440
        'y': 400
      get_host_details:
        x: 40
        'y': 80
      check_status_code_of_vapp:
        x: 320
        'y': 520
        navigate:
          6be7905f-2018-cdc2-ca3f-76f9d417e097:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      sleep:
        x: 600
        'y': 320
      get_vm_details_to_check_vm_status:
        x: 600
        'y': 80
      get_access_token_using_web_api:
        x: 40
        'y': 280
      counter:
        x: 760
        'y': 320
        navigate:
          df9c67a0-134a-09b3-415e-fa847e7e7d20:
            targetId: b7eaa48f-d8cc-5668-f6d1-e97c77cee70b
            port: NO_MORE
      string_equals_1:
        x: 280
        'y': 160
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 1000
          'y': 520
      FAILURE:
        b7eaa48f-d8cc-5668-f6d1-e97c77cee70b:
          x: 920
          'y': 320

