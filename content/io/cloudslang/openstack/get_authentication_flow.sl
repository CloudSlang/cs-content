#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Authenticates an OpenStack machine.
#
# Inputs:
#   - host - OpenStack machine host
#   - identity_port - optional - port used for OpenStack authentication - Default: 5000
#   - username - OpenStack username
#   - password - OpenStack password
#   - tenant_name - name of the project on OpenStack
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - token - authentication token
#   - tenant - tenantID
#   - return_result - response of the last operation that was executed
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
  name: get_authentication_flow
  inputs:
    - host
    - identity_port:
        default: "'5000'"
    - username
    - password
    - tenant_name
    - proxy_host:
        default: "''"
    - proxy_port:
        default: "''"
  workflow:
    - get_token:
        do:
          openstack_content.get_authentication:
            - host
            - identityPort: identity_port
            - username
            - password
            - tenant_name
            - proxy_host
            - proxy_port
        publish:
          - response_body: return_result
          - return_code
          - error_message

    - parse_authentication:
        do:
          openstack_utils.parse_authentication:
            - json_authentication_response: response_body
        publish:
          - token
          - tenant
          - error_message

  outputs:
    - token
    - tenant
    - return_result: response_body
    - error_message
