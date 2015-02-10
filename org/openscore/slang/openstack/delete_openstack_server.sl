#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will do a REST call which deletes an OpenStack server.
#
#   Inputs:
#       - host - OpenStack machine host
#       - computePort - optional - port used for OpenStack computations - Default: 8774
#       - token - OpenStack token obtained after authentication
#       - tenant - OpenStack tenantID obtained after authentication
#       - serverID - ID of the server to be deleted
#   Outputs:
#       - return_result - response of the operation
#       - status_code - normal status code is 204
#       - error_message: returnResult if statusCode if different than 204
#   Results:
#       - SUCCESS - operation succeeded (statusCode == '204')
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.openstack

operation:
  name: delete_openstack_server
  inputs:
    - host
    - computePort:
        default: "'8774'"
    - token
    - tenant
    - serverID
    - headers:
        default: "'X-AUTH-TOKEN:' + token"
        overridable: false
    - url:
        default: "'http://'+ host + ':' + computePort + '/v2/' + tenant + '/servers/' + serverID"
        overridable: false
    - method:
        default: "'delete'"
        overridable: false
  action:
    java_action:
      className: org.openscore.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - return_result: returnResult
    - status_code: statusCode
    - error_message: returnResult if statusCode != '204' else ''
  results:
    - SUCCESS : statusCode == '204'
    - FAILURE