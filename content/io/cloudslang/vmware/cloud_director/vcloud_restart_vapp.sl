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
#! @description: This workflow is used to restart the vApp.
#!
#! @input provider_sap: Provider SAP.
#! @input vapp_id: The unique id of the vApp.
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
#!
#! @result FAILURE: Error in restarting vApp.
#! @result SUCCESS: The vApp has been restarted successfully.
#!!#
########################################################################################################################

namespace: io.cloudslang.vmware.cloud_director
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: vcloud_restart_vapp
  inputs:
    - provider_sap
    - vapp_id:
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
          - SUCCESS: get_vapp_details
          - FAILURE: on_failure
    - get_vapp_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.vmware.cloud_director.vapp.get_vapp_details:
            - host_name: '${hostname}'
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
          - return_result
          - status
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - string_equals:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${status}'
            - second_string: '8'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: vcloud_stop_vapp
    - vcloud_stop_vapp:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.vmware.cloud_director.vcloud_stop_vapp:
            - provider_sap: '${provider_sap}'
            - vapp_id: '${vapp_id}'
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
          - SUCCESS: sleep_1_1
          - FAILURE: on_failure
    - vcloud_start_vapp:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.vmware.cloud_director.vcloud_start_vapp:
            - provider_sap: '${provider_sap}'
            - vapp_id: '${vapp_id}'
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
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - sleep_1_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '30'
        navigate:
          - SUCCESS: vcloud_start_vapp
          - FAILURE: on_failure
  outputs:
    - return_result
    - status_code
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      vcloud_start_vapp:
        x: 840
        'y': 440
        navigate:
          61c12a39-95d6-8e7b-657e-ed5f167a22a9:
            targetId: 7387e017-3bf2-146a-7f4f-beec16d156c4
            port: SUCCESS
      vcloud_stop_vapp:
        x: 360
        'y': 200
      string_equals:
        x: 360
        'y': 440
        navigate:
          a442b465-320a-752c-1f84-072013af2c57:
            targetId: 7387e017-3bf2-146a-7f4f-beec16d156c4
            port: SUCCESS
      get_host_details:
        x: 80
        'y': 80
      get_vapp_details:
        x: 80
        'y': 440
      sleep_1_1:
        x: 840
        'y': 200
      get_access_token_using_web_api:
        x: 80
        'y': 240
    results:
      SUCCESS:
        7387e017-3bf2-146a-7f4f-beec16d156c4:
          x: 560
          'y': 440

