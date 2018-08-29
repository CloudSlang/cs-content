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
#! @description: This flow returns the parameters of an RPA Robot (UFT Scenario). 
#!               The return value is a list of name:default_value:0/1 input/output objects.
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
#!
#! @output parameters: A list of name:default_value:type objects. Type: 0 - input, 1 - output
#!
#! @result SUCCESS: The operation executed successfully
#! @result FAILURE: The operation could not be executed
#!!#
########################################################################################################################
namespace: io.cloudslang.rpa.uft
flow:
  name: get_robot_parameters
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
  workflow:
    - create_get_robot_params_vb_script:
        do:
          utility.create_get_robot_params_vb_script:
            - host: '${host}'
            - port: '${port}'
            - protocol: '${protocol}'
            - username: '${username}'
            - password: '${password}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - robot_path: '${robot_path}'
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
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - script: "${'invoke-expression \"cmd /C cscript ' + script_name + '\"'}"
        publish:
          - exception
          - return_code
          - stderr
          - script_exit_code
          - parameters: "${return_result.replace('::',':<no_value>:')}"
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
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
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
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - script: "${'Remove-Item \"' + script_name + '\"'}"
        publish:
          - exception
          - return_code
          - stderr
          - script_exit_code
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
  outputs:
    - parameters: '${parameters}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_get_robot_params_vb_script:
        x: 49
        y: 84
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
