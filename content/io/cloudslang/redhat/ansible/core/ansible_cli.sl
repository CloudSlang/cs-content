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
#! @description: Run ad-hoc Ansible commands using the Ansible core over ssh.
#!
#! @input ansible_host: Ansible control node fqdn or ip address
#! @input ansible_username: Ansible control node username. Example: root
#! @input ansible_password: Ansible control node user password.
#! @input pattern: The host pattern used when executing the cli.
#!                 Default: 'all'
#! @input inventory: Optional - Specify inventory host path or comma separated host list. If empty Ansible will look
#!                              for the default inventory location defined in the Ansible configuration file.
#! @input subset: Optional - Further limit selected hosts to an additional pattern.
#! @input ansible_module: Optional - Module name to execute.
#!                        Example: 'ping','command','shell','file', etc.
#!                        Default: 'command'
#! @input module_arguments: Optional - Parameters and options to customize the execution of the specified module, defining its behavior and the task to be performed.
#! @input extra_vars: Optional - Set additional variables as key=value or YAML/JSON, if filename prepend with @
#! @input additional_options: Optional - Add any additional options for the Ansible command.
#!                            Example: -v for extra verbose output
#! @input proxy_host: Optional - Proxy server used to access the host.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - User name used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the proxy_username input value.
#! @input private_key_file: Optional - Path to private key file (OpenSSH type) on the machine where is the worker.
#!                         For security reasons it is recommend that the private key be protected by a passphrase that should be provided through the 'password' input.
#! @input private_key_data: Optional - A string representing the private key (OpenSSH type) used for authenticating the user. This string is usually the content of a private key file.
#!                          The 'privateKeyData' and the 'privateKeyFile' inputs are mutually exclusive.
#!                          For security reasons it is recommend that the private key be protected by a passphrase that should be provided through the 'password' input.
#! @input trust_password: Optional - The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input timeout: Time in milliseconds to wait for the command to complete
#!                 Default: '90000'
#!                 Optional
#! @input connect_timeout: Time in milliseconds to wait for the connection to be made.
#!                         Default value: '10000'
#!                         Optional
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output stdout: The output of the command.
#! @output error_message: An error message in case of failure.
#!
#! @result FAILURE: There was an error while executing the flow.
#! @result SUCCESS: The flow executed successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.core.ansible_cli
flow:
  name: ansible_cli
  inputs:
    - ansible_host
    - ansible_username
    - ansible_password:
        sensitive: true
    - pattern: all
    - inventory:
        required: false
    - subset:
        required: false
    - ansible_module:
        default: ping
        required: false
    - module_arguments:
        required: false
    - extra_vars:
        required: false
    - additional_options:
        default: '-v'
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - private_key_data:
        required: false
    - known_hosts_policy:
        default: allow
        required: false
    - known_hosts_path:
        required: false
    - close_session:
        required: false
    - timeout:
        default: '600000'
        required: false
    - connect_timeout:
        default: '10000'
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - contruct_ssh_command:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.strings.append:
            - origin_string: 'ansible '
            - text: '${pattern}'
        publish:
          - ssh_command: '${new_string}'
        navigate:
          - SUCCESS: check_subset_var
    - ssh_command:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${ansible_host}'
            - command: '${ssh_command}'
            - username: '${ansible_username}'
            - password:
                value: '${ansible_password}'
                sensitive: true
            - private_key_file: '${private_key_file}'
            - private_key_data: '${private_key_data}'
            - known_hosts_policy: '${known_hosts_policy}'
            - known_hosts_path: '${known_hosts_path}'
            - timeout: '${timeout}'
            - connect_timeout: '${connect_timeout}'
            - close_session: '${close_session}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - output: '${return_result}'
          - command_return_code
        navigate:
          - SUCCESS: check_command_return_code
          - FAILURE: on_failure
    - check_command_return_code:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.math.compare_numbers:
            - value1: '${command_return_code}'
            - value2: '0'
        navigate:
          - GREATER_THAN: something_went_wrong
          - EQUALS: SUCCESS
          - LESS_THAN: something_went_wrong
    - something_went_wrong:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.utils.do_nothing:
            - error_message: '${output}'
        publish:
          - error_message
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
    - check_subset_var:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${subset}'
        publish: []
        navigate:
          - IS_NULL: check_intentory_var
          - IS_NOT_NULL: append_subset
    - append_subset:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${ssh_command}'
            - text: "${' -l '+subset}"
        publish:
          - ssh_command: '${new_string}'
        navigate:
          - SUCCESS: check_intentory_var
    - check_intentory_var:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${inventory}'
        navigate:
          - IS_NULL: check_module_var
          - IS_NOT_NULL: append_inventory
    - append_inventory:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${ssh_command}'
            - text: "${' -i '+inventory}"
        publish:
          - ssh_command: '${new_string}'
        navigate:
          - SUCCESS: check_module_var
    - check_module_var:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${ansible_module}'
        navigate:
          - IS_NULL: check_module_args
          - IS_NOT_NULL: append_module
    - append_module:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${ssh_command}'
            - text: "${' -m '+ansible_module}"
        publish:
          - ssh_command: '${new_string}'
        navigate:
          - SUCCESS: check_module_args
    - append_module_args:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${ssh_command}'
            - text: "${' -a \"'+module_arguments+'\"'}"
        publish:
          - ssh_command: '${new_string}'
        navigate:
          - SUCCESS: check_extra_vars
    - check_module_args:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${module_arguments}'
        navigate:
          - IS_NULL: check_extra_vars
          - IS_NOT_NULL: append_module_args
    - check_extra_vars:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${extra_vars}'
        navigate:
          - IS_NULL: check_additional_options
          - IS_NOT_NULL: append_extra_vars
    - append_extra_vars:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${ssh_command}'
            - text: "${' -e \"'+extra_vars+'\"'}"
        publish:
          - ssh_command: '${new_string}'
        navigate:
          - SUCCESS: check_additional_options
    - check_additional_options:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${additional_options}'
        navigate:
          - IS_NULL: ssh_command
          - IS_NOT_NULL: append_additional_options
    - append_additional_options:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${ssh_command}'
            - text: "${' '+additional_options+' '}"
        publish:
          - ssh_command: '${new_string}'
        navigate:
          - SUCCESS: ssh_command
  outputs:
    - error_message: '${error_message}'
    - stdout: '${output}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      append_extra_vars:
        x: 960
        'y': 76
      check_subset_var:
        x: 118
        'y': 242
      append_subset:
        x: 207
        'y': 72
      something_went_wrong:
        x: 478
        'y': 423
        navigate:
          6ec9b37e-fdb7-4fc1-a33c-2eb1a02be78e:
            targetId: e87f8329-f2ad-d5a2-046c-cc583d282bfe
            port: SUCCESS
      append_module_args:
        x: 774
        'y': 70
      check_intentory_var:
        x: 294
        'y': 242
      check_module_var:
        x: 476
        'y': 239
      append_additional_options:
        x: 1040
        'y': 440
      check_command_return_code:
        x: 674
        'y': 424
        navigate:
          390a904f-acf3-8745-17a7-8e17774c9442:
            targetId: c03bc0a5-a290-a627-f56c-bc434ca4c253
            port: EQUALS
      append_module:
        x: 569
        'y': 67
      check_extra_vars:
        x: 880
        'y': 240
      ssh_command:
        x: 868
        'y': 423
      append_inventory:
        x: 382
        'y': 71
      check_module_args:
        x: 667
        'y': 237
      contruct_ssh_command:
        x: 37
        'y': 74
      check_additional_options:
        x: 1040
        'y': 240
    results:
      SUCCESS:
        c03bc0a5-a290-a627-f56c-bc434ca4c253:
          x: 676
          'y': 597
      FAILURE:
        e87f8329-f2ad-d5a2-046c-cc583d282bfe:
          x: 475
          'y': 598

