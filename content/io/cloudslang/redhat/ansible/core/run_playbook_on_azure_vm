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
#! @description: This flow adds a machine to its own inventory and uses the Ansible-playbook CLI over SSH to run the
#!               specified playbook on the provided Azure VM.
#!
#! @input ansible_host: Ansible control node fqdn or ip address.
#! @input ansible_username: Ansible control node username. Example: root
#! @input ansible_password: Ansible control node user password.
#! @input directory_path: The directory path where the new inventory file will be saved and where the ansible_playbook
#!                        is present. Example: /etc/ansible
#! @input ansible_playbook: The name of the ansible playbook under the directory path to be executed. Example: test_playbook.yml.
#! @input target_group: The target group of hosts in Ansible's inventory.
#! @input target_host: The IP address of the target host, or a comma-separated list of IP addresses.
#! @input target_username: The username of the target host.
#! @input target_password: The password of the target host.
#! @input software_name: The name of the software that will be installed. Example: postgres
#! @input private_key_file: Optional - Path to private key file (OpenSSH type) on the machine where is the worker.
#!                          For security reasons it is recommended that the private key be protected by a passphrase
#!                          that should be provided through the 'ansible_password' input.al
#! @input private_key_data: Optional - A string representing the private key (OpenSSH type) used for authenticating the user.
#!                          This string is usually the content of a private key file. The 'privateKeyData' and the
#!                          'privateKeyFile' inputs are mutually exclusive. For security reasons it is recommended that
#!                           the private key be protected by a passphrase that should be provided through the 'ansible_password' input.
#! @input proxy_host: The proxy server used to access the remote machine.
#!                    Optional
#! @input proxy_port: The proxy server port.
#!                    Valid values: -1 and numbers greater than 0.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input proxy_username: The user name used when connecting to the proxy.
#!                        Optional
#! @input known_hosts_policy: The policy used for managing known_hosts file. Valid values: 'allow', 'strict', 'add' Default value: 'allow' Optional
#! @input known_hosts_path: Optional - The path to the known hosts file. Default: '{user.home}/.ssh/known_hosts'al
#! @input close_session: if 'false' the SSH session will be cached for future calls of this operation during the
#!                       life of the flow, if 'true' the SSH session used by this operation will be closed
#!                       Valid: 'true', 'false'
#!                       Default: 'false'
#!                       Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: '..JAVA_HOME/java/lib/security/cacerts'
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#! @input timeout: Time in milliseconds to wait for the ssh commands to complete. Default: '90000' Optional
#! @input connect_timeout: Time in milliseconds to wait for the connection to be made.
#!                         Default value: '10000'
#!                         Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#!
#! @output return_result: This is the primary output used to determine the operation response, specifying whether the operation is successful or not.
#! @output error_message: STDERR of the last ssh command in case of successful request, null otherwise.
#! @output standard_out: STDOUT of the last ssh command in case of successful request, null otherwise.
#! @output command_return_code: The return code of the remote command corresponding to the SSH channel. The return code
#!                              is only available for certain types of channels, and only after the channel was closed
#!                              (more exactly, just before the channel is closed). Examples: '0' for a successful command,
#!                              '-1' if the command was not yet terminated (or this channel type has no command),
#!                              '126' if the command cannot execute.
#!
#! @result SUCCESS: There was an error while executing the flow.
#! @result FAILURE: The flow executed successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.redhat.ansible.core
flow:
  name: run_playbook_on_azure_vm
  inputs:
    - ansible_host
    - ansible_username
    - ansible_password:
        sensitive: true
    - directory_path
    - ansible_playbook
    - target_group
    - target_host
    - target_username
    - target_password:
        sensitive: true
    - software_name
    - private_key_file:
        required: false
    - private_key_data:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - proxy_username:
        required: false
    - known_hosts_policy:
        default: allow
        required: false
    - known_hosts_path:
        required: false
    - close_session:
        required: false
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
    - set_filename:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - target_host: "${target_host.replace('.', '_')}"
            - software_name: '${software_name}'
            - directory_path: '${directory_path}'
        publish:
          - file_name: "${directory_path+'/'+target_host+'_'+software_name}"
        navigate:
          - SUCCESS: add_machine_to_its_own_inventory
          - FAILURE: on_failure
    - add_machine_to_its_own_inventory:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${ansible_host}'
            - command: "${'if [[ ! -f ' + file_name + ' ]]; then\\n'+'cat <<EOF >> ' + file_name + '\\n'+ target_group +':\\n  hosts:\\n    ' + target_host + '\\nEOF\\n'+'echo \"file created ' + file_name + '\"\\n'+'fi'}"
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
          - command_return_code
          - return_result
          - standard_err
          - standard_out
        navigate:
          - SUCCESS: run_playbook_on_azure_vm
          - FAILURE: on_failure
    - run_playbook_on_azure_vm:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${ansible_host}'
            - command: "${'ansible-playbook ' + directory_path + '/' + ansible_playbook + ' -i ' + file_name + ' -u ' + target_username + ' --extra-vars \\\"ansible_become_password=' + target_password + ' ansible_password=' + target_password + '\"'}"
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
          - return_result
          - standard_out
          - standard_err
          - command_return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result: '${return_result}'
    - error_message: '${standard_err}'
    - standard_out: '${standard_out}'
    - command_return_code: '${command_return_code}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      set_filename:
        x: 160
        'y': 280
      add_machine_to_its_own_inventory:
        x: 320
        'y': 280
      run_playbook_on_azure_vm:
        x: 480
        'y': 280
        navigate:
          18c765d3-aee4-c3a3-f3a7-9878b9faaddc:
            targetId: d8236ca8-9308-6690-9f15-3e7d7c61dac0
            port: SUCCESS
    results:
      SUCCESS:
        d8236ca8-9308-6690-9f15-3e7d7c61dac0:
          x: 680
          'y': 280

