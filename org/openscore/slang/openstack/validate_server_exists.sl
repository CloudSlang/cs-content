#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This flow will check whether or not an OpenStack server exists.
#
#   Inputs:
#       - openstack_host - OpenStack machine host
#       - openstack_identity_port - optional - port used for OpenStack authentication - Default: 5000
#       - openstack_compute_port - optional - port used for OpenStack computations - Default: 8774
#       - openstack_username - OpenStack username
#       - openstack_password - OpenStack password
#       - server_name - server name to check
#   Outputs:
#       - return_result - response of the last operation executed
#       - error_message - error message of the operation that failed
####################################################

namespace: org.openscore.slang.openstack

imports:
 base_strings: org.openscore.slang.base.strings
 openstack_content: org.openscore.slang.openstack

flow:
  name: validate_server_exists
  inputs:
    - openstack_host
    - openstack_identity_port:
        default: "'5000'"
    - openstack_compute_port:
        default: "'8774'"
    - openstack_username
    - openstack_password
    - server_name
  workflow:
    - get_server_list:
        do:
          openstack_content.list_servers:
            - openstack_host
            - openstack_identity_port
            - openstack_compute_port
            - openstack_username
            - openstack_password
        publish:
          - server_list
          - return_result
          - error_message
    - check_server:
        do:
          base_strings.string_occurrence_counter:
            - string_to_find: server_name
            - string_in_which_to_search: server_list
            - ignore_case: "'true'"
        publish:
          - return_result
          - error_message
  outputs:
    - return_result
    - error_message


