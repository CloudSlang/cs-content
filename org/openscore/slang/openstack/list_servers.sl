#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This flow will output a list of servers on an OpenStack machine.
#
#   Inputs:
#       - openstackHost - OpenStack machine IP
#       - openstackIdentityPort - optional - Port used for OpenStack authentication - Default: 5000
#       - openstackComputePort - optional - Port used for OpenStack computations - Default: 8774
#       - openstackUsername - OpenStack username
#       - openstackPassword - OpenStack password
#   Outputs:
#       - serverList
#       - returnResult
#       - errorMessage
####################################################

namespace: org.openscore.slang.openstack

imports:
 openstack_content: org.openscore.slang.openstack
 openstack_utils: org.openscore.slang.openstack.utils

flow:
  name: list_servers
  inputs:
    - openstackHost
    - openstackIdentityPort:
        default: "'5000'"
        required: false
    - openstackComputePort:
        default: "'8774'"
        required: false
    - openstackUsername
    - openstackPassword
  workflow:
    authentication:
      do:
        openstack_content.get_authentication_flow:
          - openstackHost
          - openstackIdentityPort
          - openstackUsername
          - openstackPassword
      publish:
        - token
        - tenant
        - returnResult
        - errorMessage

    get_openstack_servers:
      do:
        openstack_content.get_openstack_servers:
          - host: openstackHost
          - computePort: openstackComputePort
          - token
          - tenant
      publish:
        - responseBody: returnResult
        - returnResult
        - errorMessage

    extract_servers:
      do:
        openstack_utils.extract_servers:
          - server_body: responseBody
      publish:
        - serverList
        - errorMessage

  outputs:
    - serverList
    - returnResult
    - errorMessage