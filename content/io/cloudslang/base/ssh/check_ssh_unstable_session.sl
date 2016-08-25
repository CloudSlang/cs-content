#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Checks whether the ssh session failed with a certain pattern.
#!               Cases:
#!               - session is down: return code = -1, exception is 'Session is down'
#!               - failure with no message: exit status = -1
#!               - socket is not established: return result contains 'socket is not established'
#! @input return_result: from SSH: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @input return_code: from SSH: return code of SSH operation
#! @input exit_status: from SSH: return code of remote command
#! @result SESSION_IS_DOWN: pattern detected
#! @result FAILURE_WITH_NO_MESSAGE: pattern detected
#! @result CUSTOM_FAILURE: general accumulator for new types of patterns
#! @result NO_ISSUE_FOUND: no pattern was detected
#!!#
########################################################################################################################

namespace: io.cloudslang.base.ssh

imports:
  strings: io.cloudslang.base.strings

flow:
  name: check_ssh_unstable_session
  inputs:
    - return_result:
        required: false
    - return_code
    - exit_status:
        required: false
  workflow:
    - check_return_code:
        do:
          strings.string_equals:
            - first_string: '0'
            - second_string: ${ str(return_code) }
        navigate:
          - SUCCESS: NO_ISSUE_FOUND
          - FAILURE: check_session_is_down

    - check_session_is_down:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${ return_result }
            - string_to_find: 'session is down'
        navigate:
          - SUCCESS: SESSION_IS_DOWN
          - FAILURE: check_failure_with_no_message

    - check_failure_with_no_message:
        do:
          strings.string_equals:
            - first_string: '-1'
            - second_string: ${ str(exit_status) }
        navigate:
          - SUCCESS: FAILURE_WITH_NO_MESSAGE
          - FAILURE: check_socket_is_not_established

    - check_socket_is_not_established:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${ return_result }
            - string_to_find: 'socket is not established'
        navigate:
          - SUCCESS: CUSTOM_FAILURE
          - FAILURE: NO_ISSUE_FOUND
  results:
    - SESSION_IS_DOWN
    - FAILURE_WITH_NO_MESSAGE
    - CUSTOM_FAILURE
    - NO_ISSUE_FOUND
