#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This flow get authentication and create an OpenStack server.
#
#   Inputs:
#       - host - OpenStack machine host
#       - identityPort - optional - port used for OpenStack authentication - Default: 5000
#       - computePort - optional - port used for OpenStack computations - Default: 8774
#       - imgRef - image reference for of the server to be created
#       - username - OpenStack username
#       - password - OpenStack password
#       - serverName - server name
#   Outputs:
#       - returnResult - response of the last operation that was executed
#       - errorMessage - error message for the operation that fails
####################################################

namespace: org.openscore.slang.openstack

imports:
 openstack_content: org.openscore.slang.openstack

flow:
  name: create_openstack_server_flow
  inputs:
    - host
    - identityPort:
        default: "'5000'"
        required: false
    - computePort:
        default: "'8774'"
        required: false
    - imgRef
    - username
    - password
    - serverName
  workflow:
    authentication:
      do:
        openstack_content.get_authentication_flow:
          - openstackHost: host
          - openstackIdentityPort: identityPort
          - openstackUsername: username
          - openstackPassword: password
      publish:
        - token
        - tenant
        - returnResult
        - errorMessage
    create_server:
      do:
        openstack_content.create_openstack_server:
          - host
          - computePort
          - token
          - tenant
          - imgRef
          - serverName
      publish:
        - returnResult
        - errorMessage
  outputs:
    - returnResult
    - errorMessage


