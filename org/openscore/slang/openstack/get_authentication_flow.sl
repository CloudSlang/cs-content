#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This flow will authenticate on an OpenStack machine.
#
#   Inputs:
#       - openstack_host - OpenStack machine host
#       - openstack_identity_port - optional - port used for OpenStack authentication - Default: 5000
#       - openstack_username - OpenStack username
#       - openstack_password - OpenStack password
#   Outputs:
#       - token - authentication token
#       - tenant - tenantID
#       - return_result - response of the last operation that was executed
#       - error_message - error message of the operation that failed
####################################################

namespace: org.openscore.slang.openstack

imports:
 openstack_content: org.openscore.slang.openstack
 openstack_utils: org.openscore.slang.openstack.utils

flow:
  name: get_authentication_flow
  inputs:
    - openstack_host
    - openstack_identity_port:
        default: "'5000'"
    - openstack_username
    - openstack_password
  workflow:
    get_token:
      do:
        openstack_content.get_authentication:
          - host: openstack_host
          - identityPort: openstack_identity_port
          - username: openstack_username
          - password: openstack_password
      publish:
        - response_body: return_result
        - return_code
        - error_message

    parse_authentication:
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
