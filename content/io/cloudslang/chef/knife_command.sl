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
#! @description: Run Chef knife command and return filtered result.
#!
#! @input knife_cmd: Knife command to run.
#!                   Example: 'cookbook list'
#! @input knife_host: IP of server with configured knife accessible via SSH, can be main Chef server.
#! @input knife_username: SSH username to access server with knife.
#! @input knife_password: Optional - password to access server with knife.
#! @input knife_privkey: Optional - Path to local SSH keyfile for accessing server with knife.
#! @input knife_timeout: Optional - timeout in milliseconds.
#!                       Default: '300000'
#! @input knife_config: Optional - Location of knife.rb config file.
#!                      Default: '~/.chef/knife.rb'
#!
#! @output raw_result: Full STDOUT.
#! @output knife_result: Filtered output of knife command.
#! @output standard_err: Any STDERR.
#!
#! @result SUCCESS: Filtered result returned successfully.
#! @result FAILURE: Something went wrong while running knife command.
#!!#
########################################################################################################################

namespace: io.cloudslang.chef

imports:
  ssh: io.cloudslang.base.ssh

flow:
  name: knife_command

  inputs:
    - knife_cmd
    - knife_host
    - knife_username
    - knife_password:
        required: false
        sensitive: true
    - knife_privkey:
        required: false
    - knife_timeout:
        default: '300000'
    - knife_config:
        default: '~/.chef/knife.rb'

  workflow:
    - knife_cmd:
        do:
          ssh.ssh_command:
            - host: ${knife_host}
            - username: ${knife_username}
            - password: ${knife_password}
            - privateKeyFile: ${knife_privkey}
            - command: >
                ${'echo [knife output] &&' +
                'knife ' + knife_cmd + ' --config ' + knife_config}
            - timeout: ${knife_timeout}
        publish:
          - return_result
          - standard_err
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - raw_result: ${return_result}
    - knife_result: ${standard_err + ' ' + return_result.split('[knife output]')[1] if return_result else ""}
    - standard_err

  results:
    - SUCCESS
    - FAILURE
