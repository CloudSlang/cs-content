#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Retrieves a list of servers on an OpenStack machine.
#
# Inputs:
#   - openstack_host - OpenStack machine host
#   - openstack_identity_port - optional - port used for OpenStack authentication - Default: 5000
#   - openstack_compute_port - optional - port used for OpenStack computations - Default: 8774
#   - openstack_username - OpenStack username
#   - openstack_password - OpenStack password
# Outputs:
#   - server_list - list of server names
#   - return_result - response of the last operation executed
#   - error_message - error message of the operation that failed
# Results:
#   - SUCCESS
#   - FAILURE
####################################################

namespace: io.cloudslang.openstack

imports:
 openstack_content: io.cloudslang.openstack
 openstack_utils: io.cloudslang.openstack.utils

flow:
  name: list_servers
  inputs:
    - openstack_host
    - openstack_identity_port:
        default: "'5000'"
    - openstack_compute_port:
        default: "'8774'"
    - openstack_username
    - openstack_password
  workflow:
    - authentication:
        do:
          openstack_content.get_authentication_flow:
            - host: openstack_host
            - identity_port: openstack_identity_port
            - username: openstack_username
            - password: openstack_password
        publish:
          - token
          - tenant
          - return_result
          - error_message

    - get_openstack_servers:
        do:
          openstack_content.get_openstack_servers:
            - host: openstack_host
            - computePort: openstack_compute_port
            - token
            - tenant
        publish:
          - response_body: return_result
          - return_result: return_result
          - error_message

    - extract_servers:
        do:
          openstack_utils.extract_servers:
            - server_body: response_body
        publish:
          - server_list
          - error_message

  outputs:
    - server_list
    - return_result
    - error_message