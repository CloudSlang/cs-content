#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Checks if an OpenStack server exists.
#
# Inputs:
#   - host - OpenStack machine host
#   - identity_port - optional - port used for OpenStack authentication - Default: 5000
#   - compute_port - optional - port used for OpenStack computations - Default: 8774
#   - username - OpenStack username
#   - password - OpenStack password
#   - server_name - server name to check
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - response of the last operation executed
#   - error_message - error message of the operation that failed
# Results:
#   - SUCCESS
#   - FAILURE
####################################################

namespace: io.cloudslang.openstack

imports:
 openstack_utils: io.cloudslang.openstack.utils
 openstack_content: io.cloudslang.openstack

flow:
  name: validate_server_exists
  inputs:
    - host
    - identity_port:
        default: "'5000'"
    - compute_port:
        default: "'8774'"
    - username
    - password
    - tenant_name
    - proxy_host:
        default: "''"
    - proxy_port:
        default: "''"
    - server_name
  workflow:
    - get_server_list:
        do:
          openstack_content.list_servers:
            - host
            - identity_port
            - compute_port
            - username
            - password
            - tenant_name
            - proxy_host
            - proxy_port
        publish:
          - server_list
          - return_result
          - error_message
    - check_server:
        do:
          openstack_utils.check_server:
            - server_to_find: server_name
            - server_list
        publish:
          - return_result
          - error_message
  outputs:
    - return_result
    - error_message


