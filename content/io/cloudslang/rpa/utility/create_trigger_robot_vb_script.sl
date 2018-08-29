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
#! @description: This flow creates a VB script needed to run an RPA Robot (UFT Scenario) based on a default triggering template.
#!
#! @input host: The host where UFT and robots (UFT scenarios) are located.
#! @input port: The WinRM port of the provided host.
#!              Default for https: '5986'
#!              Default for http: '5985'
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
#! @input is_robot_visible: Parameter to set if the Robot actions should be visible in the UI or not.
#! @input robot_path: The path to the robot(UFT scenario).
#! @input robot_results_path: The path where the robot(UFT scenario) will save its results.
#! @input robot_parameters: Robot parameters from the UFT scenario. A list of name:value pairs separated by comma. Eg. name1:value1,name2:value2
#! @input rpa_workspace_path: The path where the OO will create needed scripts for robot execution.
#! @input script: The run robot (UFT scenario) VB script template.
#! @input fileNumber: Used for development purposes
#!
#! @output script_name: Full path VB script
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The operation executed successfully
#! @result FAILURE: The operation could not be executed
#!!#
########################################################################################################################
namespace: io.cloudslang.rpa.utility
flow:
  name: create_trigger_robot_vb_script
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
    - is_robot_visible: 'True'
    - robot_path
    - robot_results_path
    - robot_parameters
    - rpa_workspace_path
    - script: "${get_sp('run_robot_script_template')}"
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
          - SUCCESS: add_robot_results_path
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
            - script: "${'Set-Content -Path \"' + rpa_workspace_path.rstrip(\"\\\\\") + \"\\\\\" + robot_path.split(\"\\\\\")[-1] + '_' + fileNumber + '.vbs\" -Value \"'+ script +'\" -Encoding ASCII'}"
        publish:
          - exception
          - return_code
          - stderr
          - script_exit_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - add_robot_results_path:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${script}'
            - text_to_replace: '<test_results_path>'
            - replace_with: '${robot_results_path}'
        publish:
          - script: '${replaced_string}'
        navigate:
          - SUCCESS: is_robot_visible
          - FAILURE: on_failure
    - add_parameter:
        loop:
          for: parameter in robot_parameters
          do:
            io.cloudslang.base.strings.append:
              - origin_string: "${get('text', '')}"
              - text: "${'qtParams.Item(`\"' + parameter.split(\":\")[0] + '`\").Value = `\"' + parameter.split(\":\")[1] +'`\"`r`n'}"
          break: []
          publish:
            - text: '${new_string}'
        navigate:
          - SUCCESS: add_parameters
    - add_parameters:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${script}'
            - text_to_replace: '<params>'
            - replace_with: '${text}'
        publish:
          - script: '${replaced_string}'
        navigate:
          - SUCCESS: create_folder_structure
          - FAILURE: on_failure
    - is_robot_visible:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${script}'
            - text_to_replace: '<visible_param>'
            - replace_with: '${is_robot_visible}'
        publish:
          - script: '${replaced_string}'
        navigate:
          - SUCCESS: add_parameter
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
          - scriptName: output_0
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
            - script: "${'Test-Path \"' + rpa_workspace_path.rstrip(\"\\\\\") + \"\\\\\" + robot_path.split(\"\\\\\")[-1] + '_' + fileNumber +  '.vbs\"'}"
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
    - script_name: "${rpa_workspace_path.rstrip(\"\\\\\") + \"\\\\\" + robot_path.split(\"\\\\\")[-1] + '_' + fileNumber + '.vbs'}"
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      add_robot_results_path:
        x: 92
        y: 357
      create_folder_structure:
        x: 660
        y: 364
      add_parameters:
        x: 666
        y: 139
      is_robot_visible:
        x: 366
        y: 353
      check_if_filename_exists:
        x: 974
        y: 365
      add_parameter:
        x: 358
        y: 143
      add_numbers:
        x: 1307
        y: 368
      string_equals:
        x: 1001
        y: 147
      add_robot_path:
        x: 100
        y: 150
      create_vb_script:
        x: 1305
        y: 157
        navigate:
          83c47325-2a49-d09d-2896-f1352a114a41:
            targetId: fbdddb13-1c72-ade3-566f-e341dcbd36c7
            port: SUCCESS
    results:
      SUCCESS:
        fbdddb13-1c72-ade3-566f-e341dcbd36c7:
          x: 1625
          y: 149
