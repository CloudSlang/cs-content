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
#! @description: Verifies whether session recovery mechanism is enabled, if there are tries left
#!               and in such case checks whether the ssh session failed with a certain pattern.
#!
#! @input enabled: Whether session recovery is enabled.
#!                 Default: 'true'
#!                 Optional
#! @input retries: Limit of reconnect tries.
#! @input return_result: From SSH: STDOUT of the remote machine in case of success or the cause of the error in case of
#!                       exception.
#!                       Optional
#! @input return_code: From SSH: '0' if SSH session , different than '0' otherwise.
#! @input exit_status: From SSH: Return code of the remote command.
#!
#! @output updated_retries: Updated input value (decreased by 1).
#!
#! @result RECOVERY_DISABLED: Session recovery is disabled.
#! @result TIMEOUT: No more retries are available.
#! @result SESSION_IS_DOWN: Session failure pattern detected.
#! @result FAILURE_WITH_NO_MESSAGE: Session failure pattern detected.
#! @result CUSTOM_FAILURE: General accumulator for new types of patterns (see subflow).
#! @result NO_ISSUE_FOUND: No session failure pattern was detected.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.utils

imports:
  ssh: io.cloudslang.base.ssh
  math: io.cloudslang.base.math
  utils: io.cloudslang.base.utils

flow:
  name: handle_session_recovery

  inputs:
    - enabled:
       default: 'true'
       required: false
    - retries
    - return_result:
        required: false
    - return_code
    - exit_status:
        required: false

  workflow:
    - check_enabled:
        do:
          utils.is_true:
            - bool_value: ${ enabled }
        navigate:
          - 'TRUE': check_retries
          - 'FALSE': RECOVERY_DISABLED

    - check_retries:
        do:
          math.compare_numbers:
            - value1: ${ retries }
            - value2: "0"
            - retries
        publish:
          - retries: ${ str(int(retries) - 1) }
        navigate:
          - GREATER_THAN: check_unstable_session
          - EQUALS: TIMEOUT
          - LESS_THAN: TIMEOUT

    - check_unstable_session:
        do:
          ssh.check_ssh_unstable_session:
            - return_result
            - return_code
            - exit_status
        navigate:
          - SESSION_IS_DOWN: SESSION_IS_DOWN
          - FAILURE_WITH_NO_MESSAGE: FAILURE_WITH_NO_MESSAGE
          - CUSTOM_FAILURE: CUSTOM_FAILURE
          - NO_ISSUE_FOUND: NO_ISSUE_FOUND

  outputs:
    - updated_retries: ${retries}

  results:
    - RECOVERY_DISABLED
    - TIMEOUT
    - SESSION_IS_DOWN
    - FAILURE_WITH_NO_MESSAGE
    - CUSTOM_FAILURE
    - NO_ISSUE_FOUND
