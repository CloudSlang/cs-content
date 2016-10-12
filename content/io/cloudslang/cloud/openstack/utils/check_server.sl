#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Checks that a server name is within a list of server names.
#! @input server_to_find: server name that needs to be found
#! @input server_list: list of servers
#! @output return_result: string notifying if server was found or not
#! @output error_message: message of error if exists
#! @result SUCCESS: server was found
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.cloud.openstack.utils

imports:
 base_strings: io.cloudslang.base.strings

flow:
  name: check_server
  inputs:
    - server_to_find
    - server_list
  workflow:
    - check_server_in_list:
        do:
          base_strings.string_occurrence_counter:
            - string_to_find: ${server_to_find}
            - string_in_which_to_search: ${server_list}
            - ignore_case: 'false'
        publish:
          - return_result

  outputs:
    - return_result
    - error_message: ${'Server was not created.' if return_result <= 1 else ''}