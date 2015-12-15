#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#  Verifies whether session recovery mechanism is enabled, if there are tryings left
#  and in such case checks whether the ssh session failed with a certain pattern.
#
#  Inputs:
#    - enabled - whether session recovery is enabled - Default: true
#    - retries - limit of reconnect tryings
#    - return_result - from SSH: STDOUT of the remote machine in case of success or the cause of the error in case of
#                                exception
#    - exception - from SSH: contains the stack trace in case of an exception
#    - exit_status - from SSH: the return code of the remote command
#  Outputs:
#    - retries - updated input value (decreased with 1)
#  Results:
#    - RECOVERY_DISABLED: session recovery is disabled
#    - TIMEOUT - no more retries are available
#    - SESSION_IS_DOWN: session failure pattern detected
#    - FAILURE_WITH_NO_MESSAGE: session failure pattern detected
#    - NO_ISSUE_FOUND: no session failure pattern was detected
########################################################################################################################

namespace: io.cloudslang.base.utils

imports:
  comparisons: io.cloudslang.base.math.comparisons

flow:
  name: handle_session_recovery
  inputs:
    - enabled: True
    - retries
    - return_result
    - return_code
    - exit_status
  workflow:
    - check_enabled:
        do:
          is_true:
            - bool_value: ${ enabled }
        navigate:
          SUCCESS: check_retries
          FAILURE: RECOVERY_DISABLED

    - check_retries:
        do:
          comparisons.compare_numbers:
            - value1: ${ retries }
            - value2: 0
        publish:
          - retries: ${ int(self['retries']) - 1 }
        navigate:
          GREATER_THAN: check_unstable_session
          EQUALS: TIMEOUT
          LESS_THAN: TIMEOUT

    - check_unstable_session:
        do:
          check_ssh_unstable_session:
            - return_result
            - return_code
            - exit_status
        navigate:
          SESSION_IS_DOWN: SESSION_IS_DOWN
          FAILURE_WITH_NO_MESSAGE: FAILURE_WITH_NO_MESSAGE
          NO_ISSUE_FOUND: NO_ISSUE_FOUND
  outputs:
    - retries
  results:
    - RECOVERY_DISABLED
    - TIMEOUT
    - SESSION_IS_DOWN
    - FAILURE_WITH_NO_MESSAGE
    - NO_ISSUE_FOUND