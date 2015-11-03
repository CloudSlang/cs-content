#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Retrieves the list of flavors from an OpenStack machine.
#
# Inputs:
#   - host - OpenStack machine host
#   - identity_port - optional - port used for OpenStack authentication - Default: 5000
#   - compute_port - optional - port used for OpenStack computations - Default: 8774
#   - username - OpenStack username
#   - password - OpenStack password
#   - tenant_name - name of the project on OpenStack
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - flavor_list - list of flavor names
#   - return_result - response of the last operation executed
#   - error_message - error message of the operation that failed
# Results:
#   - SUCCESS
#   - FAILURE
####################################################

namespace: io.cloudslang.openstack.flavor

imports:
 openstack_content: io.cloudslang.openstack
 openstack_flavor: io.cloudslang.openstack.flavor


flow:
  name: list_openstack_flavors_flow
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
        required: false
    - proxy_port:
        required: false
  workflow:
    - authentication:
        do:
          openstack_content.get_authentication_flow:
            - host
            - identity_port
            - username
            - password
            - tenant_name
            - proxy_host:
                required: false
            - proxy_port:
                required: false
        publish:
          - token
          - tenant
          - return_result
          - error_message

    - list_openstack_flavors:
        do:
          openstack_flavor.list_openstack_flavors:
            - host
            - compute_port
            - token
            - tenant
            - proxy_host:
                required: false
            - proxy_port:
                required: false
        publish:
          - response_body: return_result
          - flavor_list: return_result
          - error_message

    - extract_flavors:
        do:
          openstack_flavor.extract_flavor_list_from_json_response:
            - response_body
            - object_name: "'flavors'"
        publish:
          - object_list
          - error_message


  outputs:
    - flavor_list: object_list
    - return_result
    - error_message