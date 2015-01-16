#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This flow will authenticate on an OpenStack machine
#
#   Inputs:
#       - openstackHost - OpenStack machine IP
#       - openstackIdentityPort - optional - Port used for OpenStack authentication - Default: 5000
#       - openstackUsername - OpenStack username
#       - openstackPassword - OpenStack password
#   Outputs:
#       - token - authentication token
#       - tenant - tenantID
#       - returnResult
#       - errorMessage
####################################################

namespace: org.openscore.slang.openstack

imports:
 openstack_content: org.openscore.slang.openstack
 openstack_utils: org.openscore.slang.openstack.utils

flow:
  name: get_authentication_flow
  inputs:
    - openstackHost
    - openstackIdentityPort:
        default: "'5000'"
        required: false
    - openstackUsername
    - openstackPassword
  workflow:
    get_token:
      do:
        openstack_content.get_authentication:
          - host: openstackHost
          - identityPort: openstackIdentityPort
          - username: openstackUsername
          - password: openstackPassword
      publish:
        - response_body: returnResult
        - returnCode
        - errorMessage

    parse_authentication:
      do:
        openstack_utils.parse_authentication:
          - jsonAuthenticationResponse: response_body
      publish:
        - token
        - tenant
        - errorMessage

  outputs:
    - token
    - tenant
    - returnResult: response_body
    - errorMessage
