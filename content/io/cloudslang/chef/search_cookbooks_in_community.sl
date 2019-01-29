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
#! @description: Searches for a specific cookbook to download from the community.
#!
#! @input cookbook_name: cookbook name
#! @input knife_host: IP of server with configured knife accessible via SSH, can be main Chef server
#! @input knife_username: SSH username to access server with knife
#! @input knife_privkey: Optional - path to local SSH keyfile for accessing server with knife
#! @input knife_password: Optional - password to access server with knife
#! @input knife_config: Optional - location of knife.rb config file
#!
#! @output knife_result: filtered output of knife command
#! @output raw_result: full STDOUT
#! @output standard_err: Any STDERR
#!
#! @result SUCCESS: command executed successfully
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.chef

imports:
  chef: io.cloudslang.chef

flow:
  name: search_cookbooks_in_community

  inputs:
    - cookbook_name
    - knife_host
    - knife_username
    - knife_privkey:
        required: false
    - knife_password:
        required: false
        sensitive: true
    - knife_config:
        required: false

  workflow:
    - search_cookbooks_in_community:
        do:
          chef.knife_command:
            - knife_cmd: ${'knife cookbook site search ' + cookbook_name + ' --FORMAT=JSON'}
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - raw_result
          - standard_err
          - knife_result

  outputs:
    - knife_result: ${knife_result}
    - raw_result
    - standard_err: ${standard_err}
