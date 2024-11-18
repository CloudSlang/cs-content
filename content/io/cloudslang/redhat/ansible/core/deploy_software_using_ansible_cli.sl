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
#!
#! @description: This flow deploys software using the Ansible-playbook CLI over SSH by specifying the target host and the playbook to execute.
#!
#! @input ansible_host: Ansible control node fqdn or ip address.
#! @input ansible_username: Ansible control node username.
#!                          Example: root
#! @input ansible_password: Ansible control node user password.
#! @input install_software_playbook: The path to a playbook or a comma-separated list of playbook paths to be executed in sequence.
#! @input software_name: The name of the software that will be installed.
#!                       Example: postgres
#! @input directory_path: The directory path where the new inventory file will be saved.
#!                        Example: /etc/ansible
#! @input target_group: Optional - The target group oh hosts in Ansible's inventory.
#! @input target_host: The IP address of the target host, or a comma-separated list of IP addresses.
#! @input target_username: The username of the target host.
#! @input target_password: Optional - The password of the target host.
#! @input target_private_key_file: Optional - Path to the target host private key file (OpenSSH type) on the machine where is the worker.
#!                                 For security reasons it is recommended that the private key be protected by a passphrase that should be provided through the 'target_password' input.
#! @input proxy_host: Optional - Proxy server used to access the host.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - Username used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the proxy_username input value.
#! @input private_key_file: Optional - Path to private key file (OpenSSH type) on the machine where is the worker.
#!                          For security reasons it is recommended that the private key be protected by a passphrase that should be provided through the 'ansible_password' input.
#! @input private_key_data: Optional - A string representing the private key (OpenSSH type) used for authenticating the user. This string is usually the content of a private key file.
#!                          The 'privateKeyData' and the 'privateKeyFile' inputs are mutually exclusive.
#!                          For security reasons it is recommended that the private key be protected by a passphrase that should be provided through the 'ansible_password' input.
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
#! @input timeout: Time in milliseconds to wait for the ssh commands to complete.
#!                 Default: '90000'
#!                 Optional
#! @input connect_timeout: Time in milliseconds to wait for the shh connections to be made.
#!                         Default value: '10000'
#!                         Optional
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output stdout: STDOUT of the last ssh command in case of successful request, null otherwise.
#! @output stderr: STDERR of the last ssh command in case of successful request, null otherwise.
#! @output error_message: An error message in case of failure.
#! @output command_return_code: The return code of the remote command corresponding to the SSH channel. The return code is
#!                              only available for certain types of channels, and only after the channel was closed
#!                              (more exactly, just before the channel is closed).
#!                              Examples: '0' for a successful command, '-1' if the command was not yet terminated (or this
#!                              channel type has no command), '126' if the command cannot execute.
#!
#! @result FAILURE: There was an error while executing the flow.
#! @result SUCCESS: The flow executed successfully.
#!
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.core
flow:
  name: deploy_software_using_ansible_cli
  inputs:
    - ansible_host
    - ansible_username
    - ansible_password:
        sensitive: true
    - install_software_playbook
    - software_name
    - directory_path
    - target_group:
        required: false
    - target_host
    - target_username
    - target_password:
        required: false
        sensitive: true
    - target_private_key_file:
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
    - get_first_host:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${target_host}'
            - delimiter: ','
            - index: '0'
        publish:
          - first_target_host: '${return_result}'
        navigate:
          - SUCCESS: append_target_host
          - FAILURE: on_failure
    - target_password_is_null:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${target_password}'
        navigate:
          - IS_NULL: target_private_key_is_null
          - IS_NOT_NULL: target_private_key_is_null_1
    - append_target_host:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${directory_path}'
            - text: "${'/'+first_target_host}"
        publish:
          - inventory_file_path: '${new_string}'
        navigate:
          - SUCCESS: append_software_name
    - append_software_name:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${inventory_file_path}'
            - text: "${'_'+software_name+'.ini'}"
        publish:
          - inventory_file_path: '${new_string}'
          - inventory_content: ''
        navigate:
          - SUCCESS: target_group_is_null
    - ssh_command:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${ansible_host}'
            - command: "${'cat > '+inventory_file_path+' << EOF\\n'+inventory_content+'\\nEOF'}"
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
          - stdout: '${standard_out}'
          - stderr: '${standard_err}'
          - error_message: '${exception}'
          - command_return_code
        navigate:
          - SUCCESS: target_password_is_null
          - FAILURE: on_failure
    - append_group:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${inventory_content}'
            - text: "${'['+target_group+']'+'\\n'}"
        publish:
          - inventory_content: '${new_string}'
        navigate:
          - SUCCESS: list_iterator
    - target_group_is_null:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${target_group}'
        navigate:
          - IS_NULL: list_iterator
          - IS_NOT_NULL: append_group
    - ansible_playbook_cli_with_target_password:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.redhat.ansible.core.ansible_playbook_cli:
            - ansible_host: '${ansible_host}'
            - ansible_username: '${ansible_username}'
            - ansible_password:
                value: '${ansible_password}'
                sensitive: true
            - playbook: '${playbook}'
            - inventory: '${inventory_file_path}'
            - target_username: '${target_username}'
            - extra_vars:
                value: "${'ansible_password='+target_password+' ansible_become_password='+target_password}"
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - private_key_file: '${private_key_file}'
            - private_key_data: '${private_key_data}'
            - known_hosts_policy: '${known_hosts_policy}'
            - known_hosts_path: '${known_hosts_path}'
            - close_session: '${close_session}'
            - timeout: '${timeout}'
            - connect_timeout: '${connect_timeout}'
        publish:
          - error_message
          - stdout
          - stderr
          - command_return_code
        navigate:
          - SUCCESS: iterate_playbooks
          - FAILURE: on_failure
    - ansible_playbook_cli_with_private_key:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.redhat.ansible.core.ansible_playbook_cli:
            - ansible_host: '${ansible_host}'
            - ansible_username: '${ansible_username}'
            - ansible_password:
                value: '${ansible_password}'
                sensitive: true
            - playbook: '${playbook}'
            - inventory: '${inventory_file_path}'
            - target_username: '${target_username}'
            - extra_vars: "${'ansible_ssh_private_key_file='+target_private_key_file}"
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - private_key_file: '${private_key_file}'
            - private_key_data: '${private_key_data}'
            - known_hosts_policy: '${known_hosts_policy}'
            - known_hosts_path: '${known_hosts_path}'
            - close_session: '${close_session}'
            - timeout: '${timeout}'
            - connect_timeout: '${connect_timeout}'
        publish:
          - error_message
          - stdout
          - stderr
          - command_return_code
        navigate:
          - SUCCESS: iterate_playbooks_2
          - FAILURE: on_failure
    - target_private_key_is_null:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${target_private_key_file}'
        navigate:
          - IS_NULL: return_error
          - IS_NOT_NULL: iterate_playbooks_2
    - return_error:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.utils.do_nothing: []
        publish:
          - error_message: 'At least one of the following inputs must be provided: target_password or target_private_key_file. Neither should be empty'
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
    - target_private_key_is_null_1:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${target_private_key_file}'
        navigate:
          - IS_NULL: iterate_playbooks
          - IS_NOT_NULL: iterate_playbooks_1
    - ansible_playbook_cli_with_private_key_and_passphrase:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.redhat.ansible.core.ansible_playbook_cli:
            - ansible_host: '${ansible_host}'
            - ansible_username: '${ansible_username}'
            - ansible_password:
                value: '${ansible_password}'
                sensitive: true
            - playbook: '${playbook}'
            - inventory: '${inventory_file_path}'
            - target_username: '${target_username}'
            - extra_vars:
                value: "${'ansible_ssh_private_key_file='+target_private_key_file+' ansible_ssh_passphrase='+target_password}"
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - private_key_file: '${private_key_file}'
            - private_key_data: '${private_key_data}'
            - known_hosts_policy: '${known_hosts_policy}'
            - known_hosts_path: '${known_hosts_path}'
            - close_session: '${close_session}'
            - timeout: '${timeout}'
            - connect_timeout: '${connect_timeout}'
        publish:
          - error_message
          - stdout
          - stderr
          - command_return_code
        navigate:
          - SUCCESS: iterate_playbooks_1
          - FAILURE: on_failure
    - iterate_playbooks_1:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${install_software_playbook}'
        publish:
          - playbook: '${result_string}'
        navigate:
          - HAS_MORE: ansible_playbook_cli_with_private_key_and_passphrase
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - iterate_playbooks:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${install_software_playbook}'
        publish:
          - playbook: '${result_string}'
        navigate:
          - HAS_MORE: ansible_playbook_cli_with_target_password
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - iterate_playbooks_2:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${install_software_playbook}'
        publish:
          - playbook: '${result_string}'
        navigate:
          - HAS_MORE: ansible_playbook_cli_with_private_key
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
    - list_iterator:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${target_host}'
        publish:
          - host_element: '${result_string}'
        navigate:
          - HAS_MORE: append_host_element
          - NO_MORE: ssh_command
          - FAILURE: on_failure
    - append_host_element:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.strings.append:
            - origin_string: '${inventory_content}'
            - text: "${host_element+'\\n'}"
        publish:
          - inventory_content: '${new_string}'
        navigate:
          - SUCCESS: list_iterator
  outputs:
    - stdout: '${stdout}'
    - stderr: '${stderr}'
    - error_message: '${error_message}'
    - command_return_code: '${command_return_code}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_first_host:
        x: 80
        'y': 80
      iterate_playbooks_1:
        x: 720
        'y': 280
        navigate:
          55f1ae35-3476-2027-cd6e-44dcd16dfe28:
            targetId: 03a89b9b-da5c-831a-1973-68d1f823ad15
            port: NO_MORE
      target_private_key_is_null_1:
        x: 480
        'y': 280
      ansible_playbook_cli_with_private_key:
        x: 920
        'y': 880
      iterate_playbooks_2:
        x: 920
        'y': 680
        navigate:
          01333fc6-279e-dbfc-3509-4f9739d60355:
            targetId: 03a89b9b-da5c-831a-1973-68d1f823ad15
            port: NO_MORE
      target_password_is_null:
        x: 480
        'y': 680
      append_host_element:
        x: 80
        'y': 880
      ansible_playbook_cli_with_target_password:
        x: 480
        'y': 80
      ansible_playbook_cli_with_private_key_and_passphrase:
        x: 720
        'y': 480
      target_group_is_null:
        x: 320
        'y': 400
      list_iterator:
        x: 320
        'y': 880
      append_target_host:
        x: 320
        'y': 80
      iterate_playbooks:
        x: 720
        'y': 80
        navigate:
          a93c3ded-e976-464a-bb76-05da3e0c8616:
            targetId: 03a89b9b-da5c-831a-1973-68d1f823ad15
            port: NO_MORE
      target_private_key_is_null:
        x: 720
        'y': 680
      ssh_command:
        x: 480
        'y': 880
      return_error:
        x: 720
        'y': 880
        navigate:
          a4f6af95-0fd7-3d03-dad7-5fa1a4974e3b:
            targetId: b74d1f5a-a60d-1746-86ef-0609869765f1
            port: SUCCESS
      append_group:
        x: 80
        'y': 560
      append_software_name:
        x: 80
        'y': 320
    results:
      FAILURE:
        b74d1f5a-a60d-1746-86ef-0609869765f1:
          x: 720
          'y': 1080
      SUCCESS:
        03a89b9b-da5c-831a-1973-68d1f823ad15:
          x: 920
          'y': 280

