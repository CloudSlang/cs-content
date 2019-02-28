#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: Restart virtual machine flow.
#!
#! @input subscription_id: The ID of the Azure Subscription on which the VM should be restarted.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to restart the VM.
#! @input login_authority: Optional - URL of the login authority that should be used when
#!                                    retrieving the Authentication Token.
#!                         Default: 'https://sts.windows.net/common'
#! @input username: The username to be used to authenticate to the Azure Management Service.
#! @input password: The password to be used to authenticate to the Azure Management Service.
#! @input location: Specifies the supported Azure location where the virtual machine should be restarted.
#!                  This can be different from the location of the resource group.
#! @input vm_name: The name of the virtual machine to be restarted.
#!                 Virtual machine name cannot contain non-ASCII or special characters.
#! @input polling_interval: Time to wait between checks
#! @input connect_timeout: Optional - time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#! @input socket_timeout: Optional - time in seconds to wait for data to be retrieved
#!                        Default: '0' (infinite)
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - Username used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input trust_keystore: Optional - the pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - the password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input x_509_hostname_verifier: Optional - specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#!                                 Default: 'strict'
#!
#! @output output: Information about the virtual machine that has been restarted
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output return_code: 0 if success, -1 if failure
#! @output error_message: If there is any error while running the flow, it will be populated, empty otherwise
#!
#! @result SUCCESS: The flow completed successfully.
#! @result FAILURE: There was an error while trying to run every step of the flow.
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
  name: restart_vm

  inputs:
    - username
    - password:
        sensitive: true
    - login_authority:
        default: 'https://sts.windows.net/common'
        required: false
    - vm_name
    - subscription_id
    - resource_group_name
    - connect_timeout:
        default: "0"
        required: false
    - polling_interval:
        required: false
        default: '30'
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - trust_all_roots:
        required: false
        default: 'false'
    - x_509_hostname_verifier:
        required: false
        default: 'strict'
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true

  workflow:
    - get_auth_token:
        do:
          auth.get_auth_token:
            - username
            - password
            - login_authority
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - auth_token
          - return_code
          - error_message: ${exception}
        navigate:
          - SUCCESS: restart_vm
          - FAILURE: on_failure

    - restart_vm:
        do:
          vm.restart_vm:
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
          - output
          - status_code
          - error_message
        navigate:
          - SUCCESS: get_power_state
          - FAILURE: on_failure

    - get_power_state:
         do:
           vm.get_power_state:
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
           - power_state: ${output}
           - status_code
           - error_message
         navigate:
           - SUCCESS: check_power_state
           - FAILURE: on_failure

    - check_power_state:
        do:
          json.get_value:
            - json_input: ${power_state}
            - json_path: 'statuses,1,code'
        publish:
          - expected_power_state: ${return_result}
        navigate:
          - SUCCESS: compare_power_state
          - FAILURE: on_failure

    - compare_power_state:
        do:
          strings.string_equals:
            - first_string: ${expected_power_state}
            - second_string: 'PowerState/running'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: sleep

    - sleep:
        do:
          flow.sleep:
            - seconds: ${polling_interval}
        navigate:
          - SUCCESS: get_power_state
          - FAILURE: on_failure

  outputs:
    - output
    - status_code
    - return_code
    - error_message

  results:
    - SUCCESS
    - FAILURE
