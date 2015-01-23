#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will do a REST call which contains a list of OpenStack server in its returnResult
#   (result needs to be parsed).
#
#   Inputs:
#       - host - OpenStack machine host
#       - computePort - optional - port used for OpenStack computations - Default: 8774
#       - token - OpenStack token obtained after authentication
#       - tenant - OpenStack tenantID obtained after authentication
#   Outputs:
#       - returnResult - response of the operation
#       - statusCode - normal statusCode is 202
#       - errorMessage - error message
#   Results:
#       - SUCCESS - operation succeeded (statusCode == '200')
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.openstack

operations:
  - get_openstack_servers:
      inputs:
        - host
        - computePort:
            default: "'8774'"
            required: false
        - token
        - tenant
        - headers:
            default: "'X-AUTH-TOKEN:' + token"
            override: true
        - url:
            default: "'http://'+ host + ':' + computePort + '/v2/' + tenant + '/servers'"
            override: true
        - method:
            default: "'get'"
            override: true
      action:
        java_action:
          className: org.openscore.content.httpclient.HttpClientAction
          methodName: execute
      outputs:
        - returnResult: returnResult
        - statusCode: statusCode
        - errorMessage: returnResult if statusCode != '202' else ''
      results:
        - SUCCESS : statusCode == '200'
        - FAILURE