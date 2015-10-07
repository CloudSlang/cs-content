#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Deletes an OpenStack keypair.
#
# Inputs:
#   - host - OpenStack machine host
#   - compute_port - optional - port used for OpenStack computations - Default: 8774
#   - token - OpenStack token obtained after authentication
#   - tenant_id - OpenStack tenant id obtained after authentication
#   - keypair_name - name of the keypair to be deleted
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - response of the operation
#   - status_code - normal status code is 202
#   - error_message: returnResult if statusCode != 202
# Results:
#   - SUCCESS - operation succeeded (statusCode == '202')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.openstack.keypair

operation:
  name: delete_openstack_keypair
  inputs:
    - host
    - compute_port:
        default: "'8774'"
    - token
    - tenant_id
    - keypair_name
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxyHost:
        default: "proxy_host if proxy_host else ''"
        required: false
    - proxyPort:
        default: "proxy_port if proxy_port else ''"
        required: false
    - headers:
        default: "'X-AUTH-TOKEN:' + token"
        overridable: false
    - url:
        default: "'http://'+ host + ':' + compute_port + '/v2/' + tenant_id + '/os-keypairs/' + keypair_name"
        overridable: false
    - method:
        default: "'delete'"
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - return_result: "'' if 'returnResult' not in locals() else returnResult"
    - status_code: statusCode
    - error_message: returnResult if statusCode != '202' else ''
  results:
    - SUCCESS: "'statusCode' in locals() and statusCode == '202'"
    - FAILURE