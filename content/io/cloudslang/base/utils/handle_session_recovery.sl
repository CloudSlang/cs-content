#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Verifies whether session recovery mechanism is enabled, if there are tries left
#!               and in such case checks whether the ssh session failed with a certain pattern.
#! @input enabled: optional - whether session recovery is enabled - Default: true
#! @input retries: limit of reconnect tries
#! @input return_result: from SSH: STDOUT of the remote machine in case of success or the cause of the error in case of
#!                       exception
#! @input exception: from SSH: contains the stack trace in case of an exception
#! @input exit_status: from SSH: return code of the remote command
#! @output updated_retries: updated input value (decreased by 1)
#! @result RECOVERY_DISABLED: session recovery is disabled
#! @result TIMEOUT: no more retries are available
#! @result SESSION_IS_DOWN: session failure pattern detected
#! @result FAILURE_WITH_NO_MESSAGE: session failure pattern detected
#! @result CUSTOM_FAILURE: general accumulator for new types of patterns (see subflow)
#! @result NO_ISSUE_FOUND: no session failure pattern was detected
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
    - enabled: True
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
          - SUCCESS: check_retries
          - FAILURE: RECOVERY_DISABLED

    - check_retries:
        do:
          math.compare_numbers:
            - value1: ${ retries }
            - value2: 0
            - retries
        publish:
          - retries: ${ int(retries) - 1 }
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
