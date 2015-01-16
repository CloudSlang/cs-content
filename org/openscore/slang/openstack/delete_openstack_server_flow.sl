#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This flow will delete an OpenStack server
#
#   Inputs:
#       - host - OpenStack machine IP
#       - identityPort - optional - Port used for OpenStack authentication - Default: 5000
#       - computePort - optional - Port used for OpenStack computations - Default: 8774
#       - username - OpenStack Username
#       - password - OpenStack Password
#       - serverName - Server name to delete
#   Outputs:
#       - returnResult
#       - errorMessage
####################################################

namespace: org.openscore.slang.openstack

imports:
 openstack_content: org.openscore.slang.openstack
 openstack_utils: org.openscore.slang.openstack.utils
flow:
  name: delete_openstack_server_flow
  inputs:
    - host
    - identityPort:
        default: "'5000'"
        required: false
    - computePort:
        default: "'8774'"
        required: false
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
    get_servers:
      do:
        openstack_content.get_openstack_servers:
          - host
          - computePort
          - token
          - tenant
      publish:
        - server_list: returnResult
        - returnResult
        - errorMessage
    get_server_id:
      do:
        openstack_utils.get_server_id:
          - server_body: server_list
          - server_name: serverName
      publish:
        - serverID
        - returnResult
        - errorMessage
    delete_server:
      do:
        openstack_content.delete_openstack_server:
          - host
          - computePort
          - token
          - tenant
          - serverID
      publish:
        - returnResult
        - errorMessage
  outputs:
    - returnResult
    - errorMessage