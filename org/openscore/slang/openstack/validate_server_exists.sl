#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This flow will check whether or not an OpenStack server exists.
#
#   Inputs:
#       - openstackHost - OpenStack machine IP
#       - openstackIdentityPort - optional - Port used for OpenStack authentication - Default: 5000
#       - openstackComputePort - optional - Port used for OpenStack computations - Default: 8774
#       - openstackUsername - OpenStack Username
#       - openstackPassword - OpenStack Password
#       - serverName - Server name to check
#   Outputs:
#       - returnResult - response of the last operation executed
#       - errorMessage - error message of the operation that failed
####################################################

namespace: org.openscore.slang.openstack

imports:
 base_strings: org.openscore.slang.base.strings
 openstack_content: org.openscore.slang.openstack

flow:
  name: validate_server_exists
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
    - serverName
  workflow:
    get_server_list:
      do:
        openstack_content.list_servers:
          - openstackHost
          - openstackIdentityPort
          - openstackComputePort
          - openstackUsername
          - openstackPassword
      publish:
        - serverList
        - returnResult
        - errorMessage
    check_server:
      do:
        base_strings.string_occurrence_counter:
          - toFind: serverName
          - container: serverList
          - ignoreCase: "'true'"
      publish:
        - returnResult
        - errorMessage
  outputs:
    - returnResult
    - errorMessage


