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
#! @description: Run ad-hoc Ansible playbooks using the Ansible-playbook cli over ssh.
#!
#! @input ansible_host: Ansible control node fqdn or ip address.
#! @input ansible_username: Ansible control node username.
#!                          Example: root
#! @input ansible_password: Ansible control node user password.
#! @input playbook: The path of the playbook to be executed.
#! @input inventory: Optional - specify inventory host path or comma separated host list. If empty Ansible will look
#!                              for the default inventory location defined in the Ansible configuration file
#! @input subset: Optional - further limit selected hosts to an additional pattern.
#! @input tags: Optional - Only run plays and tasks tagged with these values.
#! @input extra_vars: Optional - set additional variables as key=value or YAML/JSON, if filename prepend with @.
#! @input additional_options: Optional - Add any additional options for the Ansible command. Example: -v for extra verbose output
#! @input proxy_host: Optional - Proxy server used to access the host.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - Username used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the proxy_username input value.
#! @input private_key_file: Optional - Path to private key file (OpenSSH type) on the machine where is the worker.
#!                         For security reasons it is recommended that the private key be protected by a passphrase that should be provided through the 'password' input.
#! @input private_key_data: Optional - A string representing the private key (OpenSSH type) used for authenticating the user. This string is usually the content of a private key file.
#!                          The 'privateKeyData' and the 'privateKeyFile' inputs are mutually exclusive.
#!                          For security reasons it is recommended that the private key be protected by a passphrase that should be provided through the 'password' input.
#! @input known_hosts_policy: The policy used for managing known_hosts file.
#!                            Valid values: 'allow', 'strict', 'add'
#!                            Default value: 'allow'
#!                            Optional
#! @input known_hosts_path: Optional - The path to the known hosts file.
#!                          Default: '{user.home}/.ssh/known_hosts'
#! @input close_session: Optional - If 'false' the SSH session will be cached for future calls of this operation during the
#!                       life of the flow, if 'true' the SSH session used by this operation will be closed
#!                       Valid: 'true', 'false'
#!                       Default: 'false'
#! @input timeout: Optional - Time in milliseconds to wait for the command to complete.
#!                 Default: '90000'
#! @input connect_timeout: Optional - Time in milliseconds to wait for the connection to be made.
#!                         Default value: '10000'
#! @input worker_group: Optional - When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output stdout: STDOUT of the machine in case of successful request, null otherwise.
#! @output stderr: STDERR of the machine in case of successful request, null otherwise.
#! @output error_message: An error message in case of failure.
#! @output command_return_code: The return code of the remote command corresponding to the SSH channel. The return code is
#!                              only available for certain types of channels, and only after the channel was closed
#!                              (more exactly, just before the channel is closed).
#!                              Examples: '0' for a successful command, '-1' if the command was not yet terminated (or this
#!                              channel type has no command), '126' if the command cannot execute.
#!
#! @result FAILURE: There was an error while executing the flow.
#! @result SUCCESS: The flow executed successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.core.ansible_cli
flow:
  name: ansible_playbook_cli
  inputs:
    - ansible_host
    - ansible_username
    - ansible_password:
        sensitive: true
    - playbook
    - inventory:
        required: false
    - subset:
        required: false
    - tags:
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
    - worker_group: RAS_Operator_Path
  workflow:
    - contruct_ssh_command:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: 'ansible-playbook '
            - text: '${playbook}'
        publish:
          - ssh_command: '${new_string}'
        navigate:
          - SUCCESS: check_subset_var
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${ansible_host}'
            - command:
                value: '${ssh_command}'
                sensitive: true
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
          - error_message: '${exception}'
          - command_return_code
          - standard_err
          - standard_out
        navigate:
          - SUCCESS: check_command_return_code
          - FAILURE: on_failure
    - check_command_return_code:
        do:
          io.cloudslang.base.math.compare_numbers:
            - value1: '${command_return_code}'
            - value2: '0'
        navigate:
          - GREATER_THAN: something_went_wrong
          - EQUALS: SUCCESS
          - LESS_THAN: something_went_wrong
    - something_went_wrong:
        do:
          io.cloudslang.base.utils.do_nothing:
            - error_message: '${output}'
        publish:
          - error_message
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
    - check_subset_var:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${subset}'
        publish: []
        navigate:
          - IS_NULL: check_intentory_var
          - IS_NOT_NULL: append_subset
    - append_subset:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${ssh_command}'
            - text: "${' -l '+subset}"
        publish:
          - ssh_command: '${new_string}'
        navigate:
          - SUCCESS: check_intentory_var
    - check_intentory_var:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${inventory}'
        navigate:
          - IS_NULL: check_tags
          - IS_NOT_NULL: append_inventory
    - append_inventory:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${ssh_command}'
            - text: "${' -i '+inventory}"
        publish:
          - ssh_command: '${new_string}'
        navigate:
          - SUCCESS: check_tags
    - append_tags:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${ssh_command}'
            - text: "${' -t \"'+tags+'\"'}"
        publish:
          - ssh_command: '${new_string}'
        navigate:
          - SUCCESS: check_extra_vars
    - check_tags:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${tags}'
        navigate:
          - IS_NULL: check_extra_vars
          - IS_NOT_NULL: append_tags
    - check_extra_vars:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${extra_vars}'
        navigate:
          - IS_NULL: check_additional_options
          - IS_NOT_NULL: append_extra_vars
    - append_extra_vars:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${ssh_command}'
            - text: "${' -e \"'+extra_vars+'\"'}"
        publish:
          - ssh_command:
              value: '${new_string}'
              sensitive: true
        navigate:
          - SUCCESS: check_additional_options
    - check_additional_options:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${additional_options}'
        navigate:
          - IS_NULL: ssh_command
          - IS_NOT_NULL: append_additional_options
    - append_additional_options:
        do:
          io.cloudslang.base.strings.append:
            - origin_string:
                value: '${ssh_command}'
                sensitive: true
            - text: "${' '+additional_options+' '}"
        publish:
          - ssh_command:
              value: '${new_string}'
              sensitive: true
        navigate:
          - SUCCESS: ssh_command
  outputs:
    - error_message: '${error_message}'
    - stdout: '${standard_out}'
    - stderr: '${standard_err}'
    - command_return_code: '${command_return_code}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      append_extra_vars:
        x: 800
        'y': 80
      check_subset_var:
        x: 118
        'y': 242
      append_subset:
        x: 213
        'y': 75
      something_went_wrong:
        x: 301
        'y': 424
        navigate:
          6ec9b37e-fdb7-4fc1-a33c-2eb1a02be78e:
            targetId: e87f8329-f2ad-d5a2-046c-cc583d282bfe
            port: SUCCESS
      check_intentory_var:
        x: 303
        'y': 240
      append_additional_options:
        x: 885
        'y': 425
      check_tags:
        x: 480
        'y': 239
      check_command_return_code:
        x: 485
        'y': 424
        navigate:
          390a904f-acf3-8745-17a7-8e17774c9442:
            targetId: c03bc0a5-a290-a627-f56c-bc434ca4c253
            port: EQUALS
      check_extra_vars:
        x: 677
        'y': 240
      ssh_command:
        x: 682
        'y': 424
      append_inventory:
        x: 388
        'y': 75
      contruct_ssh_command:
        x: 40
        'y': 80
      check_additional_options:
        x: 885
        'y': 237
      append_tags:
        x: 574
        'y': 73
    results:
      SUCCESS:
        c03bc0a5-a290-a627-f56c-bc434ca4c253:
          x: 481
          'y': 609
      FAILURE:
        e87f8329-f2ad-d5a2-046c-cc583d282bfe:
          x: 296
          'y': 609
