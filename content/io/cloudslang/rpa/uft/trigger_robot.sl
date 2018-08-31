#   (c) Copyright 2018 Micro Focus
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
#! @description: This flow triggers an RPA Robot (UFT Scenario). 
#!               The UFT Scenario needs to exist before this flow is ran.
#!
#! @input host: The host where UFT and robots (UFT scenarios) are located.
#! @input port: The WinRM port of the provided host.
#!                    Default: https: '5986' http: '5985'
#! @input protocol: The WinRM protocol.
#! @input username: The username for the WinRM connection.
#! @input password: The password for the WinRM connection.
#! @input auth_type:Type of authentication used to execute the request on the target server
#!                  Valid: 'basic', digest', 'ntlm', 'kerberos', 'anonymous' (no authentication).
#!                    Default: 'basic'
#!                    Optional
#! @input proxy_host: The proxy host.
#!                    Optional
#! @input proxy_port: The proxy port.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL.
#!                         A certificate is trusted even if no trusted certification authority issued it.
#!                         Valid: 'true' or 'false'
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. The hostname
#!                                 verification system prevents communication with other hosts other than the ones you
#!                                 intended. This is done by checking that the hostname is in the subject alternative
#!                                 name extension of the certificate. This system is designed to ensure that, if an
#!                                 attacker(Man In The Middle) redirects traffic to his machine, the client will not
#!                                 accept the connection. If you set this input to "allow_all", this verification is
#!                                 ignored and you become vulnerable to security attacks. For the value
#!                                 "browser_compatible" the hostname verifier works the same way as Curl and Firefox.
#!                                 The hostname must match either the first CN, or any of the subject-alts. A wildcard
#!                                 can occur in the CN, and in any of the subject-alts. The only difference between
#!                                 "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with
#!                                 "browser_compatible" matches all subdomains, including "a.b.foo.com".
#!                                 From the security perspective, to provide protection against possible
#!                                 Man-In-The-Middle attacks, we strongly recommend to use "strict" option.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'.
#!                                 Default: 'strict'.
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Default value: 'JAVA_HOME/java/lib/security/cacerts'
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Default value: 'changeit'
#!                        Optional
#! @input is_robot_visible: Parameter to set if the Robot actions should be visible in the UI or not.
#! @input robot_path: The path to the robot(UFT scenario).
#! @input robot_results_path: The path where the robot(UFT scenario) will save its results.
#! @input robot_parameters: Robot parameters from the UFT scenario. A list of name:value pairs separated by comma.
#!                          Eg. name1:value1,name2:value2
#! @input rpa_workspace_path: The path where the OO will create needed scripts for robot execution.
#! @input operation_timeout: Defines the operation_timeout value in seconds to indicate that the clients expect a
#!                           response or a fault within the specified time.
#!                           Default: '60'
#!
#! @result SUCCESS: The operation executed successfully.
#! @result FAILURE: The operation could not be executed.
#!!#
########################################################################################################################
namespace: io.cloudslang.rpa.uft

imports:
  utility: create_trigger_robot_vb_script.utility

flow:
  name: trigger_robot
  inputs:
    - host
    - port:
        required: false
    - protocol:
        required: false
    - username:
        required: false
    - password:
        required: false
    -  auth_type:
        default: 'basic'
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: 'strict'
        required: false
    - trust_keystore:
        default: ''
        required: false
    - trust_password:
        default: 'changeit'
        required: false
        sensitive: true
    - operation_timeout:
        default: '60'
        required: false
    - is_robot_visible
    - robot_path
    - robot_results_path
    - robot_parameters
    - rpa_workspace_path
  workflow:
    - create_trigger_robot_vb_script:
        do:
          utility.create_trigger_robot_vb_script:
            - host: '${host}'
            - port: '${port}'
            - protocol: '${protocol}'
            - username: '${username}'
            - password: '${password}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - is_robot_visible: '${is_robot_visible}'
            - robot_path: '${robot_path}'
            - robot_results_path: '${robot_results_path}'
            - robot_parameters: '${robot_parameters}'
            - rpa_workspace_path: '${rpa_workspace_path}'
        publish:
          - script_name
        navigate:
          - FAILURE: on_failure
          - SUCCESS: trigger_vb_script
    - trigger_vb_script:
        do:
          io.cloudslang.base.powershell.powershell_script:
            - host: '${host}'
            - port: '${port}'
            - protocol: '${protocol}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - auth_type: '${auth_type}'
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
            - operation_timeout: '${operation_timeout}'
            - script: "${'invoke-expression \"cmd /C cscript ' + script_name + '\"'}"
        publish:
          - exception
          - return_code
          - stderr
          - script_exit_code
        navigate:
          - SUCCESS: delete_vb_script
          - FAILURE: delete_vb_script_1
    - delete_vb_script:
        do:
          io.cloudslang.base.powershell.powershell_script:
            - host: '${host}'
            - port: '${port}'
            - protocol: '${protocol}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - auth_type: '${auth_type}'
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
            - operation_timeout: '${operation_timeout}'
            - script: "${'Remove-Item \"' + script_name +'\"'}"
        publish:
          - exception
          - return_code
          - stderr
          - script_exit_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: SUCCESS
    - delete_vb_script_1:
        do:
          io.cloudslang.base.powershell.powershell_script:
            - host: '${host}'
            - port: '${port}'
            - protocol: '${protocol}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - auth_type: '${auth_type}'
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
            - operation_timeout: '${operation_timeout}'
            - script: "${'Remove-Item \"' + script_name + '\"'}"
        publish:
          - exception
          - return_code
          - stderr
          - script_exit_code
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_trigger_robot_vb_script:
        x: 51
        y: 78
      trigger_vb_script:
        x: 344
        y: 76
      delete_vb_script:
        x: 585
        y: 80
        navigate:
          dcf12e0f-57e6-2c88-a65e-a1f3651e7ee4:
            targetId: 023c90fc-05ed-adf3-eb3c-da02c1f4333a
            port: SUCCESS
          82467eb7-5ac6-1523-0211-d9ec99424bdb:
            targetId: 023c90fc-05ed-adf3-eb3c-da02c1f4333a
            port: FAILURE
      delete_vb_script_1:
        x: 585
        y: 242
        navigate:
          6585b707-8ed3-ad4a-4c92-06a5c32e5b7a:
            targetId: 9075912d-0472-2f13-bd04-f716ea7744ed
            port: SUCCESS
    results:
      FAILURE:
        9075912d-0472-2f13-bd04-f716ea7744ed:
          x: 823
          y: 231
      SUCCESS:
        023c90fc-05ed-adf3-eb3c-da02c1f4333a:
          x: 824
          y: 83
