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
###################################################################################################
namespace: io.cloudslang.base.os.linux.users

imports:
  users: io.cloudslang.base.os.linux.users
  groups: io.cloudslang.base.os.linux.groups
  ssh: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings

flow:
  name: test_add_ubuntu_user_and_group
  inputs:
    - host
    - root_password
    - group_name: 'test_group'
    - user_name: 'test_user'
    - user_password: 'test_user_password'

  workflow:
    - verify_group_not_exist:
        do:
          groups.verify_group_exist:
            - host
            - root_password
            - group_name
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
          - message
        navigate:
          - SUCCESS: check_group_is_not_present
          - FAILURE: VERIFY_UBUNTU_GROUP_NOT_EXIST_FAILURE

    - check_group_is_not_present:
        do:
          strings.string_equals:
            - first_string: ${'The \"' + group_name + '\" group does not exist.'}
            - second_string: ${message}
        navigate:
          - SUCCESS: add_ubuntu_group
          - FAILURE: CHECK_GROUP_IS_NOT_PRESENT_FAILURE

    - add_ubuntu_group:
        do:
          groups.add_ubuntu_group:
            - host
            - root_password
            - group_name
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          - SUCCESS: verify_group_exist
          - FAILURE: ADD_UBUNTU_GROUP_FAILURE

    - verify_group_exist:
        do:
          groups.verify_group_exist:
            - host
            - root_password
            - group_name
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
          - message
        navigate:
          - SUCCESS: check_group_is_present
          - FAILURE: VERIFY_UBUNTU_GROUP_EXIST_FAILURE

    - check_group_is_present:
        do:
          strings.string_equals:
            - first_string: ${'The \"' + group_name + '\" group exist.'}
            - second_string: ${message}
        navigate:
          - SUCCESS: verify_user_not_exist
          - FAILURE: CHECK_GROUP_IS_PRESENT_FAILURE

    - verify_user_not_exist:
        do:
          users.verify_user_exist:
            - host
            - root_password
            - user_name
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
          - message
        navigate:
          - SUCCESS: check_user_name_not_present
          - FAILURE: VERIFY_USER_NOT_EXIST_FAILURE

    - check_user_name_not_present:
        do:
          strings.string_equals:
            - first_string: ${'The \"' + user_name + '\" user does not exist.'}
            - second_string: ${message}
        navigate:
          - SUCCESS: add_ubuntu_user
          - FAILURE: CHECK_USER_NAME_IS_NOT_PRESENT_FAILURE

    - add_ubuntu_user:
        do:
          users.add_ubuntu_user:
            - host
            - root_password
            - user_name
            - user_password
            - group_name
            - create_home
            - home_path
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          - SUCCESS: verify_user_exist
          - FAILURE: ADD_UBUNTU_USER_FAILURE

    - verify_user_exist:
        do:
          users.verify_user_exist:
            - host
            - root_password
            - user_name
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
          - message
        navigate:
          - SUCCESS: check_user_name_is_present
          - FAILURE: VERIFY_USER_EXIST_FAILURE

    - check_user_name_is_present:
        do:
          strings.string_equals:
            - first_string: ${'The \"' + user_name + '\" user exist.'}
            - second_string: ${message}
        navigate:
          - SUCCESS: verify_connection
          - FAILURE: CHECK_USER_NAME_IS_PRESENT_FAILURE

    - verify_connection:
        do:
          ssh.ssh_flow:
            - host
            - port: '22'
            - username: ${user_name}
            - password: ${user_password}
            - command: ":"
        publish:
          - return_result
          - standard_err
          - standard_out
          - return_code
          - command_return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: VERIFY_CONNECTION_FAILURE

  outputs:
    - return_result
    - standard_err
    - standard_out
    - return_code
    - command_return_code
    - message

  results:
    - SUCCESS
    - VERIFY_UBUNTU_GROUP_NOT_EXIST_FAILURE
    - CHECK_GROUP_IS_NOT_PRESENT_FAILURE
    - ADD_UBUNTU_GROUP_FAILURE
    - VERIFY_UBUNTU_GROUP_EXIST_FAILURE
    - CHECK_GROUP_IS_PRESENT_FAILURE
    - VERIFY_USER_NOT_EXIST_FAILURE
    - CHECK_USER_NAME_IS_NOT_PRESENT_FAILURE
    - ADD_UBUNTU_USER_FAILURE
    - VERIFY_USER_EXIST_FAILURE
    - CHECK_USER_NAME_IS_PRESENT_FAILURE
    - VERIFY_CONNECTION_FAILURE
