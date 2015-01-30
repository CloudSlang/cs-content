#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will create an OpenStack server.
#
#   Inputs:
#       - host-  OpenStack machine host
#       - computePort - optional - port used for OpenStack computations - Default: 8774
#       - token - OpenStack token obtained after authentication
#       - tenant - OpenStack tenantID obtained after authentication
#       - serverName - server name
#       - imgRef - image reference for of the server to be created
#   Outputs:
#       - return_result - response of the operation
#       - status_code - normal status code is 202
#       - error_message: returnResult if statusCode different than '202'
#   Results:
#       - SUCCESS - operation succeeded (statusCode == '202')
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.openstack

operations:
    - create_openstack_server:
          inputs:
            - host
            - computePort:
                default: "'8774'"
            - token
            - tenant
            - serverName
            - imgRef
            - headers:
                default: "'X-AUTH-TOKEN:' + token"
                override: true
            - url:
                default: "'http://'+ host + ':' + computePort + '/v2/' + tenant + '/servers'"
                override: true
            - body:
                default: "'{\"server\": { \"name\": \"' + serverName + '\" , \"imageRef\": \"' + imgRef + '\", \"flavorRef\":\"2\",\"max_count\":1,\"min_count\":1,\"security_groups\": [ {\"name\": \"default\"}] }}'"
                override: true
            - contentType:
                default: "'application/json'"
                override: true
            - method:
                default: "'post'"
                override: true
          action:
            java_action:
              className: org.openscore.content.httpclient.HttpClientAction
              methodName: execute
          outputs:
            - return_result: returnResult
            - status_code: statusCode
            - error_message: returnResult if statusCode != '202' else ''
          results:
            - SUCCESS : statusCode == '202'
            - FAILURE