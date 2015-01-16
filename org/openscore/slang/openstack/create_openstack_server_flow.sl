#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This flow will delete two docker containers
#   Inputs:
#       - host - OpenStack machine IP
#       - identityPort - optional - Port used for OpenStack authentication - Default: 5000
#       - computePort - optional - Port used for OpenStack computations - Default: 8774
#       - imgRef - Image reference for of the server to be created
#       - username - OpenStack username
#       - password - OpenStack password
#       - serverName - Server name
#   Outputs:
#       - returnResult
#       - errorMessage
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


