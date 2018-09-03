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
#! @description: This flow returns the existing robots in a provided path.
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
#! @input robots_path: The path where the robots(UFT scenarios) are located.
#! @input iterator: Used for development purposes.
#! @input operation_timeout: Defines the operation_timeout value in seconds to indicate that the clients expect a
#!                           response or a fault within the specified time.
#!                           Default: '60'
#!
#! @output robots: UFT robots list from the specified path.
#!
#! @result SUCCESS: The operation executed successfully.
#! @result FAILURE: The operation could not be executed.
#!!#
########################################################################################################################

namespace: io.cloudslang.rpa.uft

flow:
  name: get_robots
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
        sensitive: true
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
    - robots_path
    - iterator:
        default: '0'
        private: true

  workflow:
    - get_folders:
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
            - script: "${'(Get-ChildItem -Path \"'+ robots_path +'\" -Directory).Name -join \",\"'}"
        publish:
          - exception
          - return_code
          - stderr
          - script_exit_code
          - folders: "${return_result.replace('\\n',',')}"
        navigate:
          - SUCCESS: length
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${test_file_exists}'
            - second_string: 'True'
        navigate:
          - SUCCESS: append
          - FAILURE: add_numbers
    - test_file_exists:
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
            - script: "${'Test-Path \"' + robots_path.rstrip(\\\\) + \"\\\\\" + folder_to_check + '\\\\Test.tsp\"'}"
        publish:
          - exception
          - return_code
          - stderr
          - script_exit_code
          - test_file_exists: "${return_result.replace('\\n',',')}"
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - length:
        do:
          io.cloudslang.base.lists.length:
            - list: '${folders}'
        publish:
          - list_length: '${return_result}'
        navigate:
          - SUCCESS: is_done
          - FAILURE: on_failure
    - is_done:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${iterator}'
            - second_string: '${list_length}'
        navigate:
          - SUCCESS: default_if_empty
          - FAILURE: get_by_index
    - add_numbers:
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: '${iterator}'
            - value2: '1'
        publish:
          - iterator: '${result}'
        navigate:
          - SUCCESS: is_done
          - FAILURE: on_failure
    - append:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: "${get('robots_list', '')}"
            - text: "${folder_to_check + ','}"
        publish:
          - robots_list: '${new_string}'
        navigate:
          - SUCCESS: add_numbers
    - get_by_index:
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${folders}'
            - delimiter: ','
            - index: '${iterator}'
        publish:
          - folder_to_check: '${return_result}'
        navigate:
          - SUCCESS: test_file_exists
          - FAILURE: on_failure
    - default_if_empty:
        do:
          io.cloudslang.base.utils.default_if_empty:
            - initial_value: "${get('robots_list', '')}"
            - default_value: No robots founded in the provided path.
        publish:
          - robots_list: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure

  outputs:
    - robots: '${robots_list.rstrip(",")}'

  results:
    - SUCCESS
    - FAILURE

extensions:
  graph:
    steps:
      length:
        x: 250
        y: 77
      default_if_empty:
        x: 637
        y: 80
        navigate:
          0579a2e1-65b5-64bc-6afb-87ae9d3dcfbb:
            targetId: 023c90fc-05ed-adf3-eb3c-da02c1f4333a
            port: SUCCESS
      add_numbers:
        x: 251
        y: 256
      string_equals:
        x: 289
        y: 416
      test_file_exists:
        x: 428
        y: 422
      get_by_index:
        x: 424
        y: 250
      is_done:
        x: 462
        y: 62
      append:
        x: 80
        y: 429
      get_folders:
        x: 53
        y: 80
    results:
      SUCCESS:
        023c90fc-05ed-adf3-eb3c-da02c1f4333a:
          x: 849
          y: 83
