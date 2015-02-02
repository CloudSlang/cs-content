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
#       - returnResult - response of the operation
#       - statusCode - normal status code is 204
#       - errorMessage: returnResult if statusCode if different than 204
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
        required: false
    - token
    - tenant
    - serverID
    - headers:
        default: "'X-AUTH-TOKEN:' + token"
        override: true
    - url:
        default: "'http://'+ host + ':' + computePort + '/v2/' + tenant + '/servers/' + serverID"
        override: true
    - method:
        default: "'delete'"
        override: true
  action:
    java_action:
      className: org.openscore.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - returnResult: returnResult
    - statusCode: statusCode
    - errorMessage: returnResult if statusCode != '204' else ''
  results:
    - SUCCESS : statusCode == '204'
    - FAILURE