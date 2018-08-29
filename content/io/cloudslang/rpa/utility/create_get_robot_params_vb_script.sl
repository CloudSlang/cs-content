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
#! @description: This flow creates a VB script needed to run an RPA Robot (UFT Scenario) based on a deafult triggering template.
#!
#! @input host: The host where UFT and robots (UFT scenarios) are located.
#! @input port: The WinRM port of the provided host. Default: https: 5986 http: 5985
#! @input protocol: The WinRM protocol.
#! @input username: The username for the WinRM connection.
#! @input password: The password for the WinRM connection.
#! @input proxy_host: The proxy host.
#!                    Optional
#! @input proxy_port: The proxy port.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input robot_path: The path to the robot(UFT scenario).
#! @input rpa_workspace_path: The path where the OO will create needed scripts for robot execution.
#! @input script: The run robot (UFT scenario) VB script template.
#! @input fileNumber: Used for development purposes.
#!!#
########################################################################################################################
namespace: io.cloudslang.rpa.utility
flow:
  name: create_get_robot_params_vb_script
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
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - robot_path
    - rpa_workspace_path
    - script: "${get_sp('get_robot_params_script_template')}"
    - fileNumber:
        default: '0'
        private: true
  workflow:
    - add_robot_path:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${script}'
            - text_to_replace: '<test_path>'
            - replace_with: '${robot_path}'
        publish:
          - script: '${replaced_string}'
        navigate:
          - SUCCESS: create_folder_structure
          - FAILURE: on_failure
    - create_vb_script:
        do:
          io.cloudslang.base.powershell.powershell_script:
            - host: '${host}'
            - port: '${port}'
            - protocol: '${protocol}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - script: "${'Set-Content -Path \"' + rpa_workspace_path.rstrip(\"\\\\\") + \"\\\\\" + robot_path.split(\"\\\\\")[-1] +  '_get_params_' + fileNumber + '.vbs \" -Value \"'+ script +'\" -Encoding ASCII'}"
        publish:
          - exception
          - stderr
          - script_exit_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - create_folder_structure:
        do:
          io.cloudslang.base.powershell.powershell_script:
            - host: '${host}'
            - port: '${port}'
            - protocol: '${protocol}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - script: "${'New-item \"' + rpa_workspace_path.rstrip(\"\\\\\") + \"\\\\\" + '\" -ItemType Directory -force'}"
        publish:
          - exception
          - return_code
          - stderr
          - script_exit_code
        navigate:
          - SUCCESS: check_if_filename_exists
          - FAILURE: on_failure
    - check_if_filename_exists:
        do:
          io.cloudslang.base.powershell.powershell_script:
            - host: '${host}'
            - port: '${port}'
            - protocol: '${protocol}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - script: "${'Test-Path \"' + rpa_workspace_path.rstrip(\"\\\\\") + \"\\\\\" + robot_path.split(\"\\\\\")[-1] +  '_get_params_' + fileNumber + '.vbs\"'}"
        publish:
          - exception
          - return_code
          - stderr
          - script_exit_code
          - fileExists: '${return_result}'
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${fileExists}'
            - second_string: 'True'
        navigate:
          - SUCCESS: add_numbers
          - FAILURE: create_vb_script
    - add_numbers:
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: '${fileNumber}'
            - value2: '1'
        publish:
          - fileNumber: '${result}'
        navigate:
          - SUCCESS: check_if_filename_exists
          - FAILURE: on_failure
  outputs:
    - script_name: "${rpa_workspace_path.rstrip(\"\\\\\") + \"\\\\\" + robot_path.split(\"\\\\\")[-1] +  '_get_params_' + fileNumber + '.vbs'}"
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      add_robot_path:
        x: 101
        y: 156
      create_vb_script:
        x: 1008
        y: 318
        navigate:
          bcccb51e-fc73-679f-ef31-658b05e4a04a:
            targetId: 9fdf022d-4c3e-1f47-ea07-3c46a43ea9e8
            port: SUCCESS
      create_folder_structure:
        x: 400
        y: 150
      check_if_filename_exists:
        x: 402
        y: 348
      string_equals:
        x: 729
        y: 141
      add_numbers:
        x: 697
        y: 342
    results:
      SUCCESS:
        9fdf022d-4c3e-1f47-ea07-3c46a43ea9e8:
          x: 1000
          y: 150
